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

run(
  [
    '-f',
    'lavfi',
    '-i',
    'anoisesrc=color=pink:duration=0.22:sample_rate=44100:amplitude=0.35',
    '-af',
    'highpass=f=1200,lowpass=f=9000,afade=t=in:st=0:d=0.01,afade=t=out:st=0.12:d=0.1,volume=0.85',
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

run(
  [
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=523:duration=0.15:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=659:duration=0.15:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=784:duration=0.15:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=1047:duration=0.32:sample_rate=44100',
    '-filter_complex',
    '[0:a][1:a][2:a][3:a]concat=n=4:v=0:a=1,afade=t=out:st=0.55:d=0.2,volume=0.6',
    ...mp3,
    path.join(outDir, 'victory.mp3'),
  ],
  'victory.mp3',
);

run(
  [
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=220:duration=0.22:sample_rate=44100',
    '-f',
    'lavfi',
    '-i',
    'sine=frequency=165:duration=0.38:sample_rate=44100',
    '-filter_complex',
    '[0:a][1:a]concat=n=2:v=0:a=1,afade=t=out:st=0.45:d=0.15,volume=0.65',
    ...mp3,
    path.join(outDir, 'defeat.mp3'),
  ],
  'defeat.mp3',
);
