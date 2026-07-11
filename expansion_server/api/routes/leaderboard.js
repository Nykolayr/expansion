const express = require('express');

const { getPool } = require('../config/database');
const { leaderboardLabel } = require('../utils/nick');

const router = express.Router();

router.get('/', async (req, res) => {
  const limit = Math.min(Number(req.query.limit || 50), 50);

  try {
    const [rows] = await getPool().query(
      `SELECT u.nick, u.real_name,
              CAST(JSON_UNQUOTE(JSON_EXTRACT(p.profile_json, '$.scoreClassic')) AS UNSIGNED) AS score_classic,
              CAST(JSON_UNQUOTE(JSON_EXTRACT(p.profile_json, '$.mapClassic')) AS UNSIGNED) AS map_classic
       FROM users u
       INNER JOIN user_profiles p ON p.user_id = u.id
       WHERE u.email_verified = 1
       ORDER BY score_classic DESC, map_classic DESC, u.created_at ASC
       LIMIT ?`,
      [limit],
    );

    const entries = rows.map((row, index) => ({
      rank: index + 1,
      label: leaderboardLabel(row.nick, row.real_name),
      nick: row.nick,
      realName: row.real_name,
      scoreClassic: Number(row.score_classic) || 0,
      mapClassic: Number(row.map_classic) || 1,
    }));

    return res.json({ limit, entries });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: 'database error', code: 'INTERNAL' });
  }
});

module.exports = router;
