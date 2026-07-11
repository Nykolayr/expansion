const express = require('express');

const { getPool } = require('../config/database');
const { authMiddleware } = require('../middleware/auth');

const router = express.Router();

router.delete('/', authMiddleware, async (req, res) => {
  try {
    await getPool().query(`DELETE FROM users WHERE id = ?`, [req.authUser.id]);
    return res.json({ message: 'account deleted' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

module.exports = router;
