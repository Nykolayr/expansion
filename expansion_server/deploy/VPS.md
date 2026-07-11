# Expansion — деплой (как redmobi)

Тот же **VPS** `46.173.25.193` и **SSH-ключ** `~/.ssh/redmobi_beget_ed25519`, что у [redmobi_vps](D:\Projects\redmobi\redmobi_vps).

## Архитектура

| Компонент | Где | Деплой |
|-----------|-----|--------|
| Заглушка сайта | [danilagames.ru](https://danilagames.ru/) Beget | `deploy-danilagames-placeholder.ps1` |
| REST API | VPS `/opt/expansion-api` pm2 | `deploy-vps.ps1` |
| SMTP | из `.env` на Beget `danilagames.ru/public_html` | подтягивается автоматически |

Joy Pick / joypick.world — **не используем**.

## SSH

```powershell
# VPS (как redmobi_vps/README.md)
ssh -i $env:USERPROFILE\.ssh\redmobi_beget_ed25519 root@46.173.25.193

# Beget danilagames (как redmobi_server/deploy-beget.ps1 — autogie1@, не autogie1_todo)
ssh -i $env:USERPROFILE\.ssh\redmobi_beget_ed25519 autogie1@autogie1.beget.tech
```

## Одной командой (агент / CI)

```powershell
cd D:\Projects\expansion\expansion_server
.\deploy\deploy-danilagames-placeholder.ps1   # при смене заглушки
.\deploy\deploy-vps.ps1                       # код + migrate + pm2 + SMTP с Beget
```

## Секреты (опционально)

Как `redmobi_vps/secrets/` — **не в git**:

```text
deploy/secrets/expansion-api.env   ← copy from deploy/secrets.example/
```

Если файл есть — деплой заливает его на VPS. Если нет — **SMTP** берётся из Beget `danilagames.ru/public_html/.env`, DB/JWT остаются на сервере.

## URL API

| Среда | URL |
|-------|-----|
| Prod (IP) | http://46.173.25.193/api/health |
| Prod (DNS) | https://expansion-api.danilagames.ru/api — после A-записи + certbot |

Клиент: `--dart-define=API_BASE_URL=https://expansion-api.danilagames.ru/api`

## SSL (после DNS A → 46.173.25.193)

```bash
certbot --nginx -d expansion-api.danilagames.ru
```

## Первичная установка VPS (один раз)

Уже выполнено. Повтор: `bash deploy/install-redmobi-vps.sh` на сервере.

## Load-check локально

```bash
npm run load-check
```

## OTA миссии (новые уровни без релиза APK)

Канон: [`docs/campaign-content-ota.md`](../../docs/campaign-content-ota.md)

```powershell
cd D:\Projects\expansion\expansion_server
npm run content:build -- 8 6   # contentVersion, layouts с миссии N
.\deploy\deploy-vps.ps1
# на VPS:
# cd /opt/expansion-api && node scripts/seed-campaign-content.js
```
