const express = require('express');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const { users } = require('../store');

const router = express.Router();

const JWT_SECRET = process.env.JWT_SECRET || 'dev-only-change-me';

function hashPassword(password) {
  return crypto.createHash('sha256').update(password).digest('hex');
}

function signToken(user) {
  return jwt.sign({ sub: user.id, email: user.email }, JWT_SECRET, {
    expiresIn: '30d',
  });
}

router.post('/register', (req, res) => {
  const email = String(req.body?.email || '').trim().toLowerCase();
  const password = String(req.body?.password || '');
  if (!email || password.length < 6) {
    return res.status(400).json({
      error: 'email and password (min 6) required',
      code: 'VALIDATION',
    });
  }
  if (users.has(email)) {
    return res.status(409).json({ error: 'user exists', code: 'CONFLICT' });
  }
  const user = {
    id: crypto.randomUUID(),
    email,
    passwordHash: hashPassword(password),
    profile: {
      mapClassic: 1,
      scoreClassic: 0,
      difficulty: 'average',
    },
  };
  users.set(email, user);
  const token = signToken(user);
  return res.status(201).json({
    token,
    user: { id: user.id, email: user.email },
  });
});

router.post('/login', (req, res) => {
  const email = String(req.body?.email || '').trim().toLowerCase();
  const password = String(req.body?.password || '');
  const user = users.get(email);
  if (!user || user.passwordHash !== hashPassword(password)) {
    return res.status(401).json({ error: 'invalid credentials', code: 'AUTH' });
  }
  return res.json({
    token: signToken(user),
    user: { id: user.id, email: user.email },
  });
});

router.get('/me', (req, res) => {
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
    return res.json({ id: user.id, email: user.email });
  } catch {
    return res.status(401).json({ error: 'invalid token', code: 'AUTH' });
  }
});

module.exports = router;
