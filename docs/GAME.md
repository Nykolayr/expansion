# Expansion — хаб игровой документации

## Workspace

Корень: **`D:\Projects\expansion`**. Правила Cursor: **`.cursor/rules/project-concept.mdc`**, **`AGENTS.md`**.

## Канон механик

| Документ | Содержание |
|----------|------------|
| **[`expansion_app/docs/game-concept.md`](../expansion_app/docs/game-concept.md)** | Утверждённая концепция v1: Classic 40 миссий, бой 5×8, прогресс, гость |
| [`expansion_app/docs/game-plan.md`](../expansion_app/docs/game-plan.md) | План фаз разработки |
| [`expansion_app/docs/project-specs.md`](../expansion_app/docs/project-specs.md) | Экраны, стек, API-план |

## Клиент

- Пакет: **`expansion_app/`**
- ID: `com.ryjovs.expansion`
- Архитектура: digitalsquare (BLoC, GetIt, go_router)
- Правила: **`expansion_app/.cursor/rules/`**

## Legacy

`D:\Projects\expansion_old\expansion` — референс UI/механик, не канон кода.

## API и контент

Контент миссий сейчас в **`expansion_app/assets/scenes/`**. В перспективе: админка → API → SQLite на устройстве. См. [`API.md`](API.md).
