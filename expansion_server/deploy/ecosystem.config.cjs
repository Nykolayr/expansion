module.exports = {
  apps: [
    {
      name: 'expansion-api',
      cwd: '/opt/expansion-api',
      script: 'api/server.js',
      instances: 1,
      autorestart: true,
      max_memory_restart: '256M',
      env: {
        NODE_ENV: 'production',
      },
    },
  ],
};
