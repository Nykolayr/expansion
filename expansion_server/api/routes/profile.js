const express = require('express');
const jwt = require('jsonwebtoken');

const router = express.Router();

const JWT_SECRET = process.env.JWT_SECRET || 'dev-only-change-me';

// Shared in-memory store with auth routes (MVP — один процесс).
const { users } = require('../store');

function authMiddleware(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) {
    return res.status(401).json({ error: 'missing token', code: 'AUTH' });
  }
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    const user = [...users.values()].find((u) => u.id === payload.sub);
    if (!user) {
      return res.status(404).json({ error: 'user not found', code: 'NOT_FOUND' });
    }
    req.user = user;
    return next();
  } catch {
    return res.status(401).json({ error: 'invalid token', code: 'AUTH' });
  }
}

router.get('/', authMiddleware, (req, res) => {
  res.json(req.user.profile);
});

router.put('/', authMiddleware, (req, res) => {
  const body = req.body || {};
  req.user.profile = {
    ...req.user.profile,
    mapClassic: Number(body.mapClassic ?? req.user.profile.mapClassic),
    scoreClassic: Number(body.scoreClassic ?? req.user.profile.scoreClassic),
    difficulty: String(body.difficulty ?? req.user.profile.difficulty),
  };
  res.json(req.user.profile);
});

module.exports = router;
