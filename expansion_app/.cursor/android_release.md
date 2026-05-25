# Сборка Android (AAB/APK) для стора

Подставьте **slug приложения** (короткое имя, латиница): например `myapp` из `pubspec.yaml` → `name: myapp`.

## Имя файла в D:\Temp

`{slug}_1_{buildNumber}.aab` или `.apk`

- `buildNumber` — число после `+` в `pubspec.yaml` (`1.0.10+10` → `10`)
- `1` — мажорная часть версии (опционально, для единообразия в команде)

Пример: `myapp_1_10.aab`

## Подпись release (настроить один раз на проект)

1. Сгенерировать keystore (или использовать существующий).
2. Положить `upload-keystore.jks` в `android/app/`.
3. Скопировать `android/key.properties.example` → `android/key.properties` (в git не коммитить).
4. В `android/app/build.gradle.kts` — блок `signingConfigs` (уже в шаблоне после настройки).

Проверка SHA-256:

```powershell
keytool -list -v -keystore android\app\upload-keystore.jks -storepass YOUR_STORE_PASS -alias YOUR_ALIAS | findstr SHA256
```

**Один keystore** для Google Play и RuStore. Отдельный ключ только для RuStore ломает обновления в Play.

## Сборка и копирование (PowerShell)

```powershell
cd <корень_проекта>
$slug = "myapp"      # pubspec name
$build = 10          # из version: x.y.z+10

flutter build appbundle --release
New-Item -ItemType Directory -Force -Path "D:\Temp" | Out-Null
Copy-Item -Force "build\app\outputs\bundle\release\app-release.aab" "D:\Temp\${slug}_1_${build}.aab"
Get-Item "D:\Temp\${slug}_1_${build}.aab"
```

APK (RuStore / тест):

```powershell
flutter build apk --release
Copy-Item -Force "build\app\outputs\flutter-apk\app-release.apk" "D:\Temp\${slug}_1_${build}.apk"
```

## Перед загрузкой в стор

- [ ] `version` / `versionCode` выше предыдущей в консоли
- [ ] `applicationId` в Gradle = package в карточке стора (см. pitfalls ниже)
- [ ] Release подписан **release** keystore, не debug
- [ ] Edge-to-edge: `.cursor/edge_to_edge_play_checklist.md`

## RuStore AAB — подпись в консоли

См. `.cursor/rustore_aab_signature.md` (PEPK + PEM, **тот же** keystore).

## Типичные ошибки

| Ошибка | Частая причина |
|--------|----------------|
| «Пакет не соответствует предыдущей версии» | Другой `applicationId`, не другой SHA (если ключ тот же) |
| Play: неверная подпись | Другой `.jks` или debug вместо release |

**Package name** после смены `applicationId` в коде нельзя «подменить» в той же карточке RuStore — нужна новая карточка с правильным package или поддержка RuStore.
