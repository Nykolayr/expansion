const express = require('express');
const crypto = require('crypto');

const { getPool } = require('../config/database');
const { sendVerificationCode, sendPasswordResetCode } = require('../config/email');
const { hashPassword, verifyPassword } = require('../utils/password');
const {
  validateNick,
  normalizeNick,
  hashCode,
  generateSixDigitCode,
} = require('../utils/nick');
const {
  signAccessToken,
  generateRefreshToken,
  hashRefreshToken,
  refreshExpiresAt,
  verificationExpiresAt,
} = require('../utils/tokens');
const {
  defaultProfileJson,
  publicUser,
} = require('../utils/profile');
const { authMiddleware } = require('../middleware/auth');

const router = express.Router();

function normalizeEmail(email) {
  return String(email || '').trim().toLowerCase();
}

async function storeRefreshToken(userId, refreshToken) {
  const id = crypto.randomUUID();
  await getPool().query(
    `INSERT INTO refresh_tokens (id, user_id, token_hash, expires_at)
     VALUES (?, ?, ?, ?)`,
    [id, userId, hashRefreshToken(refreshToken), refreshExpiresAt()],
  );
}

async function issueTokens(userRow) {
  const accessToken = signAccessToken(userRow);
  const refreshToken = generateRefreshToken();
  await storeRefreshToken(userRow.id, refreshToken);
  return {
    accessToken,
    refreshToken,
    user: publicUser(userRow),
  };
}

async function findUserByEmail(email) {
  const [rows] = await getPool().query(
    `SELECT id, email, nick, real_name, password_hash, email_verified, created_at
     FROM users WHERE email = ? LIMIT 1`,
    [email],
  );
  return rows[0] || null;
}

async function isNickTaken(nickNormalized) {
  const [rows] = await getPool().query(
    `SELECT id FROM users WHERE nick_normalized = ? LIMIT 1`,
    [nickNormalized],
  );
  if (rows.length) return true;

  const [pending] = await getPool().query(
    `SELECT id FROM email_verifications
     WHERE nick_normalized = ? AND expires_at > UTC_TIMESTAMP()
     LIMIT 1`,
    [nickNormalized],
  );
  return pending.length > 0;
}

