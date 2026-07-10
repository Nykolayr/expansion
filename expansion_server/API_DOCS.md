# API Expansion — канонический контракт

> **Статус:** черновик. Backend ещё не реализован. Клиент работает офлайн.

При реализации `expansion_server` этот файл — **единственный источник правды** по REST.

Хаб: [`../docs/API.md`](../docs/API.md)

## Base URL

| Среда | URL |
|-------|-----|
| Локально | `http://127.0.0.1:3000/api` (уточнить при старте) |
| Прод | TBD |

Клиент: `--dart-define=API_BASE_URL=...` → `ApiConfig` в `expansion_app`.

## Аутентификация

### `POST /api/auth/register`

Регистрация (план).

### `POST /api/auth/login`

Вход → JWT.

### `GET /api/auth/me`

Текущий пользователь (Bearer).

## Профиль / прогресс

### `GET /api/profile`

Мета-прогресс: `mapClassic`, апгрейды, очки (план).

### `PUT /api/profile`

Синхронизация с клиента.

## Контент

### `GET /api/content/scenes`

Список сцен / миссий (для SQLite-кэша на устройстве).

### `GET /api/content/scenes/:id`

Детали миссии.

## Админка (`Authorization: Bearer`, role admin)

| Метод | Путь | Назначение |
|-------|------|------------|
| GET | `/api/admin/scenes` | Список |
| POST | `/api/admin/scenes` | Создать |
| PUT | `/api/admin/scenes/:id` | Обновить |
| DELETE | `/api/admin/scenes/:id` | Удалить |

## Ошибки

Единый формат JSON (уточнить при реализации):

```json
{ "error": "message", "code": "OPTIONAL_CODE" }
```

## Legacy

Старый Express API: `D:\Projects\expansion_old\apiserver` — только референс.

## История изменений

| Дата | Изменение |
|------|-----------|
| 2026-07-10 | Черновик структуры монорепо |
