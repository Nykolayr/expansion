#!/bin/bash
# Первичная установка Expansion API на redmobi VPS (Ubuntu)
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root"
  exit 1
fi

apt-get update -qq
apt-get install -y -qq nginx mariadb-server curl ca-certificates gnupg

if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y -qq nodejs
fi

if ! command -v pm2 >/dev/null 2>&1; then
  npm install -g pm2
fi

systemctl enable nginx mariadb
systemctl start nginx mariadb

# MariaDB: база expansion (если ещё нет)
DB_PASS="$(openssl rand -hex 16)"
JWT_SECRET="$(openssl rand -hex 32)"

mysql -e "CREATE DATABASE IF NOT EXISTS expansion CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -e "CREATE USER IF NOT EXISTS 'expansion'@'localhost' IDENTIFIED BY '${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON expansion.* TO 'expansion'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

mkdir -p /opt/expansion-api
ENV_FILE="/opt/expansion-api/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  cat > "$ENV_FILE" <<EOF
PORT=3000
NODE_ENV=production
JWT_SECRET=${JWT_SECRET}
JWT_ACCESS_TTL=1h
JWT_REFRESH_DAYS=30
APP_NAME=Expansion
APP_URL=https://expansion-api.danilagames.ru

DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=expansion
DB_PASSWORD=${DB_PASS}
DB_NAME=expansion

SMTP_HOST=
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=
SMTP_PASS=
EMAIL_FROM=
EOF
  chmod 600 "$ENV_FILE"
  echo "Created $ENV_FILE — add SMTP_* manually"
fi

# nginx
cat > /etc/nginx/sites-available/expansion-api <<'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name expansion-api.danilagames.ru 46.173.25.193;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
NGINX

ln -sf /etc/nginx/sites-available/expansion-api /etc/nginx/sites-enabled/expansion-api
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx

# UFW: 80 если включён
if command -v ufw >/dev/null 2>&1 && ufw status | grep -q active; then
  ufw allow 80/tcp || true
fi

echo "VPS bootstrap done. Deploy code to /opt/expansion-api and: pm2 start ecosystem.config.cjs"
