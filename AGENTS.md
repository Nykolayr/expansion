# Expansion — платформа (один агент Cursor)

## Как открыть проект

**`expansion.code-workspace`** в корне `D:\Projects\expansion` — или сама папка `expansion`.

Не открывать только `expansion_app` / `expansion_server` — иначе не подхватятся корневые правила.

## Один агент

Пользователь общается с **одним агентом** на app + server + admin + docs.  
Subagent/Task — на усмотрение исполнителя.

## Корневые правила (alwaysApply)

| Файл | Назначение |
|------|------------|
| `expansion-platform-workspace.mdc` | Структура workspace, порядок end-to-end |
| `feature-delivery-workflow.mdc` | План → утверждение → код |
| `agent-invariants-never-break.mdc` | commit/push/релиз только по просьбе |
| `agent-does-setup-never-user-chores.mdc` | Агент сам: analyze, setup |
| `mandatory-verify-after-code-changes.mdc` | analyze перед «готово» |
| `project-concept.mdc` | Клиент ↔ сервер ↔ админка |
| `monorepo-scope.mdc` | Границы по задаче |

## Пакетные правила

| Пакет | Каталог |
|-------|---------|
| Клиент | `expansion_app/.cursor/rules/` |
| Сервер | `expansion_server/.cursor/rules/` |
| Админка | `expansion_admin/.cursor/rules/` |

Фокус по globs: `agent-app.mdc`, `agent-server.mdc`, `agent-admin.mdc`.

## Канон документации

| Документ | Когда читать |
|----------|--------------|
| `docs/GAME.md` | Хаб игровой концепции |
| `expansion_app/docs/game-concept.md` | Канон механик v1 |
| `docs/API.md` | Хаб API |
| `expansion_server/API_DOCS.md` | Полный REST (когда backend готов) |

## Git

**Один монорепозиторий** в корне `D:\Projects\expansion`. Commit/push — только по просьбе, **из корня** (`scripts/push-monorepo.ps1`).

**GitHub:** [github.com/Nykolayr/expansion](https://github.com/Nykolayr/expansion)

## Шаблон Flutter

`D:\Projects\_my_template\digitalsquare` — канон DI/BLoC/логов. Жёсткие соглашения правь в шаблоне, продуктовые — в `expansion_app/`.

## Релиз клиента

- ID: `com.ryjovs.expansion`
- Чеклисты: `expansion_app/.cursor/android_release.md`, `rustore_aab_signature.md`
