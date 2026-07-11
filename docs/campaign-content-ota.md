# OTA-публикация миссий кампании

> **Утверждено:** 2026-07-11.  
> С этого момента **все новые миссии и правки раскладок** выходят **через сервер**, без релиза APK/AAB.

---

## Решение

| Что | Как |
|-----|-----|
| **Новые миссии** (м6, м7, …) | JSON на сервере → клиент скачивает в SQLite → **игра офлайн** |
| **Правки баланса** существующих миссий | Тот же OTA-pack, новый `contentVersion` |
| **Bundled в APK** | Только **offline-baseline** (сейчас v6, м1–м5 полностью играбельны без сети) |
| **Релиз в стор** | Нужен только при **новой механике в коде** (hazard, variant, UI боя) |

---

## Источник правды JSON

Файлы по-прежнему лежат в репозитории (удобно diff и ревью):

```text
expansion_app/assets/scenes/scenes.json
expansion_app/assets/scenes/objects_N.json
```

**В prod не копируем** новые миссии через bump `bundledContentVersion` — только **server seed**.

---

## Публикация на сервер (агент / разработчик)

```powershell
cd D:\Projects\expansion\expansion_server

# 1. Собрать pack из assets (version, с какой миссии layouts — аргументы)
npm run content:build -- 8 6    # пример: v8, layouts с м6

# 2. Деплой API + content/ на VPS
.\deploy\deploy-vps.ps1

# 3. На VPS: миграции (если ещё не) + seed
ssh -i $env:USERPROFILE\.ssh\redmobi_beget_ed25519 root@46.173.25.193
cd /opt/expansion-api && node scripts/migrate.js && node scripts/seed-campaign-content.js
```

Локально без VPS:

```powershell
npm run content:build
npm run content:seed    # нужен .env с DB_*
```

---

## Клиент (offline-first)

1. Старт → bundled seed (baseline).
2. Если есть сеть → `GET /content/version`; при `remote > local` → `GET /content/pack` → merge в SQLite.
3. **Без сети** — игра из SQLite; прогресс в prefs + sync профиля при появлении сети.
4. Баннер на splash, если `contentVersion > bundledContentVersion` и игрок ещё не закрыл уведомление.

Код: `CampaignContentSyncService`, `AppBootstrapCubit`, `API_DOCS.md` § Content.

---

## Чеклист новой миссии (м6+)

1. Дизайн в [`campaign-missions-1-15.md`](../expansion_app/docs/campaign-missions-1-15.md) → утверждение.
2. Правки `scenes.json` + `objects_N.json` в `expansion_app/assets/scenes/`.
3. Playtest локально (можно временно поднять `bundledContentVersion` **только для dev**, в master **не коммитить** bump baseline ради новой миссии).
4. `npm run content:build` → новый `contentVersion` → seed на VPS.
5. Проверка на устройстве: OTA, офлайн-бой, баннер «новые миссии».

---

## Запрещено

- Добавлять м6+ **только** через увеличение `bundledContentVersion` и релиз в стор (кроме dev).
- Менять формат JSON без обновления `SceneAssetParser` и **min app version** (отдельное решение).

---

## Связанные документы

| Документ | Назначение |
|----------|------------|
| [`expansion_server/API_DOCS.md`](../expansion_server/API_DOCS.md) | REST `/content/*` |
| [`expansion_server/deploy/VPS.md`](../expansion_server/deploy/VPS.md) | Деплой API |
| [`ROADMAP.md`](ROADMAP.md) | Пункт 3 — кампания |
| [`expansion_app/docs/campaign-missions-1-15.md`](../expansion_app/docs/campaign-missions-1-15.md) | Дизайн миссий |
