const express = require('express');

const { getPool } = require('../config/database');
const { authMiddleware } = require('../middleware/auth');
const { validateNick } = require('../utils/nick');
const { hashPassword, verifyPassword } = require('../utils/password');
const { publicUser } = require('../utils/profile');

const router = express.Router();

router.patch('/', authMiddleware, async (req, res) => {
  const body = req.body || {};
  const userId = req.authUser.id;

  try {
    const [rows] = await getPool().query(
      `SELECT id, email, nick, nick_normalized, real_name, password_hash
       FROM users WHERE id = ? LIMIT 1`,
      [userId],
    );
    if (!rows.length) {
      return res.status(404).json({ error: 'user not found', code: 'NOT_FOUND' });
    }

    const user = rows[0];
    let nick = user.nick;
    let nickNormalized = user.nick_normalized;
    let realName = user.real_name;
    let passwordHash = user.password_hash;
    let passwordChanged = false;

    if (body.nick != null) {
      const validation = validateNick(body.nick);
      if (!validation.ok) {
        return res.status(400).json({
          error: validation.error,
          code: validation.code,
        });
      }
      if (validation.nickNormalized !== user.nick_normalized) {
        const [taken] = await getPool().query(
          `SELECT id FROM users WHERE nick_normalized = ? AND id <> ? LIMIT 1`,
          [validation.nickNormalized, userId],
        );
        if (taken.length) {
          return res.status(409).json({ error: 'nick taken', code: 'NICK_TAKEN' });
        }
        nick = validation.nick;
        nickNormalized = validation.nickNormalized;
      }
    }

    if (body.realName != null) {
      realName = String(body.realName).trim();
      if (!realName || realName.length > 100) {
        return res.status(400).json({
          error: 'realName required (max 100 chars)',
          code: 'VALIDATION',
        });
      }
    }

    const newPassword =
      body.newPassword != null ? String(body.newPassword) : '';
    if (newPassword.length > 0) {
      if (newPassword.length < 6) {
        return res.status(400).json({
          error: 'newPassword min 6 chars',
          code: 'VALIDATION',
        });
      }
      const currentPassword = String(body.currentPassword || '');
      if (
        !currentPassword ||
        !(await verifyPassword(currentPassword, user.password_hash))
      ) {
        return res.status(401).json({
          error: 'invalid current password',
          code: 'AUTH',
        });
      }
      passwordHash = await hashPassword(newPassword);
      passwordChanged = true;
    }

    await getPool().query(
      `UPDATE users
       SET nick = ?, nick_normalized = ?, real_name = ?, password_hash = ?
       WHERE id = ?`,
      [nick, nickNormalized, realName, passwordHash, userId],
    );

    const profile = { ...(req.authUser.profile || {}), displayName: realName };
    await getPool().query(
      `UPDATE user_profiles SET profile_json = ? WHERE user_id = ?`,
      [JSON.stringify(profile), userId],
    );

    if (passwordChanged) {
      await getPool().query(`DELETE FROM refresh_tokens WHERE user_id = ?`, [
        userId,
      ]);
    }

    return res.json({
      ...publicUser({
        id: userId,
        email: user.email,
        nick,
        real_name: realName,
        email_verified: 1,
      }),
      passwordChanged,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.delete('/', authMiddleware, async (req, res) => {
  try {
    await getPool().query(`DELETE FROM users WHERE id = ?`, [req.authUser.id]);
    return res.json({ message: 'account deleted' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

module.exports = router;
