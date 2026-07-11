const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const JWT_SECRET = process.env.JWT_SECRET || 'dev-only-change-me';
const ACCESS_TTL = process.env.JWT_ACCESS_TTL || '1h';
const REFRESH_TTL_DAYS = Number(process.env.JWT_REFRESH_DAYS || 30);

function signAccessToken(user) {
  return jwt.sign(
    {
      sub: user.id,
      email: user.email,
      nick: user.nick,
    },
    JWT_SECRET,
    { expiresIn: ACCESS_TTL },
  );
}

function verifyAccessToken(token) {
  return jwt.verify(token, JWT_SECRET);
}

function generateRefreshToken() {
  return crypto.randomBytes(32).toString('hex');
}

function hashRefreshToken(token) {
  return crypto.createHash('sha256').update(token).digest('hex');
}

function refreshExpiresAt() {
  const date = new Date();
  date.setDate(date.getDate() + REFRESH_TTL_DAYS);
  return date;
}

function verificationExpiresAt() {
  const date = new Date();
  date.setMinutes(date.getMinutes() + 15);
  return date;
}

module.exports = {
  signAccessToken,
  verifyAccessToken,
  generateRefreshToken,
  hashRefreshToken,
  refreshExpiresAt,
  verificationExpiresAt,
  JWT_SECRET,
};
