# Реестр UI и сервисов обратной связи

| Путь | Назначение |
|------|------------|
| `core/ui/app_feedback_kind.dart` | Enum: success / warning / error (цвет SnackBar) |
| `core/ui/app_feedback_service.dart` | Централизованный показ SnackBar через GetIt |
| `core/ui/app_scaffold_messenger_key.dart` | Глобальный ключ для `MaterialApp.scaffoldMessengerKey` |

Показ сообщений пользователю — только через **`AppFeedbackService`**, без прямого `ScaffoldMessenger`.

---

# Реестр виджетов (`lib/presentation/widgets/`)

Перед добавлением нового виджета **проверь таблицу ниже** и дерево папок. После создания файла — **добавь строку**.

| Путь | Назначение |
|------|------------|
| `splash/splash_side_button.dart` | Боковая SVG-кнопка меню splash |
| `splash/splash_line_buttons.dart` | Ряд из трёх кнопок (верх/низ меню) |
| `splash/splash_long_button.dart` | Широкая кнопка «Начать игру» |
| `splash/splash_loader_panel.dart` | Карточка вступления и полоса загрузки |
| `splash/splash_pretext_typer.dart` | Печать вступительного текста посимвольно |
| `app_bar/game_screen_back_bar.dart` | Заголовок экрана с кнопкой «назад» |
| `layout/game_screen_scaffold.dart` | Фон + back bar + тело или `placeholderMessage` |
| `maps/map_scene_tile.dart` | Узел миссии на карте кампании |
| `maps/campaign_map_grid.dart` | Сетка 5×N + панель описания миссии |
| `battle/battle_field_grid.dart` | Поле боя 5×8, тап по клеткам |
| `battle/battle_entity_sprite.dart` | `Image.asset` спрайта с fallback |
| `battle/battle_base_view.dart` | Спрайт базы + HUD корабли/щит/ресурсы |
| `battle/battle_tactical_panel.dart` | Панель тактических улучшений выбранной базы |
| `upgrades/meta_upgrade_tile.dart` | Строка мета-апгрейда с кнопкой покупки |
| `dialogs/game_confirm_dialog.dart` | Диалог подтверждения (сброс кампании) |

Страницы: `maps_page` (карта 40 миссий), скелеты `begin_page`, `battle_page`, `profile_page`, `progress_page`.
| `splash/splash_menu_direct.dart` | Enum позиций кнопок и пути SVG |
