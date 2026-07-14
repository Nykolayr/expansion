#!/usr/bin/env node
require('dotenv').config();
const { notifyTelegramHtml } = require('../api/utils/telegram');

(async () => {
  const ok = await notifyTelegramHtml('<b>Expansion</b> telegram ping test');
  console.log('sent:', ok);
  if (!ok) {
    console.error('credentials missing in .env');
    process.exit(1);
  }
})().catch((e) => {
  console.error('fail:', e.message);
  process.exit(1);
});
