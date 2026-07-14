const express = require('express');

const { signAdminToken } = require('../utils/tokens');
const { adminAuthMiddleware } = require('../middleware/admin_auth');

const router = express.Router();

const PLATFORM_GAMES = [
  { slug: 'expansion', title: 'Expansion', adminPath: '/admin/expansion/' },
];

function adminCredentialsValid(username, password) {
  const expectedUser = process.env.ADMIN_USERNAME || 'admin';
  const expectedPass = process.env.ADMIN_PASSWORD || '123456';
  return username === expectedUser && password === expectedPass;
}

router.post('/admin/login', (req, res) => {
  const username = String(req.body?.username || '').trim();
  const password = String(req.body?.password || '');

  if (!username || !password) {
    return res.status(400).json({ error: 'username and password required', code: 'VALIDATION' });
  }

  if (!adminCredentialsValid(username, password)) {
    return res.status(401).json({ error: 'invalid credentials', code: 'AUTH' });
  }

  const accessToken = signAdminToken(username);
  return res.json({
    accessToken,
    username,
    expiresIn: process.env.ADMIN_JWT_TTL || '8h',
  });
});

router.get('/games', adminAuthMiddleware, (_req, res) => {
  return res.json({ games: PLATFORM_GAMES });
});

module.exports = router;
