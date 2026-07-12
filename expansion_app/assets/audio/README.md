# Аудио боя

Короткие SFX (MP3):

| Файл | Событие | Заглушка (ffmpeg synth) |
|------|---------|-------------------------|
| `fleet_send.mp3` | Отправка флота | whoosh (pink noise) |
| `capture.mp3` | Захват базы | короткий «дин» ~988 Hz |
| `victory.mp3` | Победа | восходящая арпеджио C-E-G-C |
| `defeat.mp3` | Поражение | нисходящие низкие тоны |

`GameAudioService` → `AssetSource('audio/...')`. Звук можно выключить в настройках.

## Перегенерация заглушек

```powershell
cd expansion_server
npm install ffmpeg-static --no-save   # или ffmpeg в PATH
node scripts/generate-audio-stubs.js
```

Позже — заменить файлы на нормальные SFX (legacy / Suno / Freesound). Референс: `expansion_old` (лицензия).