router.get('/nick-available', async (req, res) => {
  const validation = validateNick(req.query.nick);
  if (!validation.ok) {
    return res.json({ available: false, reason: validation.code });
  }

  try {
    const taken = await isNickTaken(validation.nickNormalized);
    return res.json({ available: !taken });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/register', async (req, res) => {
  const email = normalizeEmail(req.body?.email);
  const password = String(req.body?.password || '');
  const realName = String(req.body?.realName || '').trim();
  const nickValidation = validateNick(req.body?.nick);

  if (!email || password.length < 6) {
    return res.status(400).json({
      error: 'email and password (min 6) required',
      code: 'VALIDATION',
    });
  }
  if (!realName || realName.length > 100) {
    return res.status(400).json({
      error: 'realName required (max 100 chars)',
      code: 'VALIDATION',
    });
  }
  if (!nickValidation.ok) {
    return res.status(400).json({
      error: nickValidation.error,
      code: nickValidation.code,
    });
  }

  try {
    const existing = await findUserByEmail(email);
    if (existing) {
      return res.status(409).json({
        error: 'user exists',
        code: 'CONFLICT',
        suggestion: 'login',
      });
    }

    if (await isNickTaken(nickValidation.nickNormalized)) {
      return res.status(409).json({ error: 'nick taken', code: 'NICK_TAKEN' });
    }

    const code = generateSixDigitCode();
    const passwordHash = await hashPassword(password);
    const verificationId = crypto.randomUUID();

    await getPool().query(
      `DELETE FROM email_verifications WHERE email = ?`,
      [email],
    );

    await getPool().query(
      `INSERT INTO email_verifications
       (id, email, code_hash, password_hash, nick, nick_normalized, real_name, expires_at)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        verificationId,
        email,
        hashCode(code),
        passwordHash,
        nickValidation.nick,
        nickValidation.nickNormalized,
        realName,
        verificationExpiresAt(),
      ],
    );

    const emailResult = await sendVerificationCode(email, code, {
      subject: req.body?.emailSubject,
      html: req.body?.emailHtml,
      text: req.body?.emailText,
    });

    if (!emailResult.success) {
      await getPool().query(
        `DELETE FROM email_verifications WHERE id = ?`,
        [verificationId],
      );
      return res.status(503).json({
        error: 'failed to send verification email',
        code: 'EMAIL_SEND_FAILED',
        details: emailResult,
      });
    }

    return res.status(201).json({
      message: 'verification code sent',
      email,
      verificationExpiresAt: verificationExpiresAt().toISOString(),
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/verify-email', async (req, res) => {
  const email = normalizeEmail(req.body?.email);
  const code = String(req.body?.code || '').trim();

  if (!email || !code) {
    return res.status(400).json({
      error: 'email and code required',
      code: 'VALIDATION',
    });
  }

  const connection = await getPool().getConnection();
  try {
    await connection.beginTransaction();

    const [rows] = await connection.query(
      `SELECT * FROM email_verifications
       WHERE email = ? AND code_hash = ? AND expires_at > UTC_TIMESTAMP()
       ORDER BY created_at DESC
       LIMIT 1`,
      [email, hashCode(code)],
    );

    if (!rows.length) {
      await connection.rollback();
      return res.status(400).json({
        error: 'invalid or expired code',
        code: 'INVALID_CODE',
      });
    }

    const verification = rows[0];

    const [existingUsers] = await connection.query(
      `SELECT id FROM users WHERE email = ? OR nick_normalized = ? LIMIT 1`,
      [email, verification.nick_normalized],
    );
    if (existingUsers.length) {
      await connection.rollback();
      return res.status(409).json({ error: 'user exists', code: 'CONFLICT' });
    }

    const userId = crypto.randomUUID();
    await connection.query(
      `INSERT INTO users
       (id, email, nick, nick_normalized, real_name, password_hash, email_verified)
       VALUES (?, ?, ?, ?, ?, ?, 1)`,
      [
        userId,
        email,
        verification.nick,
        verification.nick_normalized,
        verification.real_name,
        verification.password_hash,
      ],
    );

    const profileJson = defaultProfileJson(verification.real_name);
    await connection.query(
      `INSERT INTO user_profiles (user_id, profile_json) VALUES (?, ?)`,
      [userId, JSON.stringify(profileJson)],
    );

    await connection.query(
      `DELETE FROM email_verifications WHERE email = ?`,
      [email],
    );

    await connection.commit();

    const userRow = {
      id: userId,
      email,
      nick: verification.nick,
      real_name: verification.real_name,
      email_verified: 1,
    };

    const tokens = await issueTokens(userRow);
    return res.status(201).json(tokens);
  } catch (error) {
    await connection.rollback();
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  } finally {
    connection.release();
  }
});

router.post('/login', async (req, res) => {
  const email = normalizeEmail(req.body?.email);
  const password = String(req.body?.password || '');

  if (!email || !password) {
    return res.status(400).json({
      error: 'email and password required',
      code: 'VALIDATION',
    });
  }

  try {
    const user = await findUserByEmail(email);
    if (!user || !(await verifyPassword(password, user.password_hash))) {
      return res.status(401).json({
        error: 'invalid credentials',
        code: 'AUTH',
      });
    }
    if (!user.email_verified) {
      return res.status(403).json({
        error: 'email not verified',
        code: 'EMAIL_NOT_VERIFIED',
      });
    }

    const tokens = await issueTokens(user);
    return res.json(tokens);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/refresh', async (req, res) => {
  const refreshToken = String(req.body?.refreshToken || '');
  if (!refreshToken) {
    return res.status(400).json({
      error: 'refreshToken required',
      code: 'VALIDATION',
    });
  }

  try {
    const tokenHash = hashRefreshToken(refreshToken);
    const [rows] = await getPool().query(
      `SELECT rt.id AS token_id, rt.user_id, u.email, u.nick, u.real_name, u.email_verified
       FROM refresh_tokens rt
       INNER JOIN users u ON u.id = rt.user_id
       WHERE rt.token_hash = ? AND rt.expires_at > UTC_TIMESTAMP()
       LIMIT 1`,
      [tokenHash],
    );

    if (!rows.length) {
      return res.status(401).json({
        error: 'invalid refresh token',
        code: 'AUTH',
      });
    }

    const row = rows[0];
    await getPool().query(`DELETE FROM refresh_tokens WHERE id = ?`, [
      row.token_id,
    ]);

    const tokens = await issueTokens(row);
    return res.json(tokens);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/forgot-password', async (req, res) => {
  const email = normalizeEmail(req.body?.email);
  if (!email) {
    return res.status(400).json({ error: 'email required', code: 'VALIDATION' });
  }

  try {
    const user = await findUserByEmail(email);
    if (!user || !user.email_verified) {
      return res.json({ message: 'if account exists, reset code sent' });
    }

    const code = generateSixDigitCode();
    const resetId = crypto.randomUUID();

    await getPool().query(`DELETE FROM password_reset_codes WHERE email = ?`, [
      email,
    ]);
    await getPool().query(
      `INSERT INTO password_reset_codes (id, email, code_hash, expires_at)
       VALUES (?, ?, ?, ?)`,
      [resetId, email, hashCode(code), verificationExpiresAt()],
    );

    const emailResult = await sendPasswordResetCode(email, code, {
      subject: req.body?.emailSubject,
      html: req.body?.emailHtml,
      text: req.body?.emailText,
    });

    if (!emailResult.success) {
      await getPool().query(`DELETE FROM password_reset_codes WHERE id = ?`, [
        resetId,
      ]);
      return res.status(503).json({
        error: 'failed to send reset email',
        code: 'EMAIL_SEND_FAILED',
        details: emailResult,
      });
    }

    return res.json({ message: 'if account exists, reset code sent' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/reset-password', async (req, res) => {
  const email = normalizeEmail(req.body?.email);
  const code = String(req.body?.code || '').trim();
  const newPassword = String(req.body?.newPassword || '');

  if (!email || !code || newPassword.length < 6) {
    return res.status(400).json({
      error: 'email, code and newPassword (min 6) required',
      code: 'VALIDATION',
    });
  }

  try {
    const [rows] = await getPool().query(
      `SELECT id FROM password_reset_codes
       WHERE email = ? AND code_hash = ? AND expires_at > UTC_TIMESTAMP()
       ORDER BY created_at DESC LIMIT 1`,
      [email, hashCode(code)],
    );

    if (!rows.length) {
      return res.status(400).json({
        error: 'invalid or expired code',
        code: 'INVALID_CODE',
      });
    }

    const passwordHash = await hashPassword(newPassword);
    await getPool().query(`UPDATE users SET password_hash = ? WHERE email = ?`, [
      passwordHash,
      email,
    ]);
    await getPool().query(`DELETE FROM password_reset_codes WHERE email = ?`, [
      email,
    ]);

    const user = await findUserByEmail(email);
    if (user) {
      await getPool().query(`DELETE FROM refresh_tokens WHERE user_id = ?`, [
        user.id,
      ]);
    }

    return res.json({ message: 'password updated' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.get('/me', authMiddleware, (req, res) => {
  return res.json({
    ...publicUser({
      id: req.authUser.id,
      email: req.authUser.email,
      nick: req.authUser.nick,
      real_name: req.authUser.realName,
      email_verified: req.authUser.emailVerified,
    }),
    profile: req.authUser.profile,
  });
});

router.post('/logout', authMiddleware, async (req, res) => {
  const refreshToken = String(req.body?.refreshToken || '');
  try {
    if (refreshToken) {
      await getPool().query(
        `DELETE FROM refresh_tokens WHERE token_hash = ? AND user_id = ?`,
        [hashRefreshToken(refreshToken), req.authUser.id],
      );
    } else {
      await getPool().query(`DELETE FROM refresh_tokens WHERE user_id = ?`, [
        req.authUser.id,
      ]);
    }
    return res.json({ message: 'logged out' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

module.exports = router;
