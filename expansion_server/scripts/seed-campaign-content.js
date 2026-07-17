#!/usr/bin/env node
/**
 * Заливает campaign-pack JSON в MariaDB.
 * Usage: node scripts/seed-campaign-content.js [path/to/pack.json]
 */
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

dotenv.config({ path: path.join(__dirname, '..', '.env') });

const { getPool } = require('../api/config/database');

async function run() {
  const defaultPack = path.join(__dirname, '..', 'content', 'campaign-pack-v12.json');
  const packPath = process.argv[2] || defaultPack;

  if (!fs.existsSync(packPath)) {
    console.error('Pack not found:', packPath);
    console.error('Run: node scripts/build-content-pack.js');
    process.exit(1);
  }

  const pack = JSON.parse(fs.readFileSync(packPath, 'utf8'));
  const version = pack.contentVersion;
  if (!version || !pack.scenes) {
    console.error('Invalid pack format');
    process.exit(1);
  }

  const pool = getPool();
  await pool.query(
    `INSERT INTO campaign_content (content_version, payload_json)
     VALUES (?, ?)
     ON DUPLICATE KEY UPDATE payload_json = VALUES(payload_json), published_at = CURRENT_TIMESTAMP`,
    [version, JSON.stringify(pack)],
  );

  console.log(`Seeded campaign_content v${version} from ${packPath}`);
  await pool.end();
}

run().catch((error) => {
  console.error(error);
  process.exit(1);
});
