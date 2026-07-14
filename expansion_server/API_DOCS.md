# API Expansion — канонический контракт

> **Статус:** v0.3 — auth, profile, leaderboard, platform admin, expansion remote config.  
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
{ "ok": true, "service": "expansion-api", "version": "0.3.0", "db": true, "emailConfigured": true }
```

---

## Аутентификация

### `GET /api/auth/nick-available?nick=StarLord`

```json
{ "available": true }
```

Занятость — **только среди подтверждённых аккаунтов** (`users`). Незавершённые регистрации (ожидание кода) в UI не блокируют ник; при `POST /register` чужая активная верификация по тому же нику всё ещё даёт `409 NICK_TAKEN`.

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

### `PATCH /api/account`

Bearer. Обновление аккаунта: `realName`, `nick`, опционально `currentPassword` + `newPassword` (мин. 6). Email не меняется. При смене пароля все refresh-токены сбрасываются (`passwordChanged: true` в ответе).

```json
{
  "realName": "Иван",
  "nick": "StarLord",
  "currentPassword": "oldpass",
  "newPassword": "newpass12"
}
```

Ошибки: `409 NICK_TAKEN`, `401 AUTH` (неверный текущий пароль), коды валидации ника.

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

## Platform (danilagames admin)

### `POST /api/platform/admin/login`

```json
{ "username": "admin", "password": "..." }
```

Ответ `200`:

```json
{ "accessToken": "...", "username": "admin", "expiresIn": "8h" }
```

Env: `ADMIN_USERNAME`, `ADMIN_PASSWORD`, `ADMIN_JWT_TTL`, `CORS_ORIGINS`.

### `GET /api/platform/games`

Bearer **admin** JWT.

```json
{
  "games": [
    { "slug": "expansion", "title": "Expansion", "adminPath": "/admin/expansion/" }
  ]
}
```

---

## Expansion (app + admin)

### `GET /api/expansion/config` (public)

```json
{
  "game": "expansion",
  "adsEnabled": true,
  "donationsEnabled": true,
  "payment": {
    "sbpUrl": "https://...",
    "qrUrl": "https://..."
  }
}
```

`payment.byProduct` — ссылка СБП по productId; `payment.qrUrl` — опциональная картинка QR.

### `GET /api/expansion/supporters?limit=50` (public)

Список подтверждённых донатов (статус `paid`), агрегированный по аккаунту или устройству.

```json
{
  "limit": 50,
  "entries": [
    {
      "rank": 1,
      "label": "Pilot (Иван)",
      "totalRub": 598,
      "donationCount": 2
    }
  ]
}
```

`label: null` — без ника (клиент показывает «Аноним»). Сортировка: сумма ↓, дата последнего доната ↓.

### `POST /api/expansion/guest/sync` (public)

```json
{
  "deviceId": "uuid-v4",
  "profile": { /* GuestProfile fields */ }
}
```

Ответ:

```json
{
  "ok": true,
  "benefits": { "adsRemoved": false, "supporterTier": 0 }
}
```

Сервер объединяет локальный профиль с оплаченными бенефитами (СБП) по `deviceId`.

### `POST /api/expansion/donations/payment-intent` (public, optional Bearer)

Создаёт намерение оплаты, шлёт уведомление в Telegram. Тело:

```json
{
  "deviceId": "uuid",
  "productId": "com.ryjovs.expansion.remove_ads",
  "nick": "optional",
  "email": "optional-for-guest",
  "ideaId": "optional-for-tier3"
}
```

Ответ `201`:

```json
{
  "id": "uuid",
  "paymentCode": "EXP-A1B2C3",
  "productId": "...",
  "productLabel": "Убрать рекламу · 199 ₽",
  "priceRub": 199,
  "status": "pending",
  "payment": {
    "sbpUrl": "https://...",
    "qrUrl": "https://...",
    "comment": "EXP-A1B2C3"
  }
}
```

### `POST /api/expansion/events/purchase` (public, legacy IAP)

```json
{
  "deviceId": "uuid",
  "productId": "com.ryjovs.expansion.donate_tier1",
  "store": "in_app_purchase",
  "userId": "optional-if-logged-in",
  "priceRub": 99,
  "ideaId": "optional-uuid-for-tier3"
}
```

После записи покупки:

- tier1–2 / remove_ads: если есть `userId` с email — письмо «спасибо за поддержку»;
- tier3 + `ideaId`: статус идеи → `paid`, письмо игроку про идею, уведомление админу (`FEEDBACK_TO`).

### `POST /api/expansion/donations/idea` (public, optional Bearer)

Черновик идеи до оплаты tier3. Для гостя нужен email.

```json
{
  "deviceId": "uuid",
  "ideaText": "Описание идеи (10–2000)",
  "email": "guest@example.com"
}
```

Ответ `201`: `{ "id": "uuid", "status": "draft" }`

### `POST /api/expansion/events/ad` (public)

```json
{
  "deviceId": "uuid",
  "events": [{ "eventType": "banner" | "interstitial" | "rewarded" }]
}
```

### Admin `/api/admin/expansion/*` (Bearer admin JWT)

| Method | Path | Описание |
|--------|------|----------|
| GET | `/settings` | ads, donations, paymentSbpUrlTier1..3, paymentSbpUrlRemoveAds, paymentQrUrl |
| PATCH | `/settings` | флаги + ссылки СБП по тарифам |
| GET | `/payments?status=pending` | намерения оплаты СБП |
| PATCH | `/payments/:intentId/mark-paid` | подтвердить оплату вручную |
| PATCH | `/payments/:intentId/cancel` | отменить намерение |
| GET | `/players/registered` | users + profile summary |
| PATCH | `/players/registered/:userId/ads-removed` | `{ "adsRemoved": true }` — без рекламы для аккаунта |
| GET | `/players/guests` | guest_devices |
| GET | `/finance/summary?months=12` | донаты + показы по месяцам |
| GET | `/finance/purchases` | детализация покупок |
| GET | `/finance/ideas?status=paid` | идеи к донату tier3 |

---

## Обратная связь

### `POST /api/feedback`

Публичный endpoint. Если передан валидный `Authorization: Bearer`, email и ник берутся из аккаунта.

**Гость:**

```json
{
  "email": "player@example.com",
  "message": "Текст сообщения (10–2000 символов)"
}
```

**Аккаунт** (JWT):

```json
{
  "message": "Текст сообщения (10–2000 символов)"
}
```

Ответ `201`:

```json
{ "message": "feedback sent" }
```

Ошибки: `400 VALIDATION`, `503 EMAIL_SEND_FAILED` / `FEEDBACK_NOT_CONFIGURED`.

Письмо уходит на `FEEDBACK_TO` (или `ADMIN_EMAIL`, иначе `SMTP_USER`), `Reply-To` — email отправителя.

Дублирование в **Telegram** (тот же чат RedMobi), если заданы `EXPANSION_TELEGRAM_*` или `CALCULATOR_LEAD_TELEGRAM_*`. Сбой TG не меняет ответ `201`.

---

## Env (сервер)

См. `.env.example`: `DB_*`, `JWT_*`, `SMTP_*`, `APP_NAME`, `EMAIL_FROM`, `ADMIN_*`, `FEEDBACK_TO`, `CORS_ORIGINS`.

Миграции: `npm run migrate`.

---

## История изменений

| Дата | Изменение |
|------|-----------|
| 2026-07-14 | v0.3.3: СБП/QR payment intents, Telegram, admin «Оплаты», guest/sync benefits |
| 2026-07-14 | v0.3.2: donate ideas tier3, thank-you emails, admin finance/ideas |
| 2026-07-12 | v0.3.1: POST `/feedback` — обратная связь по email |
| 2026-07-12 | v0.3: platform admin, expansion config/events, guest devices |
| 2026-07-11 | v0.2.1: OTA campaign content (`/content/pack`, MariaDB) |
| 2026-07-11 | v0.2: MariaDB, email verify, nick, leaderboard, delete account |
| 2026-07-10 | Черновик структуры монорепо |
