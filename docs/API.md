# Expansion — общая документация API

Папка **`D:\Projects\expansion`** — workspace платформы Expansion. Корневые правила Cursor: **`.cursor/rules/`**, **`AGENTS.md`**, **`expansion.code-workspace`**.

Пакеты (**`expansion_app`**, **`expansion_server`**, **`expansion_admin`**) — каталоги **одного монорепозитория**; у каждого свои **`.cursor/rules/`**.

## Статус

Backend **в разработке**. Клиент сейчас работает **офлайн** (prefs, SQLite, bundled assets).

## Канонический контракт REST

**Источник правды (когда появится):** **`expansion_server/API_DOCS.md`**

| Файл | Назначение |
|------|------------|
| **`../expansion_server/API_DOCS.md`** | Полное описание `/api/*`, тела, ошибки, JWT |

Абсолютно: **`D:\Projects\expansion\expansion_server\API_DOCS.md`**.

## Планируемые зоны API (черновик)

| Зона | Назначение |
|------|------------|
| `GET /api/leaderboard` | Топ-50 по очкам (только зарегистрированные) |
| `POST /api/auth/*` | Регистрация (verify email), вход, refresh, forgot/reset |
| `GET/PUT /api/profile` | Прогресс аккаунта (= GuestProfile) |
| `DELETE /api/account` | Удаление аккаунта |
| `GET /api/content/*` | Сценарии, миссии (синх с админкой) |
| `/api/admin/*` | CRUD контента, пользователи (JWT admin) |

Детали уточняются при старте `expansion_server`. Legacy-референс: `D:\Projects\expansion_old\apiserver`.

## Клиенты

- **`expansion_app/`** — Dio + `ApiConfig`, вызовы по мере появления API.
- **Админка** — те же маршруты `/api/admin/*`.

## Точки входа для агента

| Пакет | Файл |
|-------|------|
| Server | `expansion_server/.cursor/API_DOCUMENTATION.md` |
| Admin | `expansion_admin/.cursor/API_DOCUMENTATION.md` |
| App | `expansion_app/docs/project-specs.md` |

При смене API: правки в **`expansion_server/API_DOCS.md`**, код в **`expansion_server/`**, клиенты обновляют вызовы.
