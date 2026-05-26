# План разработки Expansion (новый клиент)

Источник механик и недоделок: `D:\Projects\expansion_old\expansion` (+ API `expansion_old/apiserver`).  
Текущий клиент: `expansion_app/` на шаблоне digitalsquare (Clean Architecture, Cubit, GetIt, go_router).

---

## 1. Что за игра

**Космическая RTS в реальном времени** (портрет):

- Кампания v1: **40** миссий (`objects_1…40`); расширение до 101+ — позже. См. [`game-concept.md`](game-concept.md).
- Бой: сетка **5×8**, базы, корабли, астероиды, щиты, апгрейды, AI противника.
- Режимы вселенной: classic / generated / strategic (`Game.Univer`).
- Сложность: easy / average / difficult (скорость AI, тиков, кораблей).

Победа на карте → прогресс `mapClassic`, счёт, разблокировка следующих миссий.  
Поражение → повтор, подсказки, сброс улучшений (экран Update в legacy).

---

## 2. Доступ к legacy — да

| Ресурс | Путь | Заметки |
|--------|------|--------|
| Клиент | `expansion_old/expansion` | ~90 Dart-файлов, GetX + BLoC + freezed |
| Сцены | `assets/scenes/` | 101 миссия, JSON |
| Графика/звук | `assets/images/`, `svg/`, `audio/` | Не перенесены в новый app |
| API | `expansion_old/apiserver` | Express + MySQL, JWT, users/scenes/top |
| Монорепо (новое) | `expansion_server/`, `expansion_admin/` | Заготовки |

**Важно:** в legacy `GameRepository.init()` начинается с `return;` — загрузка сцен из API/кэша **отключена** (мертвый код ниже). Игра опиралась на локальные JSON и ручную инициализацию — это типичный признак «недоделано».

---

## 3. Экраны legacy → статус в новом app

| Экран | Маршрут legacy | Назначение | Новый app |
|-------|----------------|------------|-----------|
| Splash | `/` | Меню, вступление, загрузка | ✅ Сделано (улучшено) |
| Настройки | `/settings` | Звук, язык, сброс | ⚠️ Минимум (история, без звука/языка) |
| Карта кампании | `/maps` | 101 миссия, описание, «Экспансия» | ❌ |
| Новая игра | `/new_game` | Выбор сложности/вселенной | ❌ |
| Бой | `/battle` | Основной геймплей | ❌ |
| Продолжить | splash → maps/battle | По прогрессу пользователя | ❌ |
| Профиль | `/profile` | Аккаунт, регистрация | ❌ |
| Вход / регистрация | `/profile_login`, `profile_Register` | Сервер | ❌ |
| Прогресс | `/progress` | Статистика | ❌ |
| Обновление | `/update` | Контент с сервера, сброс апгрейдов | ❌ |
| Улучшения | меню splash | Апгрейды (часть Update) | ❌ |
| Донат | `/donate` | Поддержка | ❌ |
| Редактор сцен | `/scenarios` | Dev/контент | ❌ (низкий приоритет) |
| Помощь | `/help`, `/helpGame` | Справка по бою | ❌ |
| Логи | `/logs` | Talker (отладка) | ❌ (не для релиза) |

---

## 4. Ядро геймплея (переносить по слоям)

### 4.1 Domain (сущности, без freezed)

Из `domain/models/`:

- `Base`, `Ship`, `Asteroid` — координаты на сетке, щит, корабли, владелец.
- `AllUpgrade` / апгрейды наш/враг.
- `Scene` — id, имена RU/EN, описания, тип узла карты.
- `User` / `UserGame` — прогресс, `mapClassic`, счёт, флаги регистрации.
- `Game` — `Univer`, `Level`, `isSplash`, `isHint`.
- `EnemyIntellect` — тики хода AI.

### 4.2 Game core (isolate)

