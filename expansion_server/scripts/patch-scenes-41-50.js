#!/usr/bin/env node
/**
 * Обновляет scenes.json для миссий 41–50 (индексы 40–49).
 */
const fs = require('fs');
const path = require('path');

const scenesPath = path.join(
  __dirname,
  '..',
  '..',
  'expansion_app',
  'assets',
  'scenes',
  'scenes.json',
);

const updates = {
  41: {
    nameRu: 'Сириус',
    nameEn: 'Sirius',
    descriptionRu:
      'Туманность Андромеды. После штурма опорного кластера флот выходит на спокойные фланги — время выбрать путь.',
    descriptionEn:
      'Andromeda Nebula. After the core assault, the fleet reaches quieter flanks — time to choose a path.',
    battleRu:
      'Два широких фланга, центр пуст. Выберите левый или правый путь и не распыляйте флот.',
    battleEn:
      'Two wide flanks, empty center. Pick left or right and do not split your fleet.',
  },
  42: {
    nameRu: 'Регул',
    nameEn: 'Regulus',
    descriptionRu: 'Зигзаг маршрутов и комета на срезе — терпение важнее лобовой атаки.',
    descriptionEn: 'Zigzag routes and a comet on the cut — patience beats a head-on rush.',
    battleRu: 'Комета режет поле. Ждите окно и ведите флот зигзагом по узлам.',
    battleEn: 'The comet cuts the field. Wait for a window and advance zigzag along the nodes.',
  },
  43: {
    nameRu: 'Вега',
    nameEn: 'Vega',
    descriptionRu: 'Горизонтальные «полки» баз. Обломки бьют по ряду — не копите весь флот на одной линии.',
    descriptionEn: 'Horizontal shelves of bases. Debris hits a row — do not park your whole fleet on one line.',
    battleRu: 'Обломки летят по среднему ряду. Распределяйте флот по полкам.',
    battleEn: 'Debris flies along the middle row. Spread your fleet across the shelves.',
  },
  44: {
    nameRu: 'Антарес',
    nameEn: 'Antares',
    descriptionRu: 'Вы в углу системы. Дрон кормит захватчика — богатые узлы в тылу критичны.',
    descriptionEn: 'You start in a corner. The drone feeds the invader — rich rear nodes matter.',
    battleRu: 'Дрон даёт корабли врагу. Быстро заберите rich и не дайте дрону разогнаться.',
    battleEn: 'The drone grants ships to the enemy. Grab rich bases fast before it snowballs.',
  },
  45: {
    nameRu: 'Спика',
    nameEn: 'Spica',
    descriptionRu: 'Редкая сетка и мины на ключевых клетках. Щитовые узлы держат дольше.',
    descriptionEn: 'Sparse grid and mines on key cells. Shielded nodes hold longer.',
    battleRu: 'Мины блокируют короткие пути. Обходите через фланги, shielded берите вторыми.',
    battleEn: 'Mines block short paths. Flank around them; take shielded bases second.',
  },
  46: {
    nameRu: 'Альфард',
    nameEn: 'Alphard',
    descriptionRu: 'Кольцо баз вокруг пустого центра. Импульс бьёт из середины — фабрики на ободе.',
    descriptionEn: 'A ring of bases around an empty core. Pulse hits from the middle — factories on the rim.',
    battleRu: 'Импульс из центра. Захватывайте factory на кольце, не стойте в эпицентре.',
    battleEn: 'Pulse from the center. Capture ring factories; do not linger in the epicenter.',
  },
  47: {
    nameRu: 'Денеб',
    nameEn: 'Deneb',
    descriptionRu: 'Три вертикальных коридора. Солнечный ветер сильнее бьёт по среднему пути.',
    descriptionEn: 'Three vertical corridors. Solar wind hits the middle path hardest.',
    battleRu: 'Средний коридор опасен. Боковые пути безопаснее для длинных перебросок.',
    battleEn: 'The middle corridor is dangerous. Side paths are safer for long transfers.',
  },
  48: {
    nameRu: 'Фомальгаут',
    nameEn: 'Fomalhaut',
    descriptionRu: 'Два острова без моста. Червоточина — короткий, но рискованный переход.',
    descriptionEn: 'Two islands with no bridge. The wormhole is a short but risky crossing.',
    battleRu: 'Без червоточины путь долгий. Решите: рискнуть мостом или идти вокруг.',
    battleEn: 'Without the wormhole the route is long. Risk the bridge or go the long way.',
  },
  49: {
    nameRu: 'Альнитак',
    nameEn: 'Alnitak',
    descriptionRu: 'Диагональ к штабу врага. Комета и мины вместе — двойная угроза на маршруте.',
    descriptionEn: 'A diagonal toward the enemy HQ. Comet and mines together — dual threat on the route.',
    battleRu: 'Комета и мины на диагонали. Меняйте маршрут, не шлифуйте один коридор.',
    battleEn: 'Comet and mines on the diagonal. Switch routes — do not grind one corridor.',
  },
  50: {
    nameRu: 'Ригель',
    nameEn: 'Rigel',
    descriptionRu:
      'Верхняя линия врага укреплена бункерами, дрон подпитывает фронт. Рубеж туманности Андромеды.',
    descriptionEn:
      'The enemy top line is bunkered, the drone feeds the front. Andromeda Nebula checkpoint.',
    battleRu:
      'Дрон и бункеры на верхней линии. Ломайте фланги, не бейтесь в лоб по бункерам.',
    battleEn:
      'Drone plus bunkers on the top line. Break the flanks — do not smash bunkers head-on.',
  },
};

const scenes = JSON.parse(fs.readFileSync(scenesPath, 'utf8'));
for (const [idStr, patch] of Object.entries(updates)) {
  const id = Number(idStr);
  const index = id - 1;
  if (!scenes[index]) {
    console.error('Missing scene index', index);
    process.exit(1);
  }
  scenes[index] = { ...scenes[index], ...patch };
  console.log(`Updated mission ${id}: ${patch.nameRu}`);
}
fs.writeFileSync(scenesPath, `${JSON.stringify(scenes, null, 3)}\n`);
console.log('Wrote', scenesPath);
