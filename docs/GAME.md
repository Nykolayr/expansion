# Expansion — хаб игровой документации

## Workspace

Корень: **`D:\Projects\expansion`**. Правила Cursor: **`.cursor/rules/project-concept.mdc`**, **`AGENTS.md`**.

## Канон механик

| Документ | Содержание |
|----------|------------|
| **[`expansion_app/docs/game-concept.md`](../expansion_app/docs/game-concept.md)** | Утверждённая концепция v1: Classic 40 миссий, бой 5×8, прогресс, гость |
| **[`ROADMAP.md`](ROADMAP.md)** | **Текущий план: сервер → арты → кампания** |
| [`expansion_app/docs/game-plan.md`](../expansion_app/docs/game-plan.md) | Исторические фазы разработки клиента |
| [`expansion_app/docs/campaign-missions-1-15.md`](../expansion_app/docs/campaign-missions-1-15.md) | Дизайн миссий 1–15 (м6+ — пункт 3 roadmap) |
| **[`campaign-content-ota.md`](campaign-content-ota.md)** | **OTA: новые миссии только через сервер** |
| [`expansion_app/docs/project-specs.md`](../expansion_app/docs/project-specs.md) | Экраны, стек, API-план |

## Клиент

- Пакет: **`expansion_app/`**
- ID: `com.ryjovs.expansion`
- Архитектура: digitalsquare (BLoC, GetIt, go_router)
- Правила: **`expansion_app/.cursor/rules/`**

## Legacy

`D:\Projects\expansion_old\expansion` — референс UI/механик, не канон кода.

## API и контент

Исходники JSON: **`expansion_app/assets/scenes/`**.  
**Prod:** OTA через **`GET /api/content/pack`** → SQLite на устройстве. Канон: **[`campaign-content-ota.md`](campaign-content-ota.md)**. REST: [`API.md`](API.md).
