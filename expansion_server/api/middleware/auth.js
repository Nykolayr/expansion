const { getPool } = require('../config/database');
const { verifyAccessToken } = require('../utils/tokens');
const { parseProfileRow } = require('../utils/profile');

async function authMiddleware(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) {
    return res.status(401).json({ error: 'missing token', code: 'AUTH' });
  }

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

    if (!rows.length) {
      return res.status(404).json({ error: 'user not found', code: 'NOT_FOUND' });
    }

    req.authUser = parseProfileRow(rows[0]);
    return next();
  } catch {
    return res.status(401).json({ error: 'invalid token', code: 'AUTH' });
  }
}

module.exports = { authMiddleware };
