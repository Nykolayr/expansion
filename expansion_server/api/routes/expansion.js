const express = require('express');
const crypto = require('crypto');

const { getPool } = require('../config/database');
const { adminAuthMiddleware } = require('../middleware/admin_auth');

const router = express.Router();
const GAME_SLUG = 'expansion';

const AD_EVENT_TYPES = new Set(['banner', 'interstitial', 'rewarded']);

function newId() {
  return crypto.randomUUID();
}

async function getGameSettings() {
  const [rows] = await getPool().query(
    `SELECT ads_enabled, donations_enabled, updated_at
     FROM game_settings WHERE game_slug = ? LIMIT 1`,
    [GAME_SLUG],
  );
  if (!rows.length) {
    return { adsEnabled: true, donationsEnabled: true, updatedAt: null };
  }
  const row = rows[0];
  return {
    adsEnabled: Boolean(row.ads_enabled),
    donationsEnabled: Boolean(row.donations_enabled),
    updatedAt: row.updated_at,
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
    return res.json({
      game: GAME_SLUG,
      adsEnabled: settings.adsEnabled,
      donationsEnabled: settings.donationsEnabled,
    });
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
    const profileJson = JSON.stringify(profile);
    await getPool().query(
      `INSERT INTO guest_devices (device_id, game_slug, profile_json)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE profile_json = VALUES(profile_json), last_seen = CURRENT_TIMESTAMP`,
      [deviceId, GAME_SLUG, profileJson],
    );
    return res.json({ ok: true });
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

  try {
    await getPool().query(
      `INSERT INTO purchase_events (id, game_slug, device_id, user_id, product_id, store, price_rub)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [newId(), GAME_SLUG, deviceId, userId, productId, store, priceRub],
    );
    return res.status(201).json({ ok: true });
  } catch (error) {
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

function emptyMonth(month) {
  return {
    month,
    donations: { count: 0, totalRub: 0, byProduct: {} },
    ads: { banner: 0, interstitial: 0, rewarded: 0, total: 0 },
    yandexRevenueRub: null,
  };
}

module.exports = { router, adminRouter };
