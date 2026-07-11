# Текущее состояние expansion_server

## Стадия

**v0.2 — auth + profile + leaderboard (MariaDB)**

### Реализовано

- MariaDB миграция `migrations/001_initial.sql`
- Auth: register → verify email, login, refresh, forgot/reset password, logout
- Уникальный **nick**, **realName**, `GET /auth/nick-available`
- Profile: GET/PUT (зеркало GuestProfile)
- Leaderboard: топ 50, label `Ник (имя)`
- Delete account
- SMTP (nodemailer, как Joy Pick)

### Следующие шаги

1. Деплой на Beget VPS + prod `.env`
2. **Клиент** (`expansion_app`): экраны auth, синк, рейтинг (подэтап 2)

## Документация

- [`API_DOCS.md`](API_DOCS.md)
- [`../docs/auth-account-spec.md`](../docs/auth-account-spec.md)

## Локально

```bash
npm install
cp .env.example .env
npm run migrate
npm start
npm run load-check
```
