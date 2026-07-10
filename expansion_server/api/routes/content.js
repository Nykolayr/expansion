const express = require('express');

const router = express.Router();

const CONTENT_VERSION = 2;

router.get('/version', (_req, res) => {
  res.json({ contentVersion: CONTENT_VERSION });
});

router.get('/scenes', (_req, res) => {
  res.json({
    contentVersion: CONTENT_VERSION,
    scenes: [],
    note: 'MVP stub — сцены пока в bundled assets клиента',
  });
});

module.exports = router;
