# expansion_server

Backend API для игры **Expansion**.

## Документация

| Файл | Назначение |
|------|------------|
| [`API_DOCS.md`](API_DOCS.md) | Канон REST (черновик) |
| [`CURRENT_STAGE.md`](CURRENT_STAGE.md) | Текущий этап |
| [`../docs/API.md`](../docs/API.md) | Хаб API |
| [`.cursor/API_DOCUMENTATION.md`](.cursor/API_DOCUMENTATION.md) | Точка входа для агента |

## Связь

- Клиент: [`../expansion_app/`](../expansion_app/)
- Админка: [`../expansion_admin/`](../expansion_admin/)
- Workspace: [`../expansion.code-workspace`](../expansion.code-workspace)
- Legacy: `D:\Projects\expansion_old\apiserver`

## Статус

**MVP API** — `api/server.js`: health, auth (JWT in-memory), profile, content/version.

```bash
cd expansion_server
npm install
cp .env.example .env
npm start
```

Load-check: `node -e "require('./api/server'); console.log('ok')"` — сервер слушает порт; для CI достаточно `require('./api/routes/auth')`.

Клиент: `ContentSyncService` — заготовка проверки `/api/content/version`.

## Git

Push из корня: `..\scripts\push-monorepo.ps1`
