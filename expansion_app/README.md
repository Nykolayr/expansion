# expansion_app

Flutter-клиент **Expansion** (iOS, Android).

- **ID:** `com.ryjovs.expansion`
- **Версия:** `1.0.0+1`
- **Архитектура:** Clean Architecture, BLoC, GetIt, go_router (из шаблона digitalsquare)

## Команды

```bash
flutter pub get
flutter gen-l10n
flutter analyze
flutter run
```

## Документация

- [`docs/project-specs.md`](docs/project-specs.md) — механики и экраны
- [`docs/template_checklist.md`](docs/template_checklist.md) — чеклист после копирования шаблона
- [`AGENTS.md`](AGENTS.md) — контекст для Cursor

## Подпись release

См. `android/key.properties.example` и `.cursor/android_release.md`. Используй **тот же** upload-keystore, что и для предыдущих релизов Expansion.
