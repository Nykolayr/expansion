# expansion_app

Flutter-клиент **Expansion** (iOS, Android).

**Workspace:** открывай [`../expansion.code-workspace`](../expansion.code-workspace) или корень `D:\Projects\expansion`.

- **ID:** `com.ryjovs.expansion`
- **Архитектура:** digitalsquare (BLoC, GetIt, go_router)

## Документация

| Файл | Назначение |
|------|------------|
| [`docs/game-concept.md`](docs/game-concept.md) | Канон механик |
| [`AGENTS.md`](AGENTS.md) | Контекст пакета |
| [`../AGENTS.md`](../AGENTS.md) | Контекст всего монорепо |
| [`.cursor/README.md`](.cursor/README.md) | Правила Cursor |

## Команды

```powershell
flutter pub get
flutter gen-l10n
flutter analyze
flutter run
```

## Git

```powershell
cd D:\Projects\expansion
.\scripts\push-monorepo.ps1 -Message "описание"
```

## Подпись release

`android/key.properties.example`, `.cursor/android_release.md` — тот же upload-keystore, что Play/RuStore.

