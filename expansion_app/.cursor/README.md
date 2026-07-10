# Cursor Rules — expansion_app

**Workspace:** `D:\Projects\expansion` — открывать **`expansion.code-workspace`**, не только эту папку.

Корневые правила платформы: **`../.cursor/rules/`**, **`../AGENTS.md`**.

## Зафиксированный стек

**Clean Architecture** + **flutter_bloc** + **GetIt** + **go_router** + **Dio**. Канон шаблона: `D:\Projects\_my_template\digitalsquare`.

## Правила этого пакета

| Файл | Описание |
|------|----------|
| `monorepo-project-concept.mdc` | Ссылка на концепцию workspace |
| `git-push-monorepo.mdc` | Push из корня монорепо |
| `architecture.mdc` | Слои data / domain / presentation |
| `flutter-best-practices.mdc` | Стиль, импорты, без кодогена |
| `presentation-widgets.mdc` | Виджеты, `WIDGET_INVENTORY.md` |
| `ui-feedback.mdc` | `AppFeedbackService` |
| `i18n-multi-locale.mdc` | ARB, `flutter gen-l10n` |
| `bloc-state-management.mdc` | BLoC/Cubit + `sl`, без GetX |
| `dependency-injection.mdc` | GetIt, `initDependencies` |
| `agent-workflow.mdc` | Агент запускает analyze |
| `feature-trace-logs.mdc` | `AppLog.trace`, потом удалить |
| `pitfalls-and-regression-guards.mdc` | Типовые баги |
| `routing.mdc` | GoRouter |
| `api-client.mdc` | Dio, ошибки |
| `logging.mdc` | `AppLog` |
| `flutter-sdk-release.mdc` | SDK, релизы |

## Чеклисты (`.cursor/`)

| Файл | Описание |
|------|----------|
| `flutter_upgrade_checklist.md` | Flutter 3.44 / Dart 3.12 |
| `android_release.md` | AAB/APK, `D:\Temp` |
| `rustore_aab_signature.md` | RuStore PEPK |
| `edge_to_edge_play_checklist.md` | System bars |

## Документация игры

- `docs/game-concept.md` — канон механик
- `../docs/GAME.md` — хаб
- `.cursor/API_DOCUMENTATION.md` — ссылки API

## Ссылки в чате (`@`)

- `@../AGENTS.md` — контекст всего монорепо
- `@docs/game-concept.md` — механики
- `@.cursor/rules/` — правила пакета
- `@../.cursor/rules/project-concept.mdc` — концепция платформы

## Рабочий процесс

См. корневой **`feature-delivery-workflow.mdc`**: план → утверждение → код → `flutter analyze`.
