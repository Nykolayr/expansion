const bcrypt = require('bcrypt');

const ROUNDS = 12;

async function hashPassword(password) {
  return bcrypt.hash(password, ROUNDS);
}

async function verifyPassword(password, passwordHash) {
  return bcrypt.compare(password, passwordHash);
}

module.exports = { hashPassword, verifyPassword };
