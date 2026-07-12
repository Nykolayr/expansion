#!/usr/bin/env node
/**
 * Синтетические SFX-заглушки для assets/audio (ffmpeg lavfi).
 * Usage: node scripts/generate-audio-stubs.js
 * Требует: npm install ffmpeg-static (dev) или ffmpeg в PATH.
 */
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');

function resolveFfmpeg() {
  try {
    return require('ffmpeg-static');
  } catch {
    return 'ffmpeg';
  }
}

const ffmpeg = resolveFfmpeg();
const outDir = path.join(__dirname, '..', '..', 'expansion_app', 'assets', 'audio');
fs.mkdirSync(outDir, { recursive: true });

function run(args, name) {
  execFileSync(ffmpeg, ['-y', '-hide_banner', '-loglevel', 'error', ...args], {
    stdio: 'inherit',
  });
  console.log('OK:', name);
}

const mp3 = ['-codec:a', 'libmp3lame', '-q:a', '4'];

// ~1 s — отправка флота (можно накладывать при быстрых кликах)
run(
  [
    '-f',
    'lavfi',
    '-i',
    'anoisesrc=color=pink:duration=1.0:sample_rate=44100:amplitude=0.32',
    '-af',
    'highpass=f=800,lowpass=f=7000,afade=t=in:st=0:d=0.04,afade=t=out:st=0.75:d=0.25,volume=0.8',
    ...mp3,
    path.join(outDir, 'fleet_send.mp3'),
  ],
  'fleet_send.mp3',
);

run(
  [
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=988:duration=0.28:sample_rate=44100',
    '-af',
    'volume=0.55,afade=t=in:st=0:d=0.005,afade=t=out:st=0.08:d=0.2',
    ...mp3,
    path.join(outDir, 'capture.mp3'),
  ],
  'capture.mp3',
);

// ~6 s — победа
run(
  [
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=392:duration=1.2:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=494:duration=1.2:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=587:duration=1.2:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=784:duration=2.4:sample_rate=44100',
    '-filter_complex',
    '[0:a][1:a][2:a][3:a]concat=n=4:v=0:a=1,afade=t=out:st=5.2:d=0.8,volume=0.55',
    ...mp3,
    path.join(outDir, 'victory.mp3'),
  ],
  'victory.mp3',
);

// ~6 s — поражение
run(
  [
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=220:duration=2.0:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=175:duration=2.0:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=131:duration=2.0:sample_rate=44100',
    '-filter_complex',
    '[0:a][1:a][2:a]concat=n=3:v=0:a=1,afade=t=out:st=5.0:d=1.0,volume=0.6',
    ...mp3,
    path.join(outDir, 'defeat.mp3'),
  ],
  'defeat.mp3',
);

// ~1 s — столкновение флотов
run(
  [
    '-f',
    'lavfi',
    '-i',
    'anoisesrc=color=white:duration=0.15:sample_rate=44100:amplitude=0.5',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=180:duration=0.85:sample_rate=44100',
    '-filter_complex',
    '[0:a][1:a]concat=n=2:v=0:a=1,lowpass=f=4000,afade=t=out:st=0.7:d=0.3,volume=0.75',
    ...mp3,
    path.join(outDir, 'fleet_clash.mp3'),
  ],
  'fleet_clash.mp3',
);

// ~0.5 s — появление hazard
run(
  [
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=440:duration=0.12:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=660:duration=0.38:sample_rate=44100',
    '-filter_complex',
    '[0:a][1:a]concat=n=2:v=0:a=1,afade=t=out:st=0.35:d=0.15,volume=0.5',
    ...mp3,
    path.join(outDir, 'hazard_spawn.mp3'),
  ],
  'hazard_spawn.mp3',
);

// ~1.5 s — пролёт hazard
run(
  [
    '-f',
    'lavfi',
    '-i',
    'anoisesrc=color=pink:duration=1.5:sample_rate=44100:amplitude=0.28',
    '-af',
    'highpass=f=200,lowpass=f=5000,afade=t=in:st=0:d=0.15,afade=t=out:st=1.1:d=0.4,volume=0.7',
    ...mp3,
    path.join(outDir, 'hazard_pass.mp3'),
  ],
  'hazard_pass.mp3',
);

// ~0.2 s — UI click
run(
  [
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=1200:duration=0.08:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=880:duration=0.12:sample_rate=44100',
    '-filter_complex',
    '[0:a][1:a]concat=n=2:v=0:a=1,afade=t=out:st=0.1:d=0.1,volume=0.45',
    ...mp3,
    path.join(outDir, 'ui_click.mp3'),
  ],
  'ui_click.mp3',
);

// ~0.6 s — upgrade
run(
  [
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=523:duration=0.2:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=784:duration=0.25:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=1047:duration=0.15:sample_rate=44100',
    '-filter_complex',
    '[0:a][1:a][2:a]concat=n=3:v=0:a=1,afade=t=out:st=0.45:d=0.15,volume=0.55',
    ...mp3,
    path.join(outDir, 'upgrade.mp3'),
  ],
  'upgrade.mp3',
);
