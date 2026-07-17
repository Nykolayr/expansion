const express = require('express');
const crypto = require('crypto');

const { getPool } = require('../config/database');
const {
  sendDonationThanks,
  sendDonationIdeaThanks,
  notifyAdminDonationIdea,
} = require('../config/email');
const { adminAuthMiddleware } = require('../middleware/admin_auth');
const { verifyAccessToken } = require('../utils/tokens');
const { parseProfileRow } = require('../utils/profile');
const { leaderboardLabel } = require('../utils/nick');
const {
  PRODUCT_LABELS,
  PRODUCT_PRICES,
  productLabel,
  mergeMonetizationBenefits,
  loadGuestProfile,
  saveGuestProfile,
  createPaymentIntent,
  fulfillPaymentIntent,
  cancelPaymentIntent,
} = require('../utils/payment_intents');

const router = express.Router();
const GAME_SLUG = 'expansion';

const AD_EVENT_TYPES = new Set(['banner', 'interstitial', 'rewarded']);

const TIER3_PRODUCT = 'com.ryjovs.expansion.donate_tier3';

function newId() {
  return crypto.randomUUID();
}

function normalizeEmail(email) {
  return String(email || '').trim().toLowerCase();
}

function isValidEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

async function resolveOptionalUser(req) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  if (!token) return null;

  try {
    const payload = verifyAccessToken(token);
    const [rows] = await getPool().query(
      `SELECT u.id, u.email, u.nick, u.real_name, u.email_verified, u.created_at,
              p.profile_json
       FROM users u
       LEFT JOIN user_profiles p ON p.user_id = u.id
       WHERE u.id = ? AND u.email_verified = 1
       LIMIT 1`,
      [payload.sub],
    );
    if (!rows.length) return null;
    return parseProfileRow(rows[0]);
  } catch {
    return null;
  }
}

async function lookupUserById(userId) {
  if (!userId) return null;
  const [rows] = await getPool().query(
    `SELECT id, email, nick FROM users WHERE id = ? AND email_verified = 1 LIMIT 1`,
    [userId],
  );
  return rows[0] || null;
}

async function getGameSettings() {
  const [rows] = await getPool().query(
    `SELECT ads_enabled, donations_enabled,
            payment_sbp_url, payment_qr_url,
            payment_sbp_url_tier1, payment_sbp_url_tier2,
            payment_sbp_url_tier3, payment_sbp_url_remove_ads,
            updated_at
     FROM game_settings WHERE game_slug = ? LIMIT 1`,
    [GAME_SLUG],
  );
  if (!rows.length) {
    return {
      adsEnabled: true,
      donationsEnabled: true,
      paymentSbpUrl: null,
      paymentQrUrl: null,
      paymentSbpUrlTier1: null,
      paymentSbpUrlTier2: null,
      paymentSbpUrlTier3: null,
      paymentSbpUrlRemoveAds: null,
      updatedAt: null,
    };
  }
  const row = rows[0];
  return {
    adsEnabled: Boolean(row.ads_enabled),
    donationsEnabled: Boolean(row.donations_enabled),
    paymentSbpUrl: row.payment_sbp_url || null,
    paymentQrUrl: row.payment_qr_url || null,
    paymentSbpUrlTier1: row.payment_sbp_url_tier1 || null,
    paymentSbpUrlTier2: row.payment_sbp_url_tier2 || null,
    paymentSbpUrlTier3: row.payment_sbp_url_tier3 || null,
    paymentSbpUrlRemoveAds: row.payment_sbp_url_remove_ads || null,
    updatedAt: row.updated_at,
  };
}

function resolveSbpUrlForProduct(settings, productId) {
  const byProduct = {
    'com.ryjovs.expansion.donate_tier1':
      settings.paymentSbpUrlTier1
      || (process.env.PAYMENT_SBP_URL_TIER1 || '').trim()
      || null,
    'com.ryjovs.expansion.donate_tier2':
      settings.paymentSbpUrlTier2
      || (process.env.PAYMENT_SBP_URL_TIER2 || '').trim()
      || null,
    'com.ryjovs.expansion.donate_tier3':
      settings.paymentSbpUrlTier3
      || (process.env.PAYMENT_SBP_URL_TIER3 || '').trim()
      || null,
    'com.ryjovs.expansion.remove_ads':
      settings.paymentSbpUrlRemoveAds
      || (process.env.PAYMENT_SBP_URL_REMOVE_ADS || '').trim()
      || null,
  };
  return (
    byProduct[productId]
    || settings.paymentSbpUrl
    || (process.env.PAYMENT_SBP_URL || '').trim()
    || null
  );
}

