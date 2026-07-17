#!/usr/bin/env node
/** One-shot: wipe expansion guest_devices. Usage: node scripts/wipe-guests.js */
require('dotenv').config();
const { getPool } = require('../api/config/database');

async function main() {
  const pool = getPool();
  const [before] = await pool.query(
    `SELECT COUNT(*) AS c FROM guest_devices WHERE game_slug = 'expansion'`,
  );
  const [result] = await pool.query(
    `DELETE FROM guest_devices WHERE game_slug = 'expansion'`,
  );
  const [after] = await pool.query(
    `SELECT COUNT(*) AS c FROM guest_devices WHERE game_slug = 'expansion'`,
  );
  console.log(
    JSON.stringify({
      before: before[0].c,
      deleted: result.affectedRows,
      after: after[0].c,
    }),
  );
  process.exit(0);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
