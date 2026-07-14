#!/usr/bin/env node
require('dotenv').config();
const nodemailer = require('nodemailer');

const host = process.env.SMTP_HOST;
const user = process.env.SMTP_USER;
const pass = process.env.SMTP_PASS;

if (!host || !user || !pass) {
  console.error('Missing SMTP_HOST, SMTP_USER or SMTP_PASS');
  process.exit(1);
}

const config = {
  host,
  port: parseInt(process.env.SMTP_PORT || '587', 10),
  secure: process.env.SMTP_SECURE === 'true',
  auth: { user, pass },
};

if (host.includes('gmail.com')) {
  config.requireTLS = true;
  config.secure = false;
}

const transporter = nodemailer.createTransport(config);

transporter
  .verify()
  .then(() => {
    console.log('SMTP verify OK');
    process.exit(0);
  })
  .catch((err) => {
    console.error('SMTP verify FAIL:', err.message);
    process.exit(1);
  });
