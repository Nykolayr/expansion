# Expansion — текущий план работ

> **Обновлено:** 2026-07-12.  
> Порядок приоритетов: **сервер → кампания → релиз монетизации**.

Исторические фазы разработки клиента — в [`expansion_app/docs/game-plan.md`](../expansion_app/docs/game-plan.md).

---

## 1. Сервер + аккаунты — **готово к тесту**

**Спецификация:** [`auth-account-spec.md`](auth-account-spec.md)

| Задача | Статус |
|--------|--------|
| API v0.3 (auth, profile, leaderboard, OTA, platform admin) | ✅ VPS `46.173.25.193` |
| Web-админка HTML | ✅ `danilagames.ru/admin/` |
| SMTP | ✅ синк с Beget; **проверить регистрацию на устройстве** |
| Клиент: экраны auth, merge, leaderboard, delete | ✅ |
| Bootstrap: pull профиля + refresh JWT | ✅ |

**Твоя проверка:** регистрация → код → вход → рейтинг → удаление аккаунта.

---

## 2. Арты — **сделано пользователем** ✅

---

## 3. Кампания Classic (м1–15)

**Дизайн:** [`campaign-missions-1-15.md`](../expansion_app/docs/campaign-missions-1-15.md)  
**OTA:** [`campaign-content-ota.md`](campaign-content-ota.md)

| Статус | Содержание |
|--------|------------|
| ✅ М1–М5 | bundled v6 в APK |
| ✅ М6–М15 | layouts + hazards в OTA (с v10); battle-подсказки м3–м15 (v11) |
| 🔜 М16–М40 | layouts в JSON; hazards по плану 16–40 |

**Твоя проверка:** OTA с v6 → v11, пройти м6–м15, баннер новых миссий.

---

## 4. Монетизация — **код готов, сторы — на тебе**

- Remote config + админка toggles ✅  
- Yandex Ads + IAP в клиенте ✅  
- **Твоя сторона:** РСЯ, Play IAP, release `--dart-define` — [`monetization-setup-ru.md`](monetization-setup-ru.md)

---

## Связанные документы

| Документ | Назначение |
|----------|------------|
| [`auth-account-spec.md`](auth-account-spec.md) | Auth + рейтинг |
| [`admin-platform.md`](admin-platform.md) | HTML-админка |
| [`API.md`](API.md) | Хаб REST |
| [`GAME.md`](GAME.md) | Хаб игры |
