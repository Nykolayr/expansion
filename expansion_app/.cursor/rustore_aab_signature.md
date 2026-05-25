# RuStore: подпись для AAB (тот же ключ, что Google Play)

Документация: [загрузка AAB](https://www.rustore.ru/help/developers/publishing-and-verifying-apps/app-publication/new-version-app/upload-aab).

## Файлы проекта

| Файл | Назначение |
|------|------------|
| `android/app/upload-keystore.jks` | Keystore |
| `android/key.properties` | Пароли и alias (не в git) |
| `cert.pem` | PEM ключа загрузки (хранить вне репо, путь команды) |

## Консоль RuStore

1. [console.rustore.ru](https://console.rustore.ru) → **Приложения** → приложение → **Загрузить версию**
2. **Подпись для загрузки AAB** → **Загрузить** (если нет «Подпись загружена»)
3. Окно **Загрузка подписи приложения**

## PEPK (ZIP)

1. Скачать **pepk.jar** из окна RuStore.
2. Скопировать команду с **encryptionkey** из консоли (не менять ключ).
3. Java **11+** (JDK 17 из Flutter):

```powershell
cd <корень>\android
& "C:\Program Files\Java\jdk-17\bin\java.exe" -jar pepk.jar `
  --keystore="<путь>\android\app\upload-keystore.jks" `
  --alias=<alias_из_key.properties> `
  --output="<путь>\pepk_out.zip" `
  --encryptionkey=<КЛЮЧ_ИЗ_КОНСОLI_RUSTORE> `
  --include-cert `
  --keystore-pass=<storePassword> `
  --key-pass=<keyPassword>
```

**Не добавлять** `--rsa-aes-ephemeral`, если уже есть `--encryptionkey=...`.

## PEM

```powershell
keytool -exportcert -alias <alias> -keystore android\app\upload-keystore.jks -storepass <pass> -rfc -file cert.pem
```

Загрузить в RuStore: **pepk_out.zip** + **cert.pem** → **Отправить подпись**.

## Сборка AAB/APK после подписи

Тем же keystore (`flutter build appbundle --release` / `apk --release`).

## Package name

При **создании** приложения в RuStore указать тот же package, что `applicationId` в `build.gradle.kts`.

Смена `applicationId` в коде без новой карточки RuStore → «Пакет не соответствует предыдущей версии».

Смена keystore без поддержки RuStore → [support@rustore.ru](mailto:support@rustore.ru).
