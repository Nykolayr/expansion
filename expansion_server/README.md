# expansion_server

Backend API для игры **Expansion**.

## Документация

| Файл | Назначение |
|------|------------|
| [`API_DOCS.md`](API_DOCS.md) | Канон REST |
| [`../docs/auth-account-spec.md`](../docs/auth-account-spec.md) | Spec аккаунта и рейтинга |
| [`../docs/API.md`](../docs/API.md) | Хаб API |

## Статус

**v0.2** — MariaDB, email+password auth, verify email, profile sync, leaderboard, delete account.

## Prod (redmobi VPS + danilagames.ru)

См. **[`deploy/VPS.md`](deploy/VPS.md)** — канон деплоя.

| Компонент | URL |
|-----------|-----|
| Заглушка сайта | https://danilagames.ru/ |
| API (пока IP) | http://46.173.25.193/api/health |
| API (после DNS) | https://expansion-api.danilagames.ru/api |

```bash
npm run load-check
.\deploy\sync-vps.ps1
```

## Git

Push из корня: `..\scripts\push-monorepo.ps1`
