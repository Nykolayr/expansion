#!/usr/bin/env node
/**
 * Один тестовый аккаунт для ревью Google Play и App Store.
 *
 * Usage: node scripts/seed-review-users.js
 */
require('dotenv').config();

const crypto = require('crypto');
const { getPool } = require('../api/config/database');
const { hashPassword } = require('../api/utils/password');
const { validateNick } = require('../api/utils/nick');
const { defaultProfileJson } = require('../api/utils/profile');

/** Один логин на оба стора — укажи в App access и Notes for Review. */
const REVIEW_USER = {
  email: 'autogid70+rv@gmail.com',
  password: 'review1',
  nick: 'Review',
  realName: 'Review',
};

/** Старые тестовые аккаунты — удаляем при seed. */
const LEGACY_REVIEW_EMAILS = [
  'autogid70+reviewgoogle@gmail.com',
  'autogid70+reviewapple@gmail.com',
];

async function deleteUserByEmail(email) {
  const pool = getPool();
  const normalized = email.trim().toLowerCase();
  const [users] = await pool.query(
    'SELECT id, email, nick FROM users WHERE email = ? LIMIT 1',
    [normalized],
  );
  if (!users.length) {
    return { deleted: false, email: normalized };
  }
  const user = users[0];
  await pool.query('DELETE FROM refresh_tokens WHERE user_id = ?', [user.id]);
  await pool.query('DELETE FROM user_profiles WHERE user_id = ?', [user.id]);
  await pool.query('DELETE FROM users WHERE id = ?', [user.id]);
  await pool.query('DELETE FROM email_verifications WHERE email = ?', [normalized]);
  await pool.query('DELETE FROM password_reset_codes WHERE email = ?', [normalized]);
  return { deleted: true, email: normalized, nick: user.nick };
}

async function ensureReviewUser(userSpec) {
  const email = userSpec.email.trim().toLowerCase();
  const nickValidation = validateNick(userSpec.nick);
  if (!nickValidation.ok) {
    throw new Error(`${email}: invalid nick — ${nickValidation.code}`);
  }

  const passwordHash = await hashPassword(userSpec.password);
  const pool = getPool();

  const [existing] = await pool.query(
    `SELECT id, email, nick FROM users WHERE email = ? LIMIT 1`,
    [email],
  );

  if (existing.length) {
    const row = existing[0];
    await pool.query(
      `UPDATE users
       SET password_hash = ?, email_verified = 1, real_name = ?, nick = ?, nick_normalized = ?
       WHERE id = ?`,
      [
        passwordHash,
        userSpec.realName,
        nickValidation.nick,
        nickValidation.nickNormalized,
        row.id,
      ],
    );

    const [profiles] = await pool.query(
      `SELECT user_id FROM user_profiles WHERE user_id = ? LIMIT 1`,
      [row.id],
    );
    if (!profiles.length) {
      await pool.query(`INSERT INTO user_profiles (user_id, profile_json) VALUES (?, ?)`, [
        row.id,
        JSON.stringify(defaultProfileJson(userSpec.realName)),
      ]);
    }

    await pool.query(`DELETE FROM email_verifications WHERE email = ?`, [email]);

    return { action: 'updated', id: row.id, email, nick: nickValidation.nick };
  }

  const [nickConflict] = await pool.query(
    `SELECT id, email FROM users WHERE nick_normalized = ? LIMIT 1`,
    [nickValidation.nickNormalized],
  );
  if (nickConflict.length && nickConflict[0].email !== email) {
    throw new Error(
      `nick ${userSpec.nick} taken by ${nickConflict[0].email} — удалите вручную или смените nick`,
    );
  }

  const userId = crypto.randomUUID();
  await pool.query(
    `INSERT INTO users
     (id, email, nick, nick_normalized, real_name, password_hash, email_verified)
     VALUES (?, ?, ?, ?, ?, ?, 1)`,
    [
      userId,
      email,
      nickValidation.nick,
      nickValidation.nickNormalized,
      userSpec.realName,
      passwordHash,
    ],
  );
  await pool.query(`INSERT INTO user_profiles (user_id, profile_json) VALUES (?, ?)`, [
    userId,
    JSON.stringify(defaultProfileJson(userSpec.realName)),
  ]);
  await pool.query(`DELETE FROM email_verifications WHERE email = ?`, [email]);

  return { action: 'created', id: userId, email, nick: nickValidation.nick };
}

async function main() {
  const removed = [];
  for (const email of LEGACY_REVIEW_EMAILS) {
    removed.push(await deleteUserByEmail(email));
  }

  const user = await ensureReviewUser(REVIEW_USER);

  console.log(
    JSON.stringify(
      {
        ok: true,
        removed,
        user: { ...user, password: REVIEW_USER.password },
      },
      null,
      2,
    ),
  );

  console.log('\n--- Google Play + App Store (один аккаунт) ---');
  console.log(`Email:    ${REVIEW_USER.email}`);
  console.log(`Password: ${REVIEW_USER.password}`);
  console.log(`Nick:     ${REVIEW_USER.nick}`);
  console.log('\nGuest mode OK. Login: Profile -> Vhod.');
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
