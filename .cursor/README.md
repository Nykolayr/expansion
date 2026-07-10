# Cursor — корень Expansion

Правила в `.cursor/rules/` подхватываются при открытии **`expansion.code-workspace`** или `D:\Projects\expansion`.

## AlwaysApply (платформа)

| Файл | Назначение |
|------|------------|
| `expansion-platform-workspace.mdc` | Папки, git, порядок фич |
| `monorepo-scope.mdc` | Один агент, границы |
| `project-concept.mdc` | Клиент ↔ сервер ↔ админка |
| `feature-delivery-workflow.mdc` | План → утверждение → код |
| `agent-invariants-never-break.mdc` | commit/push/релиз |
| `agent-does-setup-never-user-chores.mdc` | Агент сам запускает команды |
| `mandatory-verify-after-code-changes.mdc` | analyze перед «готово» |

## По пакетам (globs)

| Файл | Пакет |
|------|-------|
| `agent-app.mdc` | `expansion_app/**` |
| `agent-server.mdc` | `expansion_server/**` |
| `agent-admin.mdc` | `expansion_admin/**` |

## Пакетные rules

- `expansion_app/.cursor/rules/` — Flutter, BLoC, релиз
- `expansion_server/.cursor/rules/` — API
- `expansion_admin/.cursor/rules/` — админка

## Документация

- `AGENTS.md` — краткий индекс
- `docs/GAME.md`, `docs/API.md` — хабы
- `expansion_app/docs/game-concept.md` — канон игры
