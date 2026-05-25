# Cursor Rules — Flutter шаблон

**Канонический путь к этому шаблону на диске:** `D:\Projects\_my_template\digitalsquare` — **источник** для копий новых приложений; правки жёстких соглашений веди здесь.

Файлы в `.cursor/rules/` подхватываются Cursor для этого репозитория.

## Зафиксированный стек
**Clean Architecture (классические слои)** + **flutter_bloc** + **GetIt** + **go_router** + **Dio**. Другие стеки в этих правилах не рассматриваются.

## Правила
| Файл | Описание |
|------|----------|
| `architecture.mdc` | Слои `data` / `domain` / `presentation`, репозитории, use cases |
| `flutter-best-practices.mdc` | Стиль, импорты, без кодогена; версии — из `pubspec.yaml` |
| `presentation-widgets.mdc` | Виджеты в отдельных файлах, реестр `lib/presentation/widgets/WIDGET_INVENTORY.md` |
| `ui-feedback.mdc` | SnackBar только через `AppFeedbackService` + `AppFeedbackKind` |
| `i18n-multi-locale.mdc` | Все ARB для поддерживаемых локалей, `flutter gen-l10n` |
| `bloc-state-management.mdc` | Только BLoC/Cubit + `sl`, **без** `BlocProvider` / без ChangeNotifier в фичах |
| `dependency-injection.mdc` | GetIt (`sl`), всё в `initDependencies`, **без** GetX |
| `agent-workflow.mdc` | Агент **может** запускать `flutter analyze` и т.д. в терминале |
| `feature-trace-logs.mdc` | `AppLog.trace` с `tag` на новой фиче, **удалить** после «ок» |
| `pitfalls-and-regression-guards.mdc` | **Не повторять** типовые баги: async/сессия/роутер, `Stack`+`shrink`, `PageView`+`ListView`, `BlocBuilder`+таб |
| `routing.mdc` | GoRouter |
| `api-client.mdc` | Dio, ошибки, data sources |
| `logging.mdc` | `AppLog`, easylogger, что логировать |
| `flutter-sdk-release.mdc` | SDK, AAB/APK, RuStore, edge-to-edge — ссылки на `.cursor/*.md` |

## Чеклисты релиза и SDK (`.cursor/`)

| Файл | Описание |
|------|----------|
| `flutter_upgrade_checklist.md` | `flutter upgrade`, Dart 3.12 / Flutter 3.44 |
| `android_release.md` | Сборка AAB/APK, копирование в `D:\Temp`, подпись |
| `rustore_aab_signature.md` | PEPK + PEM для RuStore (тот же keystore, что Play) |
| `edge_to_edge_play_checklist.md` | Google Play: system bars |

## Использование как шаблона
1. Скопируй проект целиком (в т.ч. `lib/`, `android/`, `ios/`, `.cursor/`).
2. Пройди [чеклист после копирования](../docs/template_checklist.md) (`docs/template_checklist.md`).
3. В **`pubspec.yaml`** задай **`name:`** — имя пакета для импортов `package:<name>/...`; при смене имени сделай поиск по старому имени в `lib/`.
4. В `lib/` уже разложен **каркас папок** под классические слои (`.gitkeep`, чтобы Git не терял пустые каталоги). Код добавляй по мере фич — см. `architecture.mdc`.
5. Опционально: `docs/project-specs.md` и в чате `@docs/project-specs.md`.

## Версии зависимостей
Версии пакетов фиксируй **только в `pubspec.yaml`**. Правила и README не должны дублировать номера версий, чтобы не устаревать.

## Горячие клавиши Cursor
| Действие | macOS | Windows / Linux |
|----------|--------|-----------------|
| Чат | `Cmd+L` | `Ctrl+L` |
| Редактировать выделение | `Cmd+K` | `Ctrl+K` |
| Composer / агент | `Cmd+I` | `Ctrl+I` |

## Ссылки в чате (`@`)
- `@AGENTS.md` — краткий контекст стека и ссылки на правила (удобно агенту)
- `@.cursor/rules/` — все правила проекта
- `@codebase` — поиск по коду
- `@docs/template_checklist.md` — чеклист после копирования шаблона
- `@.cursor/flutter_upgrade_checklist.md` — обновление Flutter/Dart
- `@.cursor/android_release.md` — релизная сборка Android
- `@docs/project-specs.md` — черновик спецификации продукта (заполни под проект)

Файл **`.cursorignore`** (в корне) ограничивает индексацию `build/`, `.dart_tool/` и т.п.

## Рабочий процесс фичи
1. **План** (чат): учесть rules и спеки, наметить файлы и слои.
2. **Реализация** (Composer): правки по плану и `.cursor/rules/`.
3. **Проверка**: `flutter analyze` (и тесты по желанию).
