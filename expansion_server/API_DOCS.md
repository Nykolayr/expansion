# API Expansion — канонический контракт

> **Статус:** v0.2 — auth, profile, leaderboard (MariaDB).  
> Хаб: [`../docs/API.md`](../docs/API.md) · Spec: [`../docs/auth-account-spec.md`](../docs/auth-account-spec.md)

## Base URL

| Среда | URL |
|-------|-----|
| Локально | `http://127.0.0.1:3000/api` |
| Prod (Beget VPS) | TBD при деплое |

Клиент: `--dart-define=API_BASE_URL=...` → `ApiConfig` в `expansion_app`.

## Формат ошибок

```json
{ "error": "message", "code": "OPTIONAL_CODE" }
```

## Health

### `GET /api/health`

```json
{ "ok": true, "service": "expansion-api", "version": "0.2.0", "db": true }
```

---

## Аутентификация

### `GET /api/auth/nick-available?nick=StarLord`

```json
{ "available": true }
```

Коды `reason`: `NICK_LENGTH`, `NICK_FORMAT`, `NICK_RESERVED`.

### `POST /api/auth/register`

Тело:

```json
{
  "email": "user@example.com",
  "password": "secret12",
  "nick": "StarLord",
  "realName": "Иван"
}
```

Опционально (l10n письма): `emailSubject`, `emailHtml`, `emailText` с `{{code}}`.

Ответ `201`:

```json
{
  "message": "verification code sent",
  "email": "user@example.com",
  "verificationExpiresAt": "2026-07-11T12:00:00.000Z"
}
```

Ошибки: `409 CONFLICT` (email exists → `suggestion: login`), `409 NICK_TAKEN`, `503 EMAIL_SEND_FAILED`.

### `POST /api/auth/verify-email`

```json
{
  "email": "user@example.com",
  "code": "123456"
}
```

Ответ `201`:

```json
{
  "accessToken": "…",
  "refreshToken": "…",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "nick": "StarLord",
    "realName": "Иван",
    "emailVerified": true
  }
}
```

### `POST /api/auth/login`

```json
{ "email": "user@example.com", "password": "secret12" }
```

Ответ — как verify-email (tokens + user).

### `POST /api/auth/refresh`

```json
{ "refreshToken": "…" }
```

Новая пара access + refresh (rotation).

### `POST /api/auth/forgot-password`

```json
{ "email": "user@example.com" }
```

Всегда `200` (не раскрываем наличие email). Код на почту, TTL 15 мин.

### `POST /api/auth/reset-password`

```json
{
  "email": "user@example.com",
  "code": "123456",
  "newPassword": "newsecret"
}
```

### `GET /api/auth/me`

`Authorization: Bearer <accessToken>`

```json
{
  "id": "uuid",
  "email": "user@example.com",
  "nick": "StarLord",
  "realName": "Иван",
  "emailVerified": true,
  "profile": { … }
}
```

### `POST /api/auth/logout`

Bearer + опционально `{ "refreshToken": "…" }`.

---

## Профиль

Зеркало `GuestProfile` + `nick`, `realName`, `email`.

### `GET /api/profile`

Bearer.

### `PUT /api/profile`

Bearer. Полное тело прогресса (как prefs). Можно обновить `realName` / `displayName`.

**Ник после регистрации не меняется (v1).**

---

## Аккаунт

### `DELETE /api/account`

Bearer. Удаляет user, profile, refresh tokens (CASCADE).

---

## Рейтинг

### `GET /api/leaderboard?limit=50`

Публичный. Только `email_verified = true`. Сортировка: `scoreClassic` DESC.

```json
{
  "limit": 50,
  "entries": [
    {
      "rank": 1,
      "label": "StarLord (Иван)",
      "nick": "StarLord",
      "realName": "Иван",
      "scoreClassic": 1200,
      "mapClassic": 8
    }
  ]
}
```

---

## Контент (OTA кампания)

Offline-first: клиент кэширует pack в SQLite, играет без сети.

### `GET /api/content/version`

```json
{ "contentVersion": 7, "sceneCount": 40, "publishedAt": "2026-07-11T12:00:00.000Z" }
```

### `GET /api/content/pack`

Публичный. Полный JSON-пакет (тот же формат, что bundled assets):

```json
{
  "contentVersion": 7,
  "sceneCount": 40,
  "scenes": [ /* scenes.json */ ],
  "layouts": { "6": { /* objects_6.json */ } }
}
```

Хранение: MariaDB `campaign_content`. Сборка: `node scripts/build-content-pack.js`, seed: `node scripts/seed-campaign-content.js`.

### `GET /api/content/scenes`

Deprecated alias — scenes + layouts из latest pack.

---

## Env (сервер)

См. `.env.example`: `DB_*`, `JWT_*`, `SMTP_*`, `APP_NAME`, `EMAIL_FROM`.

Миграции: `npm run migrate`.

---

## История изменений

| Дата | Изменение |
|------|-----------|
| 2026-07-11 | v0.2.1: OTA campaign content (`/content/pack`, MariaDB) |
| 2026-07-11 | v0.2: MariaDB, email verify, nick, leaderboard, delete account |
| 2026-07-10 | Черновик структуры монорепо |
