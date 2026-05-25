# Project Specs: Expansion

Монорепозиторий: [Nykolayr/expansion](https://github.com/Nykolayr/expansion).

| Пакет | Путь | Назначение |
|-------|------|------------|
| Клиент | `expansion_app/` | Flutter, iOS + Android |
| API | `expansion_server/` | Backend (отдельная разработка) |
| Админка | `expansion_admin/` | Веб-админка (отдельная разработка) |

## Продукт

Космическая стратегия в реальном времени: захват баз, производство кораблей, сражения на сетке, кампания по картам/сценариям. Идея и механики — из legacy `expansion_old`; код и архитектура — **с нуля** на шаблоне digitalsquare.

## Идентификация

- **Android / iOS:** `com.ryjovs.expansion`
- **Версия:** `1.0.0+1` (новая линейка релизов)
- **Ориентация:** только портрет
- **UI:** immersive sticky, тёмная тема (`ExpansionColors` / Kelly Slab)

## Стек клиента (жёстко)

- Flutter 3.44+ / Dart 3.12+
- Clean Architecture: `data` / `domain` / `presentation`
- `flutter_bloc`, GetIt (`sl`), `go_router`, Dio
- l10n: `lib/l10n/*.arb` (ru, en)
- **Без GetX.** Сеть/API — когда появится `expansion_server`.

## Экраны (legacy, для переноса)

| Маршрут | Экран | BLoC |
|---------|--------|------|
| `/` | Splash | SplashBloc |
| `/maps` | Карта кампании | MapsBloc |
| `/settings` | Настройки | SettingBloc |
| `/donate` | Донат | — |
| `/profile` | Профиль | ProfileBloc |
| `/profile_login` | Вход | ProfileLoginBloc |
| `/profile_register` | Регистрация | — |
| `/progress` | Прогресс | ProgressBloc |
| `/update` | Обновление контента | UpdateBloc |
| `/begin` | Старт игры | BeginBloc |
| `/battle` | Бой (сетка 5×8) | BattleBloc |
| `/scenarios` | Редактор сценариев | ScenariosBloc |

## Игровая логика (кратко)

- **game_core:** игровой цикл, тики, isolate (`computer` в legacy — оценить `Isolate` / `compute` / пакет `computer` при переносе).
- **Сущности:** базы, корабли, астероиды, апгрейды, вражеский AI.
- **Данные сцен:** JSON в `assets/scenes/` (пока не перенесены).
- **Локальные настройки:** SharedPreferences; токены — SecureStorage.

## Сеть (позже)

Legacy API: Express + MySQL/Mongo (`expansion_old/apiserver`). В клиенте заготовки: `DioClient`, `ApiConfig`, `ErrorHandler`. Base URL — через `--dart-define` / `.env`, не в git.

## Ассеты (следующий этап)

- `assets/scenes/`, `assets/images/`, `assets/svg/`, `assets/audio/`, шрифт Kelly Slab
- Иконка / splash — перед стором

## Релиз

- Один upload-keystore для Play и RuStore (см. `.cursor/android_release.md`)
- Сборки в `D:\Temp`: `expansion_1_{buildNumber}.aab`

## Рекомендации по производительности (Flutter 3.44+)

- Тяжёлая симуляция боя — **отдельный isolate** или `Isolate.run`, не блокировать UI isolate.
- Спрайты/анимации — `RepaintBoundary`, по возможности `CustomPainter` + кэш кадров вместо сотен виджетов.
- Звук: рассмотреть `audioplayers` или `just_audio` при переносе.
- Карта кампании: `ListView.builder` / ленивая загрузка сцен.
- Impeller на iOS по умолчанию; на Android следить за GPU-профилем в DevTools.

## Ссылки

- Legacy код: `D:\Projects\expansion_old\expansion`
- Шаблон архитектуры: `D:\Projects\_my_template\digitalsquare`
