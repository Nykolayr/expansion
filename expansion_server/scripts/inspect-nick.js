#!/usr/bin/env node
require('dotenv').config();
const { getPool } = require('../api/config/database');

async function main() {
  const nick = (process.argv[2] || 'bired').toLowerCase();
  const pool = getPool();
  const [users] = await pool.query(
    'SELECT id, email, nick, created_at FROM users WHERE nick_normalized = ?',
    [nick],
  );
  const [pending] = await pool.query(
    `SELECT id, email, nick, expires_at, created_at FROM email_verifications
     WHERE nick_normalized = ? ORDER BY created_at DESC`,
    [nick],
  );
  console.log(JSON.stringify({ nick, users, pending }, null, 2));
  process.exit(0);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
