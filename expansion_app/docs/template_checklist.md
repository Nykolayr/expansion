# Чеклист после копирования шаблона

Отметь пункты по мере выполнения.

## Минимум (новый репозиторий / новое приложение)

- [ ] **`pubspec.yaml`**: задать `name:` (имя пакета для импортов `package:<name>/...`).
- [ ] **`pubspec.yaml`**: при необходимости обновить `description`, `version`.
- [ ] **`lib/`**: поиск по проекту по **старому** имени пакета и замена импортов на новое (если клонировали из другого имени).
- [ ] **`docs/project-specs.md`**: заполнить под продукт (удобно для Cursor: `@docs/project-specs.md`).
- [ ] **`AGENTS.md`**: при необходимости дополнить доменными правилами команды.
- [ ] **SDK**: в `pubspec.yaml` — `environment: sdk: ^3.12.0` (при `flutter upgrade` см. `.cursor/flutter_upgrade_checklist.md`).
- [ ] **Запуск**: `flutter pub get`
- [ ] **Анализ**: `flutter analyze`
- [ ] **GitHub**: при первом push проверь вкладку **Actions** — workflow `flutter analyze` должен отработать (при необходимости включи Actions в настройках репо).
- [ ] После правок **`lib/l10n/*.arb`**: `flutter gen-l10n` и коммит обновлённых `lib/l10n/app_localizations*.dart`.
- [ ] **`LICENSE`**: при необходимости обнови год и copyright.

Уже есть в шаблоне: **`main` → `bootstrapLogger` → `initDependencies` → `MaterialApp.router`** (`debugShowCheckedModeBanner: false`), **`AppFeedbackService`** + **`appScaffoldMessengerKey`**, тема **`AppTheme`**, **l10n (ru/en)**, **`SecureStorageService`**, `app_router`, **`HomePage`**, реестр **`lib/presentation/widgets/WIDGET_INVENTORY.md`**, зависимости стека в `pubspec.yaml`, **MIT**.

## Идентификация приложения в сторах (по желанию сразу)

- [ ] **Android**: `applicationId` / namespace в `android/app/build.gradle.kts` (или `build.gradle`). **Не менять** после первой загрузки в RuStore/Play без плана.
- [ ] **Android**: `'android:label'` в манифесте при необходимости.
- [ ] **Android release-подпись**: `key.properties.example` → `key.properties`, `upload-keystore.jks` в `android/app/` (см. `.cursor/android_release.md`).
- [ ] **iOS**: `CFBundleName` / `CFBundleDisplayName` в `ios/Runner/Info.plist`.
- [ ] **Иконка / splash** — когда понадобятся.

## Перед публикацией в стор

- [ ] `.cursor/android_release.md` — AAB/APK и `D:\Temp`
- [ ] RuStore AAB: `.cursor/rustore_aab_signature.md`
- [ ] Google Play edge-to-edge: `.cursor/edge_to_edge_play_checklist.md`

## Каркас по правилам проекта

Каталоги под слои в `lib/` (`.gitkeep` там, где ещё нет кода). Уже подключены: **`main` → `initDependencies`**, **`app_router.dart`**, **`HomePage`**.

Дальше по мере разработки:

- [ ] **`injection_container.dart`** — добавляй data sources, репозитории, use cases, BLoC (см. `dependency-injection.mdc`).
- [x] **`dio_client.dart`**, **`error/*`**, **`api_config.dart`** — уже в шаблоне; при смене API правь `ApiConfig` / `--dart-define`.
- [ ] **`app_router.dart`** — новые `GoRoute` / `ShellRoute` (см. `routing.mdc`); навигация в UI через `context.go…` / расширение `navigation_context.dart`.

## Опционально

- [ ] Файл спеков, например `docs/project-specs.md`, и ссылки в чате Cursor через `@docs/project-specs.md`.
- [ ] `.env` / flavors для dev/prod — не коммить секреты.
