const mysql = require('mysql2/promise');

let pool;

function getPool() {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.DB_HOST || '127.0.0.1',
      port: Number(process.env.DB_PORT || 3306),
      user: process.env.DB_USER || 'expansion',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'expansion',
      waitForConnections: true,
      connectionLimit: 10,
      namedPlaceholders: false,
    });
  }
  return pool;
}

async function pingDatabase() {
  const connection = await getPool().getConnection();
  try {
    await connection.query('SELECT 1');
    return true;
  } finally {
    connection.release();
  }
}

module.exports = { getPool, pingDatabase };
