const { verifyAdminToken } = require('../utils/tokens');

function adminAuthMiddleware(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) {
    return res.status(401).json({ error: 'missing token', code: 'AUTH' });
  }

  try {
    const payload = verifyAdminToken(token);
    req.adminUser = { username: payload.username };
    return next();
  } catch {
    return res.status(401).json({ error: 'invalid admin token', code: 'AUTH' });
  }
}

module.exports = { adminAuthMiddleware };
