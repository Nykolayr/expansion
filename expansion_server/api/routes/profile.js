const express = require('express');

const { getPool } = require('../config/database');
const { mergeProfileJson } = require('../utils/profile');
const { authMiddleware } = require('../middleware/auth');

const router = express.Router();

function buildProfileResponse(authUser) {
  const profile = authUser.profile || {};
  return {
    email: authUser.email,
    nick: authUser.nick,
    realName: authUser.realName,
    ...profile,
    displayName: profile.displayName ?? authUser.realName,
  };
}

router.get('/', authMiddleware, (req, res) => {
  return res.json(buildProfileResponse(req.authUser));
});

router.put('/', authMiddleware, async (req, res) => {
  const body = req.body || {};

  try {
    const merged = mergeProfileJson(req.authUser.profile, body);

    if (body.realName != null) {
      const realName = String(body.realName).trim();
      if (!realName || realName.length > 100) {
        return res.status(400).json({
          error: 'realName required (max 100 chars)',
          code: 'VALIDATION',
        });
      }
      merged.displayName = realName;
      await getPool().query(`UPDATE users SET real_name = ? WHERE id = ?`, [
        realName,
        req.authUser.id,
      ]);
      req.authUser.realName = realName;
    } else if (body.displayName != null) {
      const displayName = String(body.displayName).trim();
      merged.displayName = displayName;
      await getPool().query(`UPDATE users SET real_name = ? WHERE id = ?`, [
        displayName,
        req.authUser.id,
      ]);
      req.authUser.realName = displayName;
    }

    await getPool().query(
      `UPDATE user_profiles SET profile_json = ? WHERE user_id = ?`,
      [JSON.stringify(merged), req.authUser.id],
    );

    req.authUser.profile = merged;
    return res.json(buildProfileResponse(req.authUser));
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

module.exports = router;