function paymentUrlsForConfig(settings) {
  const envQr = (process.env.PAYMENT_QR_URL || '').trim() || null;
  return {
    qrUrl: settings.paymentQrUrl || envQr,
    byProduct: {
      'com.ryjovs.expansion.donate_tier1': resolveSbpUrlForProduct(
        settings,
        'com.ryjovs.expansion.donate_tier1',
      ),
      'com.ryjovs.expansion.donate_tier2': resolveSbpUrlForProduct(
        settings,
        'com.ryjovs.expansion.donate_tier2',
      ),
      'com.ryjovs.expansion.donate_tier3': resolveSbpUrlForProduct(
        settings,
        'com.ryjovs.expansion.donate_tier3',
      ),
      'com.ryjovs.expansion.remove_ads': resolveSbpUrlForProduct(
        settings,
        'com.ryjovs.expansion.remove_ads',
      ),
    },
  };
}

function validateDeviceId(deviceId) {
  const id = String(deviceId || '').trim();
  if (id.length < 8 || id.length > 64) return null;
  if (!/^[a-zA-Z0-9_-]+$/.test(id)) return null;
  return id;
}

// --- Public (app) ---

router.get('/config', async (_req, res) => {
  try {
    const settings = await getGameSettings();
    const payment = paymentUrlsForConfig(settings);
    return res.json({
      game: GAME_SLUG,
      adsEnabled: settings.adsEnabled,
      donationsEnabled: settings.donationsEnabled,
      payment: {
        sbpUrl: settings.paymentSbpUrl || (process.env.PAYMENT_SBP_URL || '').trim() || null,
        qrUrl: payment.qrUrl,
        byProduct: payment.byProduct,
      },
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.get('/supporters', async (req, res) => {
  const limit = Math.min(Number(req.query.limit || 50), 50);

  try {
    const [rows] = await getPool().query(
      `SELECT
         COALESCE(pi.user_id, pi.device_id) AS group_key,
         MAX(u.nick) AS user_nick,
         MAX(u.real_name) AS user_real_name,
         MAX(pi.nick) AS intent_nick,
         SUM(pi.price_rub) AS total_rub,
         COUNT(*) AS donation_count,
         MAX(pi.paid_at) AS last_paid_at
       FROM payment_intents pi
       LEFT JOIN users u ON u.id = pi.user_id
       WHERE pi.game_slug = ? AND pi.status = 'paid'
       GROUP BY COALESCE(pi.user_id, pi.device_id)
       ORDER BY total_rub DESC, last_paid_at DESC
       LIMIT ?`,
      [GAME_SLUG, limit],
    );

    const entries = rows.map((row, index) => {
      const nick = row.user_nick || row.intent_nick || '';
      const realName = row.user_real_name || '';
      const label = leaderboardLabel(nick, realName);
      return {
        rank: index + 1,
        label: label === '—' ? null : label,
        totalRub: Number(row.total_rub) || 0,
        donationCount: Number(row.donation_count) || 0,
      };
    });

    return res.json({ limit, entries });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/guest/sync', async (req, res) => {
  const deviceId = validateDeviceId(req.body?.deviceId);
  if (!deviceId) {
    return res.status(400).json({ error: 'invalid deviceId', code: 'VALIDATION' });
  }

  const profile = req.body?.profile;
  if (!profile || typeof profile !== 'object') {
    return res.status(400).json({ error: 'profile object required', code: 'VALIDATION' });
  }

  try {
    const serverProfile = await loadGuestProfile(deviceId);
    const merged = mergeMonetizationBenefits(profile, serverProfile);
    await saveGuestProfile(deviceId, merged);
    return res.json({
      ok: true,
      benefits: {
        adsRemoved: Boolean(merged.adsRemoved),
        supporterTier: Number(merged.supporterTier) || 0,
      },
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/events/purchase', async (req, res) => {
  const deviceId = validateDeviceId(req.body?.deviceId);
  const productId = String(req.body?.productId || '').trim();
  if (!deviceId || !productId) {
    return res.status(400).json({ error: 'deviceId and productId required', code: 'VALIDATION' });
  }

  const store = String(req.body?.store || 'unknown').trim().slice(0, 32);
  const userId = req.body?.userId ? String(req.body.userId).trim() : null;
  const priceRub = req.body?.priceRub != null ? Number(req.body.priceRub) : null;
  const ideaId = req.body?.ideaId ? String(req.body.ideaId).trim() : null;
  const purchaseId = newId();

  try {
    await getPool().query(
      `INSERT INTO purchase_events (id, game_slug, device_id, user_id, product_id, store, price_rub)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [purchaseId, GAME_SLUG, deviceId, userId, productId, store, priceRub],
    );

    const user = await lookupUserById(userId);
    const productLabel = PRODUCT_LABELS[productId] || productId;

    if (productId === TIER3_PRODUCT && ideaId) {
      const [ideaRows] = await getPool().query(
        `SELECT id, idea_text, email, user_id, status
         FROM donation_ideas
         WHERE id = ? AND game_slug = ? AND device_id = ?
         LIMIT 1`,
        [ideaId, GAME_SLUG, deviceId],
      );
      const idea = ideaRows[0];
      if (idea && idea.status === 'draft') {
        await getPool().query(
          `UPDATE donation_ideas
           SET status = 'paid', product_id = ?, purchase_event_id = ?, paid_at = CURRENT_TIMESTAMP,
               user_id = COALESCE(user_id, ?)
           WHERE id = ?`,
          [productId, purchaseId, userId, ideaId],
        );

        const thanksEmail = user?.email || idea.email;
        const nick = user?.nick || null;
        if (thanksEmail) {
          await sendDonationIdeaThanks({
            toEmail: thanksEmail,
            nick,
            ideaText: idea.idea_text,
          });
        }
        await notifyAdminDonationIdea({
          ideaText: idea.idea_text,
          fromEmail: thanksEmail,
          nick,
          userId: user?.id || idea.user_id || userId,
        });
      }
    } else if (user?.email) {
      await sendDonationThanks({
        toEmail: user.email,
        nick: user.nick,
        productLabel,
      });
    }

    return res.status(201).json({ ok: true });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/donations/idea', async (req, res) => {
  const deviceId = validateDeviceId(req.body?.deviceId);
  const ideaText = String(req.body?.ideaText || '').trim();
  if (!deviceId) {
    return res.status(400).json({ error: 'invalid deviceId', code: 'VALIDATION' });
  }
  if (ideaText.length < 10 || ideaText.length > 2000) {
    return res.status(400).json({
      error: 'ideaText must be 10-2000 chars',
      code: 'VALIDATION',
    });
  }

  const user = await resolveOptionalUser(req);
  let email;
  let userId = null;

  if (user) {
    email = user.email;
    userId = user.id;
  } else {
    email = normalizeEmail(req.body?.email);
    if (!email || !isValidEmail(email)) {
      return res.status(400).json({
        error: 'valid email required for guest idea',
        code: 'VALIDATION',
      });
    }
  }

  const id = newId();
  try {
    await getPool().query(
      `INSERT INTO donation_ideas
         (id, game_slug, device_id, user_id, email, idea_text, status, product_id)
       VALUES (?, ?, ?, ?, ?, ?, 'draft', ?)`,
      [id, GAME_SLUG, deviceId, userId, email, ideaText, TIER3_PRODUCT],
    );
    return res.status(201).json({ id, status: 'draft' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/donations/payment-intent', async (req, res) => {
  const settings = await getGameSettings();
  if (!settings.donationsEnabled) {
    return res.status(403).json({ error: 'donations disabled', code: 'DISABLED' });
  }

  const deviceId = validateDeviceId(req.body?.deviceId);
  const productId = String(req.body?.productId || '').trim();
  if (!deviceId || !productId) {
    return res.status(400).json({
      error: 'deviceId and productId required',
      code: 'VALIDATION',
    });
  }
  if (!PRODUCT_PRICES[productId]) {
    return res.status(400).json({ error: 'unknown productId', code: 'VALIDATION' });
  }

  const user = await resolveOptionalUser(req);
  let email = null;
  let userId = null;
  let nick = String(req.body?.nick || '').trim() || null;

  if (user) {
    email = user.email;
    userId = user.id;
    nick = nick || user.nick;
  } else {
    const guestEmail = normalizeEmail(req.body?.email);
    if (guestEmail && isValidEmail(guestEmail)) {
      email = guestEmail;
    }
  }

  const ideaId = req.body?.ideaId ? String(req.body.ideaId).trim() : null;

  try {
    const intent = await createPaymentIntent({
      deviceId,
      productId,
      userId,
      email,
      nick,
      ideaId,
    });

    const paymentSettings = await getGameSettings();
    const envQr = (process.env.PAYMENT_QR_URL || '').trim() || null;

    return res.status(201).json({
      id: intent.id,
      paymentCode: intent.payment_code,
      productId: intent.product_id,
      productLabel: productLabel(productId),
      priceRub: intent.price_rub,
      status: intent.status,
      payment: {
        sbpUrl: resolveSbpUrlForProduct(paymentSettings, productId),
        qrUrl: paymentSettings.paymentQrUrl || envQr,
        comment: intent.payment_code,
      },
    });
  } catch (error) {
    if (error.code === 'VALIDATION') {
      return res.status(400).json({ error: error.message, code: 'VALIDATION' });
    }
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.post('/events/ad', async (req, res) => {
  const deviceId = validateDeviceId(req.body?.deviceId);
  if (!deviceId) {
    return res.status(400).json({ error: 'invalid deviceId', code: 'VALIDATION' });
  }

  const events = Array.isArray(req.body?.events) ? req.body.events : [req.body];
  const rows = [];

  for (const item of events) {
    const eventType = String(item?.eventType || item?.type || '').trim();
    if (!AD_EVENT_TYPES.has(eventType)) continue;
    rows.push([newId(), GAME_SLUG, deviceId, eventType]);
  }

  if (!rows.length) {
    return res.status(400).json({ error: 'no valid ad events', code: 'VALIDATION' });
  }

  try {
    await getPool().query(
      `INSERT INTO ad_events (id, game_slug, device_id, event_type) VALUES ?`,
      [rows],
    );
    return res.status(201).json({ ok: true, count: rows.length });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

// --- Admin ---

const adminRouter = express.Router();
adminRouter.use(adminAuthMiddleware);

adminRouter.get('/settings', async (_req, res) => {
  try {
    const settings = await getGameSettings();
    return res.json({ game: GAME_SLUG, ...settings });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.patch('/settings', async (req, res) => {
  const body = req.body || {};
  const updates = [];
  const params = [];

  if (body.adsEnabled != null) {
    updates.push('ads_enabled = ?');
    params.push(body.adsEnabled ? 1 : 0);
  }
  if (body.donationsEnabled != null) {
    updates.push('donations_enabled = ?');
    params.push(body.donationsEnabled ? 1 : 0);
  }
  if (body.paymentSbpUrl !== undefined) {
    updates.push('payment_sbp_url = ?');
    const url = String(body.paymentSbpUrl || '').trim();
    params.push(url.length ? url.slice(0, 512) : null);
  }
  if (body.paymentQrUrl !== undefined) {
    updates.push('payment_qr_url = ?');
    const url = String(body.paymentQrUrl || '').trim();
    params.push(url.length ? url.slice(0, 512) : null);
  }
  if (body.paymentSbpUrlTier1 !== undefined) {
    updates.push('payment_sbp_url_tier1 = ?');
    const url = String(body.paymentSbpUrlTier1 || '').trim();
    params.push(url.length ? url.slice(0, 512) : null);
  }
  if (body.paymentSbpUrlTier2 !== undefined) {
    updates.push('payment_sbp_url_tier2 = ?');
    const url = String(body.paymentSbpUrlTier2 || '').trim();
    params.push(url.length ? url.slice(0, 512) : null);
  }
  if (body.paymentSbpUrlTier3 !== undefined) {
    updates.push('payment_sbp_url_tier3 = ?');
    const url = String(body.paymentSbpUrlTier3 || '').trim();
    params.push(url.length ? url.slice(0, 512) : null);
  }
  if (body.paymentSbpUrlRemoveAds !== undefined) {
    updates.push('payment_sbp_url_remove_ads = ?');
    const url = String(body.paymentSbpUrlRemoveAds || '').trim();
    params.push(url.length ? url.slice(0, 512) : null);
  }

  if (!updates.length) {
    return res.status(400).json({ error: 'nothing to update', code: 'VALIDATION' });
  }

  params.push(GAME_SLUG);

  try {
    await getPool().query(
      `UPDATE game_settings SET ${updates.join(', ')} WHERE game_slug = ?`,
      params,
    );
    const settings = await getGameSettings();
    return res.json({ game: GAME_SLUG, ...settings });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.get('/players/registered', async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 100, 500);
  const offset = Math.max(Number(req.query.offset) || 0, 0);

  try {
    const [rows] = await getPool().query(
      `SELECT u.id, u.email, u.nick, u.real_name, u.created_at, u.email_verified,
              p.profile_json, p.updated_at AS profile_updated_at
       FROM users u
       LEFT JOIN user_profiles p ON p.user_id = u.id
       ORDER BY u.created_at DESC
       LIMIT ? OFFSET ?`,
      [limit, offset],
    );

    const [countRows] = await getPool().query(`SELECT COUNT(*) AS total FROM users`);

    const players = rows.map((row) => {
      let profile = {};
      try {
        profile = typeof row.profile_json === 'string'
          ? JSON.parse(row.profile_json)
          : row.profile_json || {};
      } catch {
        profile = {};
      }
      return {
        id: row.id,
        email: row.email,
        nick: row.nick,
        realName: row.real_name,
        emailVerified: Boolean(row.email_verified),
        createdAt: row.created_at,
        profileUpdatedAt: row.profile_updated_at,
        mapClassic: profile.mapClassic ?? 1,
        scoreClassic: profile.scoreClassic ?? 0,
        supporterTier: profile.supporterTier ?? 0,
        adsRemoved: Boolean(profile.adsRemoved),
        difficulty: profile.difficulty ?? 'average',
      };
    });

    return res.json({
      total: countRows[0]?.total ?? 0,
      limit,
      offset,
      players,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.patch('/players/registered/:userId/ads-removed', async (req, res) => {
  const userId = String(req.params.userId || '').trim();
  if (!userId) {
    return res.status(400).json({ error: 'userId required', code: 'VALIDATION' });
  }

  if (req.body?.adsRemoved === undefined || req.body?.adsRemoved === null) {
    return res.status(400).json({ error: 'adsRemoved required', code: 'VALIDATION' });
  }

  const adsRemoved = Boolean(req.body.adsRemoved);

  try {
    const [rows] = await getPool().query(
      `SELECT profile_json FROM user_profiles WHERE user_id = ? LIMIT 1`,
      [userId],
    );
    if (!rows.length) {
      return res.status(404).json({ error: 'profile not found', code: 'NOT_FOUND' });
    }

    let profile = {};
    try {
      profile = typeof rows[0].profile_json === 'string'
        ? JSON.parse(rows[0].profile_json)
        : rows[0].profile_json || {};
    } catch {
      profile = {};
    }

    const merged = { ...profile, adsRemoved };
    await getPool().query(
      `UPDATE user_profiles SET profile_json = ? WHERE user_id = ?`,
      [JSON.stringify(merged), userId],
    );

    return res.json({ userId, adsRemoved: merged.adsRemoved });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.get('/players/guests', async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 100, 500);
  const offset = Math.max(Number(req.query.offset) || 0, 0);

  try {
    const [rows] = await getPool().query(
      `SELECT device_id, profile_json, first_seen, last_seen
       FROM guest_devices
       WHERE game_slug = ?
       ORDER BY last_seen DESC
       LIMIT ? OFFSET ?`,
      [GAME_SLUG, limit, offset],
    );

    const [countRows] = await getPool().query(
      `SELECT COUNT(*) AS total FROM guest_devices WHERE game_slug = ?`,
      [GAME_SLUG],
    );

    const guests = rows.map((row) => {
      let profile = {};
      try {
        profile = typeof row.profile_json === 'string'
          ? JSON.parse(row.profile_json)
          : row.profile_json || {};
      } catch {
        profile = {};
      }
      return {
        deviceId: row.device_id,
        firstSeen: row.first_seen,
        lastSeen: row.last_seen,
        mapClassic: profile.mapClassic ?? 1,
        scoreClassic: profile.scoreClassic ?? 0,
        supporterTier: profile.supporterTier ?? 0,
        adsRemoved: Boolean(profile.adsRemoved),
        difficulty: profile.difficulty ?? 'average',
      };
    });

    return res.json({
      total: countRows[0]?.total ?? 0,
      limit,
      offset,
      guests,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.delete('/players/guests', async (_req, res) => {
  try {
    const [result] = await getPool().query(
      `DELETE FROM guest_devices WHERE game_slug = ?`,
      [GAME_SLUG],
    );
    return res.json({
      deleted: result.affectedRows ?? 0,
      game: GAME_SLUG,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.get('/stats', async (_req, res) => {
  try {
    const pool = getPool();
    const days = 14;

    const [[usersCount]] = await pool.query(
      `SELECT COUNT(*) AS c FROM users`,
    );
    const [[guestsCount]] = await pool.query(
      `SELECT COUNT(*) AS c FROM guest_devices WHERE game_slug = ?`,
      [GAME_SLUG],
    );
    const [[guestsActive24h]] = await pool.query(
      `SELECT COUNT(*) AS c FROM guest_devices
       WHERE game_slug = ? AND last_seen >= UTC_TIMESTAMP() - INTERVAL 1 DAY`,
      [GAME_SLUG],
    );
    const [[guestsActive7d]] = await pool.query(
      `SELECT COUNT(*) AS c FROM guest_devices
       WHERE game_slug = ? AND last_seen >= UTC_TIMESTAMP() - INTERVAL 7 DAY`,
      [GAME_SLUG],
    );
    const [[usersActive7d]] = await pool.query(
      `SELECT COUNT(*) AS c FROM user_profiles
       WHERE updated_at >= UTC_TIMESTAMP() - INTERVAL 7 DAY`,
    );
    const [[ads7d]] = await pool.query(
      `SELECT COUNT(*) AS c FROM ad_events
       WHERE game_slug = ? AND created_at >= UTC_TIMESTAMP() - INTERVAL 7 DAY`,
      [GAME_SLUG],
    );
    const [[paid7d]] = await pool.query(
      `SELECT COUNT(*) AS cnt, COALESCE(SUM(price_rub), 0) AS sumRub
       FROM payment_intents
       WHERE game_slug = ? AND status = 'paid'
         AND COALESCE(paid_at, created_at) >= UTC_TIMESTAMP() - INTERVAL 7 DAY`,
      [GAME_SLUG],
    );

    const [guestActivityRows] = await pool.query(
      `SELECT DATE(last_seen) AS day, COUNT(*) AS c
       FROM guest_devices
       WHERE game_slug = ?
         AND last_seen >= UTC_DATE() - INTERVAL ? DAY
       GROUP BY DATE(last_seen)
       ORDER BY day ASC`,
      [GAME_SLUG, days - 1],
    );
    const [regActivityRows] = await pool.query(
      `SELECT DATE(created_at) AS day, COUNT(*) AS c
       FROM users
       WHERE created_at >= UTC_DATE() - INTERVAL ? DAY
       GROUP BY DATE(created_at)
       ORDER BY day ASC`,
      [days - 1],
    );
    const [adDayRows] = await pool.query(
      `SELECT DATE(created_at) AS day, COUNT(*) AS c
       FROM ad_events
       WHERE game_slug = ?
         AND created_at >= UTC_DATE() - INTERVAL ? DAY
       GROUP BY DATE(created_at)
       ORDER BY day ASC`,
      [GAME_SLUG, days - 1],
    );
    const [paidDayRows] = await pool.query(
      `SELECT DATE(COALESCE(paid_at, created_at)) AS day,
              COUNT(*) AS cnt,
              COALESCE(SUM(price_rub), 0) AS sumRub
       FROM payment_intents
       WHERE game_slug = ? AND status = 'paid'
         AND COALESCE(paid_at, created_at) >= UTC_DATE() - INTERVAL ? DAY
       GROUP BY DATE(COALESCE(paid_at, created_at))
       ORDER BY day ASC`,
      [GAME_SLUG, days - 1],
    );

    const [guestProfiles] = await pool.query(
      `SELECT profile_json FROM guest_devices WHERE game_slug = ?`,
      [GAME_SLUG],
    );
    const [userProfiles] = await pool.query(
      `SELECT profile_json FROM user_profiles`,
    );

    const missionMap = new Map();
    function addMission(raw) {
      let profile = {};
      try {
        profile = typeof raw === 'string' ? JSON.parse(raw) : raw || {};
      } catch {
        profile = {};
      }
      const m = Number(profile.mapClassic) || 1;
      missionMap.set(m, (missionMap.get(m) || 0) + 1);
    }
    for (const row of guestProfiles) addMission(row.profile_json);
    for (const row of userProfiles) addMission(row.profile_json);

    const dayKeys = [];
    const today = new Date();
    for (let i = days - 1; i >= 0; i -= 1) {
      const d = new Date(Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), today.getUTCDate()));
      d.setUTCDate(d.getUTCDate() - i);
      dayKeys.push(d.toISOString().slice(0, 10));
    }

    function fillSeries(rows, valueKey = 'c') {
      const map = new Map(
        rows.map((r) => {
          const day = r.day instanceof Date
            ? r.day.toISOString().slice(0, 10)
            : String(r.day).slice(0, 10);
          return [day, Number(r[valueKey]) || 0];
        }),
      );
      return dayKeys.map((day) => ({ day, value: map.get(day) || 0 }));
    }

    const guestByDay = fillSeries(guestActivityRows);
    const regByDay = fillSeries(regActivityRows);
    const activityByDay = dayKeys.map((day, i) => ({
      day,
      value: guestByDay[i].value + regByDay[i].value,
      guests: guestByDay[i].value,
      registrations: regByDay[i].value,
    }));

    const adsByDay = fillSeries(adDayRows);
    const paymentsByDay = dayKeys.map((day) => {
      const row = paidDayRows.find((r) => {
        const d = r.day instanceof Date
          ? r.day.toISOString().slice(0, 10)
          : String(r.day).slice(0, 10);
        return d === day;
      });
      return {
        day,
        count: row ? Number(row.cnt) || 0 : 0,
        sumRub: row ? Number(row.sumRub) || 0 : 0,
      };
    });

    const missions = [...missionMap.entries()]
      .sort((a, b) => a[0] - b[0])
      .map(([mission, count]) => ({ mission, count }));

    return res.json({
      kpi: {
        registered: Number(usersCount.c) || 0,
        guests: Number(guestsCount.c) || 0,
        guestsActive24h: Number(guestsActive24h.c) || 0,
        guestsActive7d: Number(guestsActive7d.c) || 0,
        usersActive7d: Number(usersActive7d.c) || 0,
        adShows7d: Number(ads7d.c) || 0,
        paidCount7d: Number(paid7d.cnt) || 0,
        paidSumRub7d: Number(paid7d.sumRub) || 0,
      },
      charts: {
        activity14d: activityByDay,
        ads14d: adsByDay,
        payments14d: paymentsByDay,
        missions,
      },
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.get('/payments', async (req, res) => {
  const status = String(req.query.status || 'pending').trim();
  const allowed = new Set(['pending', 'paid', 'cancelled', 'all']);
  if (!allowed.has(status)) {
    return res.status(400).json({ error: 'invalid status', code: 'VALIDATION' });
  }

  const limit = Math.min(Number(req.query.limit) || 100, 500);
  const offset = Math.max(Number(req.query.offset) || 0, 0);

  try {
    const where = status === 'all' ? 'game_slug = ?' : 'game_slug = ? AND status = ?';
    const params = status === 'all' ? [GAME_SLUG] : [GAME_SLUG, status];

    const [rows] = await getPool().query(
      `SELECT id, device_id, user_id, email, nick, product_id, price_rub, payment_code,
              idea_id, status, created_at, paid_at
       FROM payment_intents
       WHERE ${where}
       ORDER BY created_at DESC
       LIMIT ? OFFSET ?`,
      [...params, limit, offset],
    );

    const [countRows] = await getPool().query(
      `SELECT COUNT(*) AS total FROM payment_intents WHERE ${where}`,
      params,
    );

    const intents = rows.map((row) => ({
      id: row.id,
      deviceId: row.device_id,
      userId: row.user_id,
      email: row.email,
      nick: row.nick,
      productId: row.product_id,
      productLabel: productLabel(row.product_id),
      priceRub: Number(row.price_rub),
      paymentCode: row.payment_code,
      ideaId: row.idea_id,
      status: row.status,
      createdAt: row.created_at,
      paidAt: row.paid_at,
    }));

    return res.json({
      total: countRows[0]?.total ?? 0,
      limit,
      offset,
      status,
      intents,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.patch('/payments/:intentId/mark-paid', async (req, res) => {
  const intentId = String(req.params.intentId || '').trim();
  if (!intentId) {
    return res.status(400).json({ error: 'intentId required', code: 'VALIDATION' });
  }

  try {
    const intent = await fulfillPaymentIntent(intentId);
    return res.json({
      id: intent.id,
      status: 'paid',
      paymentCode: intent.payment_code,
    });
  } catch (error) {
    if (error.code === 'NOT_FOUND') {
      return res.status(404).json({ error: error.message, code: 'NOT_FOUND' });
    }
    if (error.code === 'CONFLICT') {
      return res.status(409).json({ error: error.message, code: 'CONFLICT' });
    }
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.patch('/payments/:intentId/cancel', async (req, res) => {
  const intentId = String(req.params.intentId || '').trim();
  if (!intentId) {
    return res.status(400).json({ error: 'intentId required', code: 'VALIDATION' });
  }

  try {
    await cancelPaymentIntent(intentId);
    return res.json({ id: intentId, status: 'cancelled' });
  } catch (error) {
    if (error.code === 'NOT_FOUND') {
      return res.status(404).json({ error: error.message, code: 'NOT_FOUND' });
    }
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.get('/finance/summary', async (req, res) => {
  const months = Math.min(Math.max(Number(req.query.months) || 12, 1), 36);

  try {
    const [purchaseRows] = await getPool().query(
      `SELECT DATE_FORMAT(created_at, '%Y-%m') AS month,
              product_id,
              COUNT(*) AS count,
              COALESCE(SUM(price_rub), 0) AS total_rub
       FROM purchase_events
       WHERE game_slug = ?
         AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? MONTH)
       GROUP BY month, product_id
       ORDER BY month DESC`,
      [GAME_SLUG, months],
    );

    const [adRows] = await getPool().query(
      `SELECT DATE_FORMAT(created_at, '%Y-%m') AS month,
              event_type,
              COUNT(*) AS count
       FROM ad_events
       WHERE game_slug = ?
         AND created_at >= DATE_SUB(CURDATE(), INTERVAL ? MONTH)
       GROUP BY month, event_type
       ORDER BY month DESC`,
      [GAME_SLUG, months],
    );

    const monthMap = new Map();

    for (const row of purchaseRows) {
      const entry = monthMap.get(row.month) || emptyMonth(row.month);
      entry.donations.count += Number(row.count);
      entry.donations.totalRub += Number(row.total_rub);
      entry.donations.byProduct[row.product_id] =
        (entry.donations.byProduct[row.product_id] || 0) + Number(row.count);
      monthMap.set(row.month, entry);
    }

    for (const row of adRows) {
      const entry = monthMap.get(row.month) || emptyMonth(row.month);
      entry.ads[row.event_type] = Number(row.count);
      entry.ads.total += Number(row.count);
      monthMap.set(row.month, entry);
    }

    const summary = Array.from(monthMap.values()).sort((a, b) =>
      b.month.localeCompare(a.month),
    );

    return res.json({
      game: GAME_SLUG,
      months: summary,
      yandexRevenueNote:
        'Revenue in RUB from Yandex RSYa API — connect YANDEX_RSYA_TOKEN in a future release.',
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.get('/finance/purchases', async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 100, 500);
  const offset = Math.max(Number(req.query.offset) || 0, 0);

  try {
    const [rows] = await getPool().query(
      `SELECT pe.id, pe.device_id, pe.user_id, pe.product_id, pe.store,
              pe.price_rub, pe.created_at,
              u.nick, u.email
       FROM purchase_events pe
       LEFT JOIN users u ON u.id = pe.user_id
       WHERE pe.game_slug = ?
       ORDER BY pe.created_at DESC
       LIMIT ? OFFSET ?`,
      [GAME_SLUG, limit, offset],
    );

    const [countRows] = await getPool().query(
      `SELECT COUNT(*) AS total FROM purchase_events WHERE game_slug = ?`,
      [GAME_SLUG],
    );

    return res.json({
      total: countRows[0]?.total ?? 0,
      limit,
      offset,
      purchases: rows.map((row) => ({
        id: row.id,
        deviceId: row.device_id,
        userId: row.user_id,
        nick: row.nick,
        email: row.email,
        productId: row.product_id,
        store: row.store,
        priceRub: row.price_rub != null ? Number(row.price_rub) : null,
        createdAt: row.created_at,
      })),
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

adminRouter.get('/finance/ideas', async (req, res) => {
  const limit = Math.min(Number(req.query.limit) || 100, 500);
  const offset = Math.max(Number(req.query.offset) || 0, 0);
  const status = String(req.query.status || 'paid').trim();

  try {
    const [rows] = await getPool().query(
      `SELECT di.id, di.device_id, di.user_id, di.email, di.idea_text, di.status,
              di.product_id, di.created_at, di.paid_at,
              u.nick AS user_nick, u.email AS user_email
       FROM donation_ideas di
       LEFT JOIN users u ON u.id = di.user_id
       WHERE di.game_slug = ? AND (? = 'all' OR di.status = ?)
       ORDER BY COALESCE(di.paid_at, di.created_at) DESC
       LIMIT ? OFFSET ?`,
      [GAME_SLUG, status, status, limit, offset],
    );

    return res.json({
      limit,
      offset,
      status,
      ideas: rows.map((row) => ({
        id: row.id,
        deviceId: row.device_id,
        userId: row.user_id,
        nick: row.user_nick,
        email: row.user_email || row.email,
        ideaText: row.idea_text,
        status: row.status,
        productId: row.product_id,
        createdAt: row.created_at,
        paidAt: row.paid_at,
      })),
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

function emptyMonth(month) {
  return {
    month,
    donations: { count: 0, totalRub: 0, byProduct: {} },
    ads: { banner: 0, interstitial: 0, rewarded: 0, total: 0 },
    yandexRevenueRub: null,
  };
}

module.exports = { router, adminRouter };