- `game_core/game_loop.dart` — ~50 FPS, `SendPort` → тики в `BattleBloc`.
- `game_core/min_time.dart` — ограничение частоты.
- Legacy: пакет `computer` + `Isolate` — в новом: **`Isolate.run` / отдельный isolate** + чёткий протокол сообщений (без GetX в isolate).

### 4.3 Battle (самый большой блок)

`BattleBloc`: Init, Tic, Send (отправка флота), ArriveShips, BattleShips, Asteroid, Win/Lost, Pause, AddScore.

UI: `battle_page`, спрайты (`animations_sprites`), модалки победы/поражения, HUD баз.

**Риск:** тяжёлый UI + много виджетов на клетках → в новом: `CustomPainter` / кэш, `RepaintBoundary` (см. `project-specs.md`).

### 4.4 Кампания (maps)

- Вертикальная карта, узлы по 5 в «змейке», скролл к текущей миссии.
- `objects_{n}.json` — расстановка баз для боя миссии `n`.
- Баг в legacy: в `maps_page` перепутаны `descriptionRu` / `descriptionEn` по локали — **исправить при переносе**.

### 4.5 Данные

| Слой | Хранилище | Содержимое |
|------|-----------|------------|
| Гость / UI | `SharedPreferences` | вступление splash, настройки (позже звук/язык) |
| Игровой контент | **SQLite** (`sqflite`, `expansion_game.db`) | сцены, объекты уровней, версия синка — **фаза 2+** |
| Сервер | Node + SQL (схема по мобильной БД) | админка → API → докачка в SQLite на клиенте |
| Секреты | `SecureStorage` | JWT (фаза 5) |

Прогресс игрока и модели domain — **фаза 2** (legacy только как ориентир). Сиды контента — из `assets/scenes/` в SQLite, не из кода.

---

## 5. Backend (позже, но заложить контракт)

Legacy API (`apiserver/routes.js`):

- `GET /expansion/load_all_scenes`, `get_scenes`
- `GET/POST` users, delete, **top** по типу счёта
- JWT (`jsonwebtoken`)

**Новый:** `expansion_server/` — переписать без секретов в коде; клиент уже имеет `DioClient`, `ApiConfig`, `ErrorHandler`.

На splash: **`AppBootstrapCubit`** — открытие пустой SQLite; позже + версия контента и API.

---

## 6. Фазы разработки (рекомендуемый порядок)

### Фаза 0 — Сделано ✅

- [x] Каркас app, тема, l10n, DI, роутер
- [x] Splash + вступление + галочка «не показывать снова»
- [x] Иконка, native splash, меню-кнопки (заглушки)
- [x] Настройки: повтор истории (`/intro-story`)

### Фаза 1 — Меню и навигация (1–2 нед.) ✅

- [x] Маршруты: `/maps`, `/begin`, `/battle`, `/profile`, `/progress`, `/settings`, `/intro-story`
- [x] Скелеты экранов + `GameScreenScaffold` / `GamePlaceholderSection`
- [x] Меню splash → реальные экраны (улучшения — заглушка snackbar)
- [x] `sqflite`: пустая БД `expansion_game.db` v1, `GameDatabase` в DI
- [x] `AppBootstrapCubit` на splash вместо фиксированных 2 с (bootstrap + полоса)
- [ ] Профиль гостя в prefs — **отложено** (модели на фазе 2)

### Фаза 2 — Данные и кампания (2–3 нед.) ✅

**Модели — новые с нуля** (см. `game-concept.md` §16; legacy не копируем):

- [x] Domain: `CampaignScene`, `BattleLayout`, `PlacedBase`, `GuestProfile`, enum’ы
- [x] SQLite v2: `campaign_scenes`, `battle_placements`, `content_meta`
- [x] Сид из `assets/scenes/` (40 миссий, змейка, `objects_1…40`)
- [x] Репозитории: контент SQLite, гость prefs
- [x] `MapsCubit` + карта 5×8 рядов, описание, «Экспансия» → `/battle?extra=sceneId`
- [ ] Новые сюжетные тексты вместо legacy JSON (§15) — по мере контента
- [ ] `assets/images/`, `audio/` — фаза 3 / отдельный перенос
- [ ] `/upgrades` скелет — фаза 4

