# Контекст для агента — `expansion_app`

> **Главный файл workspace:** [`../AGENTS.md`](../AGENTS.md)  
> Открывать **`../expansion.code-workspace`** или корень `D:\Projects\expansion`.

## Пакет

Flutter-клиент **Expansion** (iOS, Android).

## Стек (жёстко)

- Clean Architecture + **flutter_bloc** + **GetIt** + **go_router** + **Dio**
- **GetX не использовать**
- Правила: **`.cursor/rules/`** (полный список — `.cursor/README.md`)

## Продукт

| Документ | Назначение |
|----------|------------|
| `docs/game-concept.md` | Канон механик v1 |
| `docs/project-specs.md` | Экраны, API-план |
| `../docs/GAME.md` | Хаб |

## Идентификация

- `com.ryjovs.expansion`
- `AppTheme.game()`, портрет, immersive

## Команды

```powershell
cd expansion_app
flutter pub get
flutter gen-l10n
flutter analyze
```

## Git / push

Из **корня** монорепо: `..\scripts\push-monorepo.ps1` — только по просьбе.

## Шаблон

`D:\Projects\_my_template\digitalsquare` — канон жёсткого стека.
