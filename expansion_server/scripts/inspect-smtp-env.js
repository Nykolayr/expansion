#!/usr/bin/env node
require('dotenv').config({ path: process.argv[2] || '.env' });
const p = process.env.SMTP_PASS || '';
console.log(
  JSON.stringify({
    passLen: p.length,
    hasSpace: /\s/.test(p),
    hasQuote: /['"]/.test(p),
    user: process.env.SMTP_USER || '',
    host: process.env.SMTP_HOST || '',
  }),
);
