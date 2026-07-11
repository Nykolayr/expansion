const express = require('express');

const { getPool } = require('../config/database');

const router = express.Router();

async function loadLatestContent() {
  const [rows] = await getPool().query(
    `SELECT content_version, payload_json, published_at
     FROM campaign_content
     ORDER BY content_version DESC
     LIMIT 1`,
  );
  if (!rows.length) return null;

  const row = rows[0];
  let payload = row.payload_json;
  if (typeof payload === 'string') {
    payload = JSON.parse(payload);
  }

  return {
    contentVersion: row.content_version,
    publishedAt: row.published_at,
    payload,
  };
}

router.get('/version', async (_req, res) => {
  try {
    const latest = await loadLatestContent();
    if (!latest) {
      return res.json({
        contentVersion: 0,
        sceneCount: 0,
        note: 'no published content',
      });
    }

    const sceneCount =
      latest.payload.sceneCount ??
      (Array.isArray(latest.payload.scenes) ? latest.payload.scenes.length : 0);

    return res.json({
      contentVersion: latest.contentVersion,
      sceneCount,
      publishedAt: latest.publishedAt,
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

router.get('/pack', async (_req, res) => {
  try {
    const latest = await loadLatestContent();
    if (!latest) {
      return res.status(404).json({ error: 'no content published', code: 'NOT_FOUND' });
    }

    return res.json(latest.payload);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

/** @deprecated use /pack */
router.get('/scenes', async (_req, res) => {
  try {
    const latest = await loadLatestContent();
    if (!latest) {
      return res.json({
        contentVersion: 0,
        scenes: [],
        note: 'no published content',
      });
    }

    return res.json({
      contentVersion: latest.contentVersion,
      scenes: latest.payload.scenes ?? [],
      layouts: latest.payload.layouts ?? {},
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

module.exports = router;
