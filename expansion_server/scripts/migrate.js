#!/usr/bin/env node
/**
 * Применяет SQL-миграции из migrations/.
 * Usage: node scripts/migrate.js
 */
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env') });

const { getPool } = require('../api/config/database');

async function run() {
  const migrationsDir = path.join(__dirname, '..', 'migrations');
  const files = fs
    .readdirSync(migrationsDir)
    .filter((name) => name.endsWith('.sql'))
    .sort();

  if (!files.length) {
    console.log('No migrations found.');
    return;
  }

  const pool = getPool();
  for (const file of files) {
    const sql = fs.readFileSync(path.join(migrationsDir, file), 'utf8');
    console.log(`Applying ${file}...`);
    for (const statement of sql.split(';').map((s) => s.trim()).filter(Boolean)) {
      await pool.query(statement);
    }
    console.log(`OK: ${file}`);
  }

  console.log('Migrations complete.');
  await pool.end();
}

run().catch((error) => {
  console.error('Migration failed:', error.message);
  process.exit(1);
});
