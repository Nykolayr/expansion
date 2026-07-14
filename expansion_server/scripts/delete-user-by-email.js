#!/usr/bin/env node
require('dotenv').config();
const { getPool } = require('../api/config/database');

async function main() {
  const email = (process.argv[2] || '').trim().toLowerCase();
  if (!email) {
    console.error('Usage: node scripts/delete-user-by-email.js user@example.com');
    process.exit(1);
  }

  const pool = getPool();
  const [users] = await pool.query(
    'SELECT id, email, nick FROM users WHERE email = ? LIMIT 1',
    [email],
  );

  if (!users.length) {
    console.log(JSON.stringify({ deleted: false, reason: 'user not found', email }));
    process.exit(0);
  }

  const user = users[0];
  await pool.query('DELETE FROM refresh_tokens WHERE user_id = ?', [user.id]);
  await pool.query('DELETE FROM user_profiles WHERE user_id = ?', [user.id]);
  await pool.query('DELETE FROM users WHERE id = ?', [user.id]);
  await pool.query('DELETE FROM email_verifications WHERE email = ?', [email]);
  await pool.query('DELETE FROM password_reset_codes WHERE email = ?', [email]);

  console.log(
    JSON.stringify({
      deleted: true,
      email: user.email,
      nick: user.nick,
      id: user.id,
    }),
  );
  process.exit(0);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
