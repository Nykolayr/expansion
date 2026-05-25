# Обновление Flutter / Dart (для всех проектов из шаблона)

Ориентир: **Flutter 3.44+**, **Dart 3.12+** ([release notes](https://docs.flutter.dev/release/release-notes), [breaking changes](https://docs.flutter.dev/release/breaking-changes)).

## Перед обновлением

```powershell
flutter --version
flutter upgrade
dart --version
```

В `pubspec.yaml` проекта:

```yaml
environment:
  sdk: ^3.12.0
```

## Чеклист после `flutter upgrade`

- [ ] `flutter pub get`
- [ ] `dart analyze` (или `flutter analyze`)
- [ ] `flutter test` — если есть тесты
- [ ] Релизная сборка Android: `flutter build appbundle --release`
- [ ] iOS на Mac: `pod install` в `ios/`, сборка/archive

## Dart 3.12 — что можно применять в коде

- **Приватные named-параметры**: `Point({required this._x, required this._y})` вместо дублирования в initializer list.
- **Линты**: включить/обновить `simple_directive_paths`, `prefer_initializing_formals` в `analysis_options.yaml`.
- **`dart fix --apply`** после крупного апгрейда SDK.

## Flutter 3.44 — инфраструктура

| Область | Действие |
|--------|----------|
| Android WebView / platform views | Опционально **HCPP**: `--enable-hcpp` или `EnableHcpp` в манифесте ([док](https://docs.flutter.dev/platform-integration/android/platform-views)) |
| Android Gradle | При AGP 9 убрать ручной `kotlin-android` plugin — [миграция](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin/for-app-developers) |
| iOS | Swift Package Manager по умолчанию — следовать breaking changes 3.44 |
| Edge-to-edge | См. `.cursor/edge_to_edge_play_checklist.md` |
| DevTools | WASM по умолчанию — быстрее на больших проектах |
| Cursor + агент | [MCP / Agentic Hot Reload](https://docs.flutter.dev/ai/mcp-server), [Agent Skills](https://blog.flutter.dev/introducing-skills-for-dart-and-flutter-23837c6ec0ae) |

## Не обязательно для каждого проекта

- GenUI / Firebase AI / Genkit — только при AI-фичах.
- Multi-window desktop — preview.

## После копирования шаблона

См. также `docs/template_checklist.md` и `@.cursor/README.md`.
