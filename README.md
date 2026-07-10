# Expansion

Портретная космическая RTS в духе [*Eufloria*](https://store.steampowered.com/app/41200/Eufloria/): захват баз, отправка флотов, рост на узлах и кампания **Classic** из **40 миссий**. Между боями — очки и постоянные мета-апгрейды; внутри боя — тактические улучшения за ресурсы.

Монорепозиторий платформы: Flutter-клиент, backend API и админка контента.

**Репозиторий:** [github.com/Nykolayr/expansion](https://github.com/Nykolayr/expansion)

---

## Состав монорепозитория

| Каталог | Статус | Назначение | Стек |
|---------|--------|------------|------|
| [`expansion_app/`](expansion_app/) | **В разработке** | Игра (iOS / Android) | Flutter 3.44+, Dart 3.12+ |
| [`expansion_server/`](expansion_server/) | Заготовка | REST API, аккаунты, синхронизация прогресса | Node.js (план) |
| [`expansion_admin/`](expansion_admin/) | Заготовка | Редактирование миссий, баланс, пользователи | TBD |
| [`docs/`](docs/) | Актуально | Хаб документации | Markdown |
| [`.cursor/rules/`](.cursor/rules/) | Актуально | Правила для Cursor-агента | — |
| [`scripts/`](scripts/) | Актуально | Push монорепо | PowerShell |

**Workspace для разработки:** открывай [`expansion.code-workspace`](expansion.code-workspace) или корень репозитория — не отдельную подпапку, иначе не подхватятся корневые правила Cursor.

---

## Архитектура платформы

```
┌─────────────────┐     ┌──────────────────┐
│  expansion_app  │     │ expansion_admin  │
│  Flutter        │     │  (план)          │
│  iOS / Android  │     │  CRUD контента   │
└────────┬────────┘     └────────┬─────────┘
         │      HTTPS (позже)     │  JWT admin
         └──────────┬─────────────┘
                    ▼
         ┌─────────────────────┐
         │  expansion_server   │
         │  Node REST API      │
         └──────────┬──────────┘
                    │ БД
                    ▼
           прогресс / контент миссий
```

**Сейчас:** клиент работает **офлайн** — `SharedPreferences` (гость), SQLite-кэш контента, bundled `assets/scenes/`. Сеть подключается поэтапно после появления API.

**Позже:** админка → API → синхронизация на устройство; аккаунт с JWT и облачным прогрессом.

---

## Игра (Classic v1)

| Аспект | Решение |
|--------|---------|
| Кампания | 40 миссий на карте-кампании |
| Поле боя | Сетка **5×8**, real-time (~50 FPS в isolate) |
| Цикл | Splash → новая игра → бой 1 (туториал) → после первой победы карта → бой → апгрейды |
| Гость | Можно играть без регистрации; прогресс в prefs |
| Сложность | Easy / Average / Difficult — темп AI |
| Локализация | ru / en (`flutter gen-l10n`) |

### Что уже есть в клиенте

- Splash, настройки (язык), выбор сложности, экран «Новая игра»
- **Бой:** engine, AI противника, тактические апгрейды, спрайты баз/флотов/астероидов
- **Карта кампании** (40 миссий), мета-апгрейды, экран прогресса
- SQLite + сиды сцен из `assets/scenes/`, guest-профиль
- Clean Architecture, BLoC/Cubit, GetIt, go_router

### В планах

- Аккаунт и синхронизация через API
- Звук, справка, донат, профиль
- Backend и админка контента

Канон механик: [`expansion_app/docs/game-concept.md`](expansion_app/docs/game-concept.md).

---

## Стек клиента

Жёстко зафиксирован (шаблон [digitalsquare](https://github.com/Nykolayr/digitalsquare) — при необходимости локально `D:\Projects\_my_template\digitalsquare`):

| Слой | Технология |
|------|------------|
| Архитектура | Clean Architecture (`data` / `domain` / `presentation`) |
| State | `flutter_bloc` (Cubit/BLoC) |
| DI | GetIt (`sl`) |
| Роутинг | `go_router` |
| HTTP | Dio (когда подключим API) |
| Локальное хранилище | SharedPreferences, SQLite, SecureStorage (токены) |
| **Не используем** | GetX |

- **Application ID:** `com.ryjovs.expansion`
- **Версия:** `1.0.0+1`
- **UI:** портрет, immersive, тёмная тема `AppTheme.game()`

---

## Быстрый старт

### Требования

- Flutter SDK **3.44+** / Dart **3.12+**
- Android Studio / Xcode — для эмуляторов и устройств
- Расширение [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code) в Cursor / VS Code

### Клонирование

```powershell
git clone https://github.com/Nykolayr/expansion.git
cd expansion
```

Открой **`expansion.code-workspace`** в Cursor.

### Запуск клиента

**Из IDE:** Run and Debug → `Expansion (debug)` → **F5** (с отладчиком) или **Ctrl+F5** (без отладчика).

Конфигурация: [`expansion_app/.vscode/launch.json`](expansion_app/.vscode/launch.json) (в репозитории — F5 / Ctrl+F5 из коробки).

**Из терминала:**

```powershell
cd expansion_app
flutter pub get
flutter gen-l10n
flutter run
```

### Проверка перед коммитом

```powershell
cd expansion_app
flutter gen-l10n
flutter analyze
```

CI на GitHub Actions запускает те же шаги при push в `master` / `main`.

### Сервер и админка

Пока заготовки — см. [`expansion_server/README.md`](expansion_server/README.md) и [`expansion_admin/README.md`](expansion_admin/README.md).

---

## Документация

| Документ | Содержание |
|----------|------------|
| [`AGENTS.md`](AGENTS.md) | Контекст для Cursor-агента (весь workspace) |
| [`docs/GAME.md`](docs/GAME.md) | Хаб игровой концепции |
| [`docs/API.md`](docs/API.md) | Хаб REST API |
| [`expansion_app/docs/game-concept.md`](expansion_app/docs/game-concept.md) | **Канон механик v1** |
| [`expansion_app/docs/game-plan.md`](expansion_app/docs/game-plan.md) | Поэтапный план разработки |
| [`expansion_app/docs/project-specs.md`](expansion_app/docs/project-specs.md) | Экраны, стек, API-план |
| [`expansion_server/API_DOCS.md`](expansion_server/API_DOCS.md) | Черновик REST-контракта |
| [`expansion_server/CURRENT_STAGE.md`](expansion_server/CURRENT_STAGE.md) | Статус backend |

---

## Git и CI

Один Git-репозиторий в корне. Remote:

```text
https://github.com/Nykolayr/expansion.git
```

Push из корня (PowerShell):

```powershell
.\scripts\push-monorepo.ps1 -Message "Краткое описание на русском"
```

**CI:** [`.github/workflows/flutter_analyze.yml`](.github/workflows/flutter_analyze.yml) — `flutter pub get`, `gen-l10n`, `analyze` для `expansion_app`.

---

## Секреты и релиз

**Не коммитятся:**

- `.env`, `key.properties`, `*.jks`, upload-keystore
- `expansion_app/android/local.properties`

Release Android: один upload-keystore для Google Play и RuStore. Чеклисты — `expansion_app/.cursor/android_release.md`, `rustore_aab_signature.md`.

---

## Legacy

Старый клиент и apiserver — локальный референс механик и ассетов (`expansion_old`). Код и архитектуру **не копируем слепо** — новая база на digitalsquare.

---

## Лицензия

См. [`expansion_app/LICENSE`](expansion_app/LICENSE).
