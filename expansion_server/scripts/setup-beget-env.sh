#!/bin/bash
# Запуск на Beget из ~/expansion_api после sync-beget.ps1
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PARENT_ENV="$ROOT/../.env"
TARGET="$ROOT/.env"

if [[ -f "$TARGET" ]]; then
  echo ".env already exists — skip (delete to regenerate)"
  exit 0
fi

if [[ ! -f "$PARENT_ENV" ]]; then
  echo "Parent .env not found: $PARENT_ENV"
  exit 1
fi

# shellcheck disable=SC1090
source "$PARENT_ENV"

JWT_SECRET="$(openssl rand -hex 32)"
DB_NAME="${EXPANSION_DB_NAME:-autogie1_expansion}"
DB_USER="${EXPANSION_DB_USER:-autogie1_expansion}"
DB_PASSWORD="${EXPANSION_DB_PASSWORD:-}"

if [[ -z "$DB_PASSWORD" ]]; then
  echo "Set EXPANSION_DB_PASSWORD before running, e.g.:"
  echo "  EXPANSION_DB_PASSWORD='...' bash scripts/setup-beget-env.sh"
  exit 1
fi

cat > "$TARGET" <<EOF
PORT=3000
JWT_SECRET=${JWT_SECRET}
JWT_ACCESS_TTL=1h
JWT_REFRESH_DAYS=30
APP_NAME=Expansion
APP_URL=https://danilagames.ru/expansion_api

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-3306}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}
DB_NAME=${DB_NAME}

SMTP_HOST=${SMTP_HOST}
SMTP_PORT=${SMTP_PORT}
SMTP_SECURE=${SMTP_SECURE:-false}
SMTP_USER=${SMTP_USER}
SMTP_PASS=${SMTP_PASS}
EMAIL_FROM=${EMAIL_FROM:-${SMTP_USER}}
EOF

chmod 600 "$TARGET"
echo "Created $TARGET (JWT + SMTP from parent, new DB vars)"
