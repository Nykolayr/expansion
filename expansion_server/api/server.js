const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const authRoutes = require('./routes/auth');
const profileRoutes = require('./routes/profile');
const contentRoutes = require('./routes/content');
const leaderboardRoutes = require('./routes/leaderboard');
const accountRoutes = require('./routes/account');
const { pingDatabase } = require('./config/database');

const app = express();
const port = Number(process.env.PORT || 3000);

app.use(cors());
app.use(express.json());

app.get('/api/health', async (_req, res) => {
  let db = false;
  try {
    db = await pingDatabase();
  } catch {
    db = false;
  }
  res.json({
    ok: true,
    service: 'expansion-api',
    version: '0.2.0',
    db,
  });
});

app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);
app.use('/api/content', contentRoutes);
app.use('/api/leaderboard', leaderboardRoutes);
app.use('/api/account', accountRoutes);

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error', code: 'INTERNAL' });
});

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Expansion API listening on http://127.0.0.1:${port}/api`);
  });
}

module.exports = app;
