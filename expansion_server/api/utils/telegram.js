/**
 * Telegram Bot API — уведомления владельцу (как redmobi calculatorLeadNotify).
 * Токен/chat_id: EXPANSION_TELEGRAM_* или CALCULATOR_LEAD_TELEGRAM_* (тот же канал RedMobi).
 * chat_id fallback: data/chat_id.txt у redmobi-радаров на VPS.
 */

const fs = require('fs');

const CHAT_ID_FILE_CANDIDATES = [
  '/opt/redmobi/kwork-radar/data/chat_id.txt',
  '/opt/redmobi/freelancer-radar/data/chat_id.txt',
  '/opt/redmobi/fl-radar/data/chat_id.txt',
];

function readChatIdFromFile() {
  for (const file of CHAT_ID_FILE_CANDIDATES) {
    try {
      if (!fs.existsSync(file)) continue;
      const id = fs.readFileSync(file, 'utf8').trim();
      if (id) return id;
    } catch {
      // ignore unreadable file
    }
  }
  return '';
}

function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

function telegramCredentials() {
  const token = (
    process.env.EXPANSION_TELEGRAM_BOT_TOKEN
    || process.env.CALCULATOR_LEAD_TELEGRAM_BOT_TOKEN
    || process.env.TELEGRAM_BOT_TOKEN
    || ''
  ).trim();
  const chatId = (
    process.env.EXPANSION_TELEGRAM_CHAT_ID
    || process.env.CALCULATOR_LEAD_TELEGRAM_CHAT_ID
    || process.env.TELEGRAM_CHAT_ID
    || readChatIdFromFile()
    || ''
  ).trim();
  return { token, chatId };
}

async function sendTelegramHtml(token, chatId, text) {
  const url = `https://api.telegram.org/bot${token}/sendMessage`;
  const resp = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      chat_id: chatId,
      text,
      parse_mode: 'HTML',
      disable_web_page_preview: true,
    }),
  });
  const data = await resp.json();
  if (!data.ok) {
    throw new Error(`Telegram sendMessage: ${JSON.stringify(data)}`);
  }
  return data;
}

async function notifyTelegramHtml(text) {
  const { token, chatId } = telegramCredentials();
  if (!token || !chatId) {
    console.warn('telegram notify skipped: missing bot token or chat id');
    return false;
  }
  await sendTelegramHtml(token, chatId, text);
  return true;
}

function formatPaymentIntentMessage(intent, productLabel) {
  const lines = [
    '🎮 <b>Expansion · попытка оплаты</b>',
    '',
    `💳 <b>${escapeHtml(productLabel)}</b> · ${intent.price_rub} ₽`,
    `🔑 Код: <code>${escapeHtml(intent.payment_code)}</code>`,
    '',
    intent.nick ? `👤 Nick: ${escapeHtml(intent.nick)}` : null,
    intent.email ? `✉️ ${escapeHtml(intent.email)}` : null,
    intent.user_id ? `🆔 User: <code>${escapeHtml(intent.user_id)}</code>` : `📱 Guest · <code>${escapeHtml(intent.device_id)}</code>`,
    '',
    `Комментарий к переводу: <code>${escapeHtml(intent.payment_code)}</code>`,
  ].filter(Boolean);

  const adminBase = (process.env.ADMIN_URL || 'https://danilagames.ru/admin').replace(/\/$/, '');
  lines.push('', `<a href="${adminBase}/#/expansion/payments">Открыть оплаты в админке</a>`);
  return lines.join('\n');
}

function formatFeedbackMessage({ message, fromEmail, nick, userId }) {
  const lines = [
    '🎮 <b>Expansion · обратная связь</b>',
    '',
    fromEmail ? `✉️ ${escapeHtml(fromEmail)}` : null,
    nick ? `👤 ${escapeHtml(nick)}` : null,
    userId ? `🆔 <code>${escapeHtml(userId)}</code>` : '📱 Гость',
    '',
    escapeHtml(message.length > 1500 ? `${message.slice(0, 1500)}…` : message),
  ].filter(Boolean);
  return lines.join('\n');
}

function formatPaymentPaidMessage(intent, productLabel) {
  const lines = [
    '✅ <b>Expansion · оплата подтверждена</b>',
    '',
    `💳 ${escapeHtml(productLabel)} · ${intent.price_rub} ₽`,
    `🔑 <code>${escapeHtml(intent.payment_code)}</code>`,
    intent.nick ? `👤 ${escapeHtml(intent.nick)}` : null,
  ].filter(Boolean);
  return lines.join('\n');
}

module.exports = {
  escapeHtml,
  notifyTelegramHtml,
  formatPaymentIntentMessage,
  formatFeedbackMessage,
  formatPaymentPaidMessage,
};
