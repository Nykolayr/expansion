#!/usr/bin/env node
/**
 * Генерация objects_41..50.json.
 * Usage: node scripts/generate-missions-41-50.js
 */
const fs = require('fs');
const path = require('path');

const scenesDir = path.join(__dirname, '..', '..', 'expansion_app', 'assets', 'scenes');

function mainAt(x, y, side) {
  return {
    coordinates: { x, y },
    shild: 100.0,
    ships: 100,
    speedBuild: 0.1,
    inicialShips: 100,
    speedResources: 0.1,
    maxShips: 200,
    typeStatus: side,
  };
}

const stdMain = {
  mainShipEnemy: mainAt(3, 1, 'enemy'),
  mainShipOur: mainAt(3, 7, 'our'),
};

/** [x, y, typeNeutral, variant?] */
const missions = {
  // 41 Сириус — два фланга, пустой центр
  41: {
    neutrals: [
      [1, 2, 'midleBase'], [5, 2, 'midleBase'],
      [1, 3, 'smallBase', 'rich'], [5, 3, 'smallBase', 'rich'],
      [1, 4, 'midleBase'], [5, 4, 'midleBase'],
      [1, 5, 'base'], [5, 5, 'base'],
      [1, 6, 'smallBase'], [2, 6, 'midleBase'], [4, 6, 'midleBase'], [5, 6, 'smallBase'],
    ],
  },
  // 42 Регул — зигзаг
  42: {
    neutrals: [
      [2, 2, 'smallBase'], [4, 2, 'midleBase'],
      [1, 3, 'midleBase'], [3, 3, 'smallBase'], [5, 3, 'midleBase'],
      [2, 4, 'midleBase', 'factory'], [4, 4, 'base'],
      [1, 5, 'smallBase'], [3, 5, 'midleBase'], [5, 5, 'smallBase'],
      [2, 6, 'midleBase', 'shielded'], [4, 6, 'midleBase'],
    ],
  },
  // 43 Вега — полки по рядам
  43: {
    neutrals: [
      [1, 2, 'smallBase'], [2, 2, 'midleBase'], [4, 2, 'midleBase'], [5, 2, 'smallBase'],
      [1, 4, 'midleBase', 'rich'], [2, 4, 'smallBase'], [4, 4, 'smallBase'], [5, 4, 'midleBase', 'rich'],
      [1, 6, 'smallBase'], [2, 6, 'base'], [3, 6, 'midleBase'], [4, 6, 'base'], [5, 6, 'smallBase'],
    ],
  },
  // 44 Антарес — игрок в углу, дрон
  44: {
    main: {
      mainShipEnemy: mainAt(3, 2, 'enemy'),
      mainShipOur: mainAt(1, 7, 'our'),
    },
    neutrals: [
      [1, 2, 'midleBase', 'factory'], [2, 2, 'base'], [4, 2, 'midleBase'], [5, 2, 'smallBase'],
      [2, 3, 'midleBase'], [4, 3, 'smallBase', 'rich'], [5, 3, 'midleBase'],
      [3, 4, 'midleBase', 'shielded'], [5, 4, 'smallBase'],
      [2, 5, 'midleBase'], [4, 5, 'midleBase', 'rich'],
      [3, 6, 'smallBase'], [5, 6, 'midleBase'],
    ],
  },
  // 45 Спика — редкая сетка + shielded + мины
  45: {
    neutrals: [
      [1, 2, 'base', 'shielded'], [3, 2, 'smallBase'], [5, 2, 'base', 'shielded'],
      [2, 3, 'midleBase'], [4, 3, 'midleBase'],
      [1, 4, 'smallBase'], [3, 4, 'midleBase', 'factory'], [5, 4, 'smallBase'],
      [2, 5, 'midleBase', 'shielded'], [4, 5, 'midleBase', 'shielded'],
      [1, 6, 'midleBase'], [3, 6, 'smallBase'], [5, 6, 'midleBase'],
    ],
  },
  // 46 Альфард — кольцо, factory×2
  46: {
    neutrals: [
      [1, 2, 'smallBase'], [2, 2, 'midleBase'], [4, 2, 'midleBase'], [5, 2, 'smallBase'],
      [1, 3, 'midleBase', 'factory'], [5, 3, 'midleBase', 'factory'],
      [1, 5, 'midleBase'], [5, 5, 'midleBase'],
      [1, 6, 'smallBase'], [2, 6, 'midleBase', 'rich'], [3, 6, 'smallBase'], [4, 6, 'midleBase', 'rich'], [5, 6, 'smallBase'],
      [2, 4, 'base'], [4, 4, 'base'],
    ],
  },
  // 47 Денеб — три коридора
  47: {
    neutrals: [
      [1, 2, 'midleBase'], [3, 2, 'base'], [5, 2, 'midleBase'],
      [1, 3, 'smallBase'], [3, 3, 'midleBase', 'shielded'], [5, 3, 'smallBase'],
      [1, 4, 'midleBase', 'factory'], [3, 4, 'smallBase'], [5, 4, 'midleBase', 'factory'],
      [1, 5, 'smallBase'], [3, 5, 'midleBase'], [5, 5, 'smallBase'],
      [1, 6, 'midleBase', 'rich'], [3, 6, 'base'], [5, 6, 'midleBase', 'rich'],
    ],
  },
  // 48 Фомальгаут — острова 2+2
  48: {
    neutrals: [
      [1, 2, 'midleBase', 'bunker'], [2, 2, 'smallBase'],
      [4, 2, 'smallBase'], [5, 2, 'midleBase', 'bunker'],
      [1, 3, 'smallBase', 'rich'], [2, 3, 'midleBase'],
      [4, 3, 'midleBase'], [5, 3, 'smallBase', 'rich'],
      [1, 5, 'midleBase'], [2, 5, 'base'],
      [4, 5, 'base'], [5, 5, 'midleBase'],
      [1, 6, 'smallBase'], [2, 6, 'midleBase', 'factory'],
      [4, 6, 'midleBase', 'factory'], [5, 6, 'smallBase'],
    ],
  },
  // 49 Альнитак — диагональ, dual comet+mines
  49: {
    neutrals: [
      [5, 2, 'midleBase', 'shielded'], [4, 2, 'smallBase'],
      [3, 3, 'base'], [5, 3, 'midleBase'],
      [2, 4, 'midleBase', 'factory'], [4, 4, 'midleBase'],
      [1, 5, 'midleBase', 'rich'], [3, 5, 'smallBase'], [5, 5, 'midleBase'],
      [1, 6, 'smallBase'], [2, 6, 'midleBase'], [3, 6, 'base', 'bunker'], [4, 6, 'smallBase'],
    ],
  },
  // 50 Ригель — mid-boss, дрон + bunker сверху
  50: {
    neutrals: [
      [1, 2, 'base', 'bunker'], [2, 2, 'midleBase', 'bunker'], [3, 2, 'midleBase', 'factory'],
      [4, 2, 'midleBase', 'bunker'], [5, 2, 'base', 'bunker'],
      [1, 3, 'smallBase'], [5, 3, 'smallBase'],
      [2, 4, 'midleBase', 'rich'], [3, 4, 'base'], [4, 4, 'midleBase', 'rich'],
      [1, 5, 'midleBase', 'shielded'], [5, 5, 'midleBase', 'shielded'],
      [2, 6, 'smallBase'], [3, 6, 'midleBase'], [4, 6, 'smallBase'],
    ],
  },
};

function buildNeutral([x, y, typeNeutral, variant]) {
  const row = {
    coordinates: { x, y },
    typeNeutral,
    typeStatus: 'neutral',
  };
  if (variant) row.variant = variant;
  return row;
}

for (const [id, def] of Object.entries(missions)) {
  const mains = def.main || stdMain;
  const json = {
    ...mains,
    neutral: def.neutrals.map(buildNeutral),
  };
  const out = path.join(scenesDir, `objects_${id}.json`);
  fs.writeFileSync(out, `${JSON.stringify(json, null, 3)}\n`);
  console.log('Wrote', out, `(${def.neutrals.length} bases)`);
}
