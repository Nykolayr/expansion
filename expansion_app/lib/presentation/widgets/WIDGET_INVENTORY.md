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
| *(пока пусто — добавляй по мере появления виджетов)* | |
