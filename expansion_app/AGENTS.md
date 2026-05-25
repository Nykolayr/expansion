# Контекст для агента — Expansion (монорепо)

## Структура репозитория

- **`expansion_app/`** — Flutter-клиент (iOS, Android), работай здесь по умолчанию.
- **`expansion_server/`** — backend API (пока заготовка).
- **`expansion_admin/`** — админ-панель (пока заготовка).

Канонический шаблон архитектуры: `D:\Projects\_my_template\digitalsquare` — общие правила DI/BLoC/логов правь **в шаблоне**, продуктовые — здесь.

## Стек клиента (жёстко)

- **Clean Architecture** + **`flutter_bloc`** + **GetIt (`sl`)** + **go_router** + **Dio**
- **GetX не использовать**
- Спеки продукта: `docs/project-specs.md` (`@docs/project-specs.md`)

## Игра

- `applicationId` / bundle: **`com.ryjovs.expansion`**
- Тема: `AppTheme.game()`, палитра `ExpansionColors`
- Портрет + `SystemUiMode.immersiveSticky`

## Правила Cursor

См. `expansion_app/.cursor/rules/` и `.cursor/README.md`.

## SDK и релизы

- Flutter 3.44 / Dart 3.12 — `expansion_app/.cursor/flutter_upgrade_checklist.md`
- Android/iOS релиз — чеклисты в `expansion_app/.cursor/`

## Команды (из корня монорепо)

```bash
cd expansion_app && flutter pub get && flutter gen-l10n && flutter analyze
```

## При сомнении

Приоритет правил **этого репозитория** над глобальными user rules в Cursor.
