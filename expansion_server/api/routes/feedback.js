const express = require('express');

const { getPool } = require('../config/database');
const { sendUserFeedback } = require('../config/email');
const { verifyAccessToken } = require('../utils/tokens');
const { parseProfileRow } = require('../utils/profile');
const { notifyTelegramHtml, formatFeedbackMessage } = require('../utils/telegram');

const router = express.Router();

function normalizeEmail(email) {
  return String(email || '').trim().toLowerCase();
}

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

async function resolveOptionalUser(req) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return null;

  try {
    const payload = verifyAccessToken(token);
    const [rows] = await getPool().query(
      `SELECT u.id, u.email, u.nick, u.real_name, u.email_verified, u.created_at,
              p.profile_json
       FROM users u
       LEFT JOIN user_profiles p ON p.user_id = u.id
       WHERE u.id = ? AND u.email_verified = 1
       LIMIT 1`,
      [payload.sub],
    );
    if (!rows.length) return null;
    return parseProfileRow(rows[0]);
  } catch {
    return null;
  }
}

router.post('/', async (req, res) => {
  const message = String(req.body?.message || '').trim();
  if (message.length < 10 || message.length > 2000) {
    return res.status(400).json({
      error: 'message must be 10-2000 chars',
      code: 'VALIDATION',
    });
  }

  const user = await resolveOptionalUser(req);
  let email;
  let nick;
  let userId;

  if (user) {
    email = user.email;
    nick = user.nick;
    userId = user.id;
  } else {
    email = normalizeEmail(req.body?.email);
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({
        error: 'valid email required for guest feedback',
        code: 'VALIDATION',
      });
    }
  }

  const result = await sendUserFeedback({
    message,
    fromEmail: email,
    nick,
    userId,
    clientMeta: {
      userAgent: req.headers['user-agent'] || '',
    },
  });

  notifyTelegramHtml(
    formatFeedbackMessage({ message, fromEmail: email, nick, userId }),
  ).catch((error) => {
    console.error('telegram feedback notify failed:', error.message);
  });

  if (!result.success) {
    return res.status(503).json({
      error: 'feedback delivery failed',
      code: result.code || 'EMAIL_SEND_FAILED',
    });
  }

  return res.status(201).json({ message: 'feedback sent' });
});

module.exports = router;
