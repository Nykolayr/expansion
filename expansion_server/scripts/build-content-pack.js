#!/usr/bin/env node
/**
 * Сборка JSON-пакета кампании из assets клиента.
 * Usage: node scripts/build-content-pack.js [version] [fromSceneId]
 *
 * По умолчанию: version=7, layouts с миссии 6 (APK baseline v6 = м1–м5).
 * Новые миссии — только через server OTA, см. docs/campaign-content-ota.md.
 */
const fs = require('fs');
const path = require('path');

const version = Number(process.argv[2] || 7);
const layoutFrom = Number(process.argv[3] || 6);
const scenesDir = path.join(__dirname, '..', '..', 'expansion_app', 'assets', 'scenes');
const outDir = path.join(__dirname, '..', 'content');
const outFile = path.join(outDir, `campaign-pack-v${version}.json`);

const scenesPath = path.join(scenesDir, 'scenes.json');
if (!fs.existsSync(scenesPath)) {
  console.error('Missing scenes.json at', scenesPath);
  process.exit(1);
}

const scenes = JSON.parse(fs.readFileSync(scenesPath, 'utf8'));
const layouts = {};

for (let id = layoutFrom; id <= 40; id += 1) {
  const layoutPath = path.join(scenesDir, `objects_${id}.json`);
  if (fs.existsSync(layoutPath)) {
    layouts[String(id)] = JSON.parse(fs.readFileSync(layoutPath, 'utf8'));
  }
}

const pack = {
  contentVersion: version,
  sceneCount: scenes.length > 40 ? 40 : scenes.length,
  scenes,
  layouts,
};

fs.mkdirSync(outDir, { recursive: true });
fs.writeFileSync(outFile, JSON.stringify(pack));
console.log(`Wrote ${outFile} (v${version}, layouts ${layoutFrom}-40: ${Object.keys(layouts).length})`);
