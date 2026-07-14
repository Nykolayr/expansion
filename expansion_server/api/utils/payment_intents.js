const crypto = require('crypto');

const { getPool } = require('../config/database');
const {
  sendDonationThanks,
  sendDonationIdeaThanks,
  notifyAdminDonationIdea,
} = require('../config/email');
const {
  notifyTelegramHtml,
  formatPaymentIntentMessage,
  formatPaymentPaidMessage,
} = require('./telegram');
const { mergeProfileJson, defaultProfileJson } = require('./profile');

const GAME_SLUG = 'expansion';
const TIER3_PRODUCT = 'com.ryjovs.expansion.donate_tier3';
const REMOVE_ADS_PRODUCT = 'com.ryjovs.expansion.remove_ads';

const PRODUCT_LABELS = {
  'com.ryjovs.expansion.donate_tier1': 'Поддержать · 99 ₽',
  'com.ryjovs.expansion.donate_tier2': 'Больше поддержки · 299 ₽',
  'com.ryjovs.expansion.donate_tier3': 'Поддержка + Ваша идея · 599 ₽',
  'com.ryjovs.expansion.remove_ads': 'Убрать рекламу · 199 ₽',
};

const PRODUCT_PRICES = {
  'com.ryjovs.expansion.donate_tier1': 99,
  'com.ryjovs.expansion.donate_tier2': 299,
  'com.ryjovs.expansion.donate_tier3': 599,
  'com.ryjovs.expansion.remove_ads': 199,
};

function newId() {
  return crypto.randomUUID();
}

function productLabel(productId) {
  return PRODUCT_LABELS[productId] || productId;
}

function tierForProduct(productId) {
  if (productId.includes('donate_tier1')) return 1;
  if (productId.includes('donate_tier2')) return 2;
  if (productId.includes('donate_tier3')) return 3;
  return 0;
}

async function generatePaymentCode() {
  for (let attempt = 0; attempt < 8; attempt += 1) {
    const suffix = crypto.randomBytes(3).toString('hex').toUpperCase();
    const code = `EXP-${suffix}`;
    const [rows] = await getPool().query(
      `SELECT id FROM payment_intents WHERE payment_code = ? LIMIT 1`,
      [code],
    );
    if (!rows.length) return code;
  }
  throw new Error('payment code generation failed');
}

function parseProfileJson(raw) {
  if (!raw) return {};
  if (typeof raw === 'string') {
    try {
      return JSON.parse(raw);
    } catch {
      return {};
    }
  }
  return raw;
}

function mergeMonetizationBenefits(local, server) {
  const localProfile = local && typeof local === 'object' ? local : {};
  const serverProfile = server && typeof server === 'object' ? server : {};
  return {
    ...localProfile,
    adsRemoved: Boolean(localProfile.adsRemoved || serverProfile.adsRemoved),
    supporterTier: Math.max(
      Number(localProfile.supporterTier) || 0,
      Number(serverProfile.supporterTier) || 0,
    ),
  };
}

async function loadGuestProfile(deviceId) {
  const [rows] = await getPool().query(
    `SELECT profile_json FROM guest_devices WHERE device_id = ? AND game_slug = ? LIMIT 1`,
    [deviceId, GAME_SLUG],
  );
  if (!rows.length) return {};
  return parseProfileJson(rows[0].profile_json);
}

async function saveGuestProfile(deviceId, profile) {
  const profileJson = JSON.stringify(profile);
  await getPool().query(
    `INSERT INTO guest_devices (device_id, game_slug, profile_json)
     VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE profile_json = VALUES(profile_json), last_seen = CURRENT_TIMESTAMP`,
    [deviceId, GAME_SLUG, profileJson],
  );
}

async function applyUserBenefits(userId, { adsRemoved, supporterTier }) {
  const [rows] = await getPool().query(
    `SELECT profile_json FROM user_profiles WHERE user_id = ? LIMIT 1`,
    [userId],
  );
  const existing = rows.length ? parseProfileJson(rows[0].profile_json) : defaultProfileJson();
  const patch = {};
  if (adsRemoved) patch.adsRemoved = true;
  if (supporterTier > (existing.supporterTier ?? 0)) {
    patch.supporterTier = supporterTier;
  }
  const merged = mergeProfileJson(existing, patch);
  if (rows.length) {
    await getPool().query(
      `UPDATE user_profiles SET profile_json = ? WHERE user_id = ?`,
      [JSON.stringify(merged), userId],
    );
  } else {
    await getPool().query(
      `INSERT INTO user_profiles (user_id, profile_json) VALUES (?, ?)`,
      [userId, JSON.stringify(merged)],
    );
  }
  return merged;
}

async function applyGuestBenefits(deviceId, { adsRemoved, supporterTier }) {
  const existing = await loadGuestProfile(deviceId);
  const patch = {};
  if (adsRemoved) patch.adsRemoved = true;
  if (supporterTier > (existing.supporterTier ?? 0)) {
    patch.supporterTier = supporterTier;
  }
  const merged = mergeProfileJson(
    Object.keys(existing).length ? existing : defaultProfileJson(),
    patch,
  );
  await saveGuestProfile(deviceId, merged);
  return merged;
}

