const crypto = require('crypto');

const RESERVED_NICKS = new Set([
  'admin',
  'administrator',
  'expansion',
  'guest',
  'moderator',
  'support',
  'system',
  'help',
  'null',
  'undefined',
]);

const NICK_PATTERN = /^[\w\u0400-\u04FF\u0500-\u052F]+$/u;

function normalizeNick(nick) {
  return String(nick || '').trim().toLowerCase();
}

function validateNick(rawNick) {
  const nick = String(rawNick || '').trim();
  if (nick.length < 3 || nick.length > 20) {
    return { ok: false, code: 'NICK_LENGTH', error: 'nick must be 3–20 characters' };
  }
  if (!NICK_PATTERN.test(nick)) {
    return {
      ok: false,
      code: 'NICK_FORMAT',
      error: 'nick allows letters, digits and underscore only',
    };
  }
  if (RESERVED_NICKS.has(normalizeNick(nick))) {
    return { ok: false, code: 'NICK_RESERVED', error: 'nick is reserved' };
  }
  return { ok: true, nick, nickNormalized: normalizeNick(nick) };
}

function hashCode(code) {
  return crypto.createHash('sha256').update(String(code)).digest('hex');
}

function generateSixDigitCode() {
  return String(Math.floor(100000 + Math.random() * 900000));
}

function leaderboardLabel(nick, realName) {
  const safeNick = String(nick || '').trim();
  const safeName = String(realName || '').trim();
  if (safeNick && safeName) return `${safeNick} (${safeName})`;
  return safeNick || safeName || '—';
}

module.exports = {
  validateNick,
  normalizeNick,
  hashCode,
  generateSixDigitCode,
  leaderboardLabel,
  RESERVED_NICKS,
};
