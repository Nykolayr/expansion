# Аудио боя

SFX в MP3 → `GameAudioService` → `AssetSource('audio/...')`. Звук можно выключить в настройках.

**Стиль:** обычные военные космические корабли (флот, базы, ракетные двигатели). Без НЛО, без «инопланетных» лазеров и мистики.

## v1 — файлы и длительность

| Файл | Событие | Длина | В игре |
|------|---------|-------|--------|
| `fleet_send.mp3` | Отправка флота | **~1.0 с** | да (пул плееров — можно слать часто) |
| `capture.mp3` | Захват базы | ~0.4–0.6 с | позже |
| `victory.mp3` | Победа | **~6.0 с** | да |
| `defeat.mp3` | Поражение | **~6.0 с** | да |
| `fleet_clash.mp3` | Столкновение флотов | **~1.0 с** | да |
| `hazard_spawn.mp3` | Появление hazard | **~0.5 с** | да |
| `hazard_pass.mp3` | Пролёт hazard | **~1.5 с** | да (через ~0.4 с после spawn) |
| `ui_click.mp3` | Кнопки меню, апгрейды (▲) | **~0.2 с** | да |
| `upgrade.mp3` | Успешный апгрейд | **~0.6 с** | да |

**UI (`ui_click`, `upgrade`)** — можно **sci-fi / holographic** (в отличие от боевых SFX).

Мина — только spawn. Остальные hazards (астероид, комета, обломки, дрон…) — spawn + pass.

Техника: MP3, 44.1 kHz, моно или стерео; пик ~−3 dB; громкость SFX выровнять между файлами.

## Промпты (ElevenLabs Sound Effects)

### Длительность в интерфейсе ElevenLabs

Отдельного поля «Duration» в тексте **нет**. Управление — **внизу**, слева от кнопки Generate:

| Иконка | Подпись | Что делает |
|--------|---------|------------|
| 🔄 | Loop | Off — для SFX |
| **🕐** | **Auto** | **← это длительность.** Клик → выключить Auto → ввести секунды (1, 0.5, 6…) |
| ⬡ | 30% | Prompt influence — для SFX лучше **75–85%** |
| ✨ | On | вариативность генерации |

**Строка сверху** (`fleet_send — 1.0 c`) — только **название/метка**, на длину **не влияет**.  
Пока стоит **Auto**, модель сама решает — у тебя вышло **2.0 s** вместо 1 s.

**Порядок:** промпт в большое поле → клик **🕐 Auto** → задать **1** (или 6 для victory/defeat) → ⬡ **~80%** → Generate.

| Файл | 🕐 Duration (не Auto) | ⬡ Influence |
|------|----------------------|-------------|
| `fleet_send` | **1** | 80% |
| `capture` | **0.5** | 80% |
| `victory` | **6** | 75% |
| `defeat` | **6** | 75% |
| `fleet_clash` | **1** | 80% |
| `hazard_spawn` | **0.5** | 80% |
| `hazard_pass` | **1.5** | 75% |
| `ui_click` | **0.2** | 80% |
| `upgrade` | **0.6** | 80% |

Фразы «six seconds» в промпте — про **форму** звука, не замена 🕐.

### `fleet_send.mp3` — 🕐 **1** сек

> Military fleet departure from orbital base, conventional rocket thrusters and engine burn, warships leaving in formation, realistic space combat RTS, grounded military sci-fi not alien UFO, dry mix no laser zaps

### `capture.mp3` — 🕐 **0.5** сек

> Base captured military confirmation tone, short solid electronic beep with brief upward pitch, strategy game feedback, tactical not mystical

### `victory.mp3` — 🕐 **6** сек

> Victory fanfare for space strategy game, triumphant military synth march, fleet triumph after battle, conventional warships theme not alien, builds over six seconds with clear peak then gentle resolve, mobile game win screen

### `defeat.mp3` — 🕐 **6** сек

> Defeat theme for space RTS, somber descending military horns and low synth pads, lost battle retreat, conventional military tone not horror or UFO, six seconds fading to silence

### `fleet_clash.mp3` — 🕐 **1** сек

> Two military space fleets engaging in mid-flight battle, conventional warship weapons impact and hull stress, metal and engine bursts, tactical RTS combat not alien lasers, short dry mix

### `hazard_spawn.mp3` — 🕐 **0.5** сек

> Space tactical alert ping, object entering the sector, asteroid or debris detected on sensors, military sci-fi warning tone, short and clear not UFO

### `hazard_pass.mp3` — 🕐 **1.5** сек

> Large object passing through space sector, deep rumble whoosh of asteroid or debris field moving across view, conventional space hazard not alien, medium volume tactical RTS

### UI — sci-fi стиль допустим

### `ui_click.mp3` — 🕐 **0.2** сек

> Soft holographic sci-fi UI button click, futuristic interface beep, clean digital tap, space strategy game menu, short crisp high-tech

### `upgrade.mp3` — 🕐 **0.6** сек

> Sci-fi module upgrade confirmation, energy power-up surge, futuristic base enhancement complete, satisfying synth rise and sparkle, space RTS interface

Если боевой звук «космически-странный» — добавь: `grounded, human military fleet, no alien sounds, no theremin, no UFO`. **Для UI это не нужно.**

## Бесплатные источники

- [ElevenLabs Sound Effects](https://elevenlabs.io/sound-effects) — генерация по промптам выше
- [Freesound.org](https://freesound.org) — фильтр CC0, поиск `spaceship engine`, `rocket launch short`
- [Pixabay](https://pixabay.com/sound-effects/) / [Mixkit](https://mixkit.co/free-sound-effects/) — готовые royalty-free

## Заглушки (ffmpeg)

```powershell
cd expansion_server
npm install ffmpeg-static --no-save   # или ffmpeg в PATH
node scripts/generate-audio-stubs.js
```

Заменить файлы — положить MP3 с теми же именами в эту папку.
