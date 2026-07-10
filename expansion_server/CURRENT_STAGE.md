# Текущее состояние expansion_server

## Описание

Backend для игры **Expansion**: аккаунты, синхронизация прогресса, доставка контента миссий в клиент и админку.

## Текущая стадия

**Заготовка монорепо** — код API ещё не инициализирован.

### Что есть

1. ✅ Структура в монорепо `D:\Projects\expansion\expansion_server\`
2. ✅ Черновик контракта: `API_DOCS.md`
3. ✅ Правила Cursor: `.cursor/rules/`
4. ✅ Legacy-референс: `D:\Projects\expansion_old\apiserver`

### Следующие шаги

1. `package.json`, `app.js`, `api/routes/`
2. `.env.example` (DB, JWT)
3. Миграции `database/migrations/`
4. Реализовать маршруты по `API_DOCS.md`
5. Подключить клиент (`expansion_app`) поэтапно

## Связь

- Клиент: [`../expansion_app/`](../expansion_app/)
- Админка: [`../expansion_admin/`](../expansion_admin/)
- Концепция: [`../.cursor/rules/project-concept.mdc`](../.cursor/rules/project-concept.mdc)