### Фаза 3 — Бой MVP (3–5 нед.) — в работе

- [x] `BattleSnapshot`, `BattleBase`, `BattleEngine`
- [x] **`EnemyCommander`** + `BattleIntent` + `EnemyPersonality` (RNG)
- [x] `BattleCubit` + таймер тиков (isolate — позже)
- [x] `/begin` — сложность → бой миссии 1
- [x] Поле 5×8, тап: база → цель → отправка (MVP-графика)
- [x] Победа / поражение → диалог → карта, `mapClassic++`, `firstBattleCompleted`
- [x] Анимация флотов (прогресс по тикам, маркеры на поле)
- [x] `/upgrades` — скелет экрана, кнопка меню splash
- [ ] Астероиды, тактические апгрейды на базе
- [ ] Isolate game loop, спрайты legacy
- [ ] Баланс playtest

### Фаза 4 — Begin + прогресс (1–2 нед.)

- [ ] Экран «Новая игра»: сложность, вселенная, подтверждение сброса
- [ ] Экран Progress (статистика из local/API)
- [ ] Апгрейды (логика из `upgrade.dart` + UI)

### Фаза 5 — Аккаунт и сервер (2–4 нед.)

- [ ] `expansion_server` MVP: auth, save/load user, scenes version
- [ ] Profile / Login / Register (Cubit + Dio)
- [ ] Update: проверка версии контента, докачка JSON
- [ ] Top / лидерборд (опционально)

### Фаза 6 — Полировка и релиз

- [ ] Звук (`audioplayers` / `just_audio`), настройки громкости
- [ ] Help, баланс, туториал (`isHint`)
- [ ] Донат (WebView / ссылки)
- [ ] Редактор сцен — только если нужен контент-команде
- [ ] Профилирование, релиз AAB (чеклисты `.cursor/`)

---

## 7. Что в legacy лучше не копировать

| Legacy | Новый app |
|--------|-----------|
| GetX (`Get.find`) | GetIt `sl` |
| freezed / json_serializable | Ручные модели |
| BlocProvider на каждый маршрут | Cubit в `sl` |
| `flutter_screenutil` | `MediaQuery` + layout constants |
| `easy_localization` | `gen-l10n` |
| Секреты в `apiserver` | `.env` / `--dart-define` |
| Talker logs в проде | только debug |

---

## 8. Недоделки legacy (учесть в плане)

1. **Загрузка сцен отключена** в `GameRepository.init()` — нужна явная стратегия: assets-first.
2. **Пустые** `battleRu` / `battleEn` у многих сцен — заполнить или fallback.
3. **Перепутана локаль** описаний на карте — багфикс при переносе.
4. **Сеть** завязана на старый хостинг MySQL — новый server с нуля.
5. **Регистрация/профиль** — проверить end-to-end; возможны незавершённые ветки.
6. **Firebase** в legacy (`firebase_options.dart`) — решить: нужен ли (пуши/аналитика) или убрать.

---

## 9. Следующий конкретный шаг

**Фаза 2** — по [`game-concept.md`](game-concept.md) v1.0: схема SQLite, 40 сцен, domain-модели, сиды, карта кампании.

---

## 10. Ссылки в репозитории

- Концепция игры (черновик): [`game-concept.md`](game-concept.md)
- Спеки стека: [`project-specs.md`](project-specs.md)
- Агент/правила: [`AGENTS.md`](../AGENTS.md)
- Legacy: `D:\Projects\expansion_old\expansion`
- Шаблон: `D:\Projects\_my_template\digitalsquare`