async function createPaymentIntent({
  deviceId,
  productId,
  userId,
  email,
  nick,
  ideaId,
}) {
  const priceRub = PRODUCT_PRICES[productId];
  if (!priceRub) {
    const err = new Error('unknown product');
    err.code = 'VALIDATION';
    throw err;
  }

  const id = newId();
  const paymentCode = await generatePaymentCode();

  await getPool().query(
    `INSERT INTO payment_intents
       (id, game_slug, device_id, user_id, email, nick, product_id, price_rub, payment_code, idea_id, status)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')`,
    [
      id,
      GAME_SLUG,
      deviceId,
      userId,
      email,
      nick,
      productId,
      priceRub,
      paymentCode,
      ideaId,
    ],
  );

  const intent = {
    id,
    device_id: deviceId,
    user_id: userId,
    email,
    nick,
    product_id: productId,
    price_rub: priceRub,
    payment_code: paymentCode,
    idea_id: ideaId,
    status: 'pending',
  };

  const label = productLabel(productId);
  notifyTelegramHtml(formatPaymentIntentMessage(intent, label)).catch((error) => {
    console.error('telegram payment intent notify failed:', error.message);
  });

  return intent;
}

async function fulfillPaymentIntent(intentId) {
  const [rows] = await getPool().query(
    `SELECT * FROM payment_intents WHERE id = ? AND game_slug = ? LIMIT 1`,
    [intentId, GAME_SLUG],
  );
  if (!rows.length) {
    const err = new Error('intent not found');
    err.code = 'NOT_FOUND';
    throw err;
  }

  const intent = rows[0];
  if (intent.status === 'paid') {
    return intent;
  }
  if (intent.status === 'cancelled') {
    const err = new Error('intent cancelled');
    err.code = 'CONFLICT';
    throw err;
  }

  const productId = intent.product_id;
  const adsRemoved = productId === REMOVE_ADS_PRODUCT;
  const supporterTier = tierForProduct(productId);
  const purchaseId = newId();

  await getPool().query(
    `UPDATE payment_intents SET status = 'paid', paid_at = CURRENT_TIMESTAMP WHERE id = ?`,
    [intentId],
  );

  await getPool().query(
    `INSERT INTO purchase_events (id, game_slug, device_id, user_id, product_id, store, price_rub)
     VALUES (?, ?, ?, ?, ?, 'sbp_manual', ?)`,
    [
      purchaseId,
      GAME_SLUG,
      intent.device_id,
      intent.user_id,
      productId,
      intent.price_rub,
    ],
  );

  if (intent.user_id) {
    await applyUserBenefits(intent.user_id, { adsRemoved, supporterTier });
  } else {
    await applyGuestBenefits(intent.device_id, { adsRemoved, supporterTier });
  }

  const label = productLabel(productId);

  if (productId === TIER3_PRODUCT && intent.idea_id) {
    const [ideaRows] = await getPool().query(
      `SELECT id, idea_text, email, user_id, status FROM donation_ideas WHERE id = ? LIMIT 1`,
      [intent.idea_id],
    );
    const idea = ideaRows[0];
    if (idea && idea.status === 'draft') {
      await getPool().query(
        `UPDATE donation_ideas
         SET status = 'paid', product_id = ?, purchase_event_id = ?, paid_at = CURRENT_TIMESTAMP,
             user_id = COALESCE(user_id, ?)
         WHERE id = ?`,
        [productId, purchaseId, intent.user_id, intent.idea_id],
      );

      const thanksEmail = intent.email || idea.email;
      if (thanksEmail) {
        await sendDonationIdeaThanks({
          toEmail: thanksEmail,
          nick: intent.nick,
          ideaText: idea.idea_text,
        });
      }
      await notifyAdminDonationIdea({
        ideaText: idea.idea_text,
        fromEmail: thanksEmail,
        nick: intent.nick,
        userId: intent.user_id || idea.user_id,
      });
    }
  } else if (intent.email) {
    await sendDonationThanks({
      toEmail: intent.email,
      nick: intent.nick,
      productLabel: label,
    });
  }

  notifyTelegramHtml(formatPaymentPaidMessage(intent, label)).catch((error) => {
    console.error('telegram payment paid notify failed:', error.message);
  });

  return { ...intent, status: 'paid' };
}

async function cancelPaymentIntent(intentId) {
  const [result] = await getPool().query(
    `UPDATE payment_intents SET status = 'cancelled'
     WHERE id = ? AND game_slug = ? AND status = 'pending'`,
    [intentId, GAME_SLUG],
  );
  if (!result.affectedRows) {
    const err = new Error('intent not found or not pending');
    err.code = 'NOT_FOUND';
    throw err;
  }
}

module.exports = {
  GAME_SLUG,
  PRODUCT_LABELS,
  PRODUCT_PRICES,
  productLabel,
  mergeMonetizationBenefits,
  loadGuestProfile,
  saveGuestProfile,
  createPaymentIntent,
  fulfillPaymentIntent,
  cancelPaymentIntent,
};
