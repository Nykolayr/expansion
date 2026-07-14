# Платформа danilagames — админка

Мульти-игровая админка: UI на **Beget** (`danilagames.ru/admin/`), API и БД на **VPS**.

## URL

| URL | Назначение |
|-----|------------|
| https://danilagames.ru/ | Сайт (заглушка) |
| https://danilagames.ru/admin/ | Вход → выбор игры → админка |
| `http://46.173.25.193/api` | API (prod VPS) |

## Вход (v1)

- Логин: `admin` (или `ADMIN_USERNAME` в `.env` VPS)
- Пароль: задаётся в `.env` → `ADMIN_PASSWORD` (локально для dev: `123456`)

## Expansion — возможности

1. **Настройки** — вкл/выкл рекламы и донатов (remote config для приложения).
2. **Игроки** — таб «Зарегистрированные» (users) и «Гости» (device_id + профиль).
3. **Финансы** — донаты и показы рекламы по месяцам; список покупок.

## API (канон)

См. `expansion_server/API_DOCS.md` — разделы Platform и Expansion.

## Деплой

**Сайт + admin на Beget:**

```powershell
cd expansion_server
.\deploy\deploy-danilagames-site.ps1
```

**API на VPS:** обычный деплой expansion_server + `npm run migrate` для `003_platform_admin.sql`.

**CORS:** `CORS_ORIGINS=https://danilagames.ru` в `.env` VPS.

## Клиент

При bootstrap: `GET /expansion/config`, sync гостя, репорт покупок и показов рекламы.

См. также `docs/monetization-setup-ru.md`.
