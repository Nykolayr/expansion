#!/usr/bin/env node
/**
 * Генерация objects_16..40.json из таблицы раскладок.
 * Usage: node scripts/generate-missions-16-40.js
 */
const fs = require('fs');
const path = require('path');

const scenesDir = path.join(__dirname, '..', '..', 'expansion_app', 'assets', 'scenes');

const stdMain = {
  mainShipEnemy: {
    coordinates: { x: 3, y: 1 },
    shild: 100.0,
    ships: 100,
    speedBuild: 0.1,
    inicialShips: 100,
    speedResources: 0.1,
    maxShips: 200,
    typeStatus: 'enemy',
  },
  mainShipOur: {
    coordinates: { x: 3, y: 7 },
    shild: 100.0,
    ships: 100,
    speedBuild: 0.1,
    inicialShips: 100,
    speedResources: 0.1,
    maxShips: 200,
    typeStatus: 'our',
  },
};

/** [x, y, typeNeutral, variant?] */
const missions = {
  16: [
    [1, 2, 'smallBase'], [2, 2, 'midleBase'], [4, 2, 'midleBase'], [5, 2, 'smallBase'],
    [1, 3, 'midleBase', 'rich'], [5, 3, 'midleBase', 'rich'],
    [2, 4, 'base'], [3, 4, 'midleBase'], [4, 4, 'base'],
    [1, 5, 'smallBase'], [5, 5, 'smallBase'],
    [2, 6, 'midleBase', 'shielded'], [3, 6, 'smallBase'], [4, 6, 'midleBase', 'shielded'],
  ],
  17: [
    [1, 2, 'smallBase'], [3, 2, 'midleBase'], [5, 2, 'smallBase'],
    [2, 3, 'midleBase', 'factory'], [4, 3, 'midleBase', 'factory'],
    [1, 4, 'midleBase'], [3, 4, 'smallBase'], [5, 4, 'midleBase'],
    [2, 5, 'midleBase'], [4, 5, 'midleBase'],
    [3, 5, 'base'], [2, 6, 'smallBase'], [4, 6, 'smallBase'],
  ],
  18: [
    [2, 2, 'midleBase'], [3, 2, 'smallBase'], [4, 2, 'midleBase'],
    [1, 3, 'smallBase'], [5, 3, 'smallBase'],
    [2, 4, 'base'], [4, 4, 'base'],
    [1, 5, 'midleBase', 'bunker'], [3, 5, 'midleBase'], [5, 5, 'midleBase', 'bunker'],
    [2, 6, 'smallBase'], [3, 6, 'midleBase'], [4, 6, 'smallBase'],
  ],
  19: [
    [1, 2, 'midleBase'], [2, 2, 'smallBase'], [4, 2, 'smallBase'], [5, 2, 'midleBase'],
    [3, 3, 'midleBase'],
    [1, 4, 'smallBase'], [5, 4, 'smallBase'],
    [2, 5, 'midleBase', 'rich'], [3, 5, 'smallBase'], [4, 5, 'midleBase', 'rich'],
    [1, 6, 'smallBase'], [3, 6, 'midleBase'], [5, 6, 'smallBase'],
  ],
  20: [
    [2, 2, 'midleBase', 'factory'], [3, 2, 'base'], [4, 2, 'midleBase', 'factory'],
    [1, 3, 'smallBase'], [5, 3, 'smallBase'],
    [2, 4, 'midleBase'], [3, 4, 'midleBase', 'shielded'], [4, 4, 'midleBase'],
    [1, 5, 'midleBase'], [5, 5, 'midleBase'],
    [2, 6, 'smallBase', 'rich'], [3, 6, 'midleBase'], [4, 6, 'smallBase', 'rich'],
  ],
  21: [
    [1, 2, 'base', 'bunker'], [3, 2, 'midleBase'], [5, 2, 'base', 'bunker'],
    [2, 3, 'midleBase', 'shielded'], [4, 3, 'midleBase', 'shielded'],
    [1, 4, 'midleBase'], [3, 4, 'smallBase'], [5, 4, 'midleBase'],
    [2, 5, 'midleBase'], [4, 5, 'midleBase'],
    [1, 6, 'smallBase'], [3, 6, 'midleBase', 'factory'], [5, 6, 'smallBase'],
  ],
  22: [
    [3, 2, 'midleBase'], [2, 3, 'smallBase'], [4, 3, 'smallBase'],
    [1, 4, 'midleBase', 'rich'], [3, 4, 'base'], [5, 4, 'midleBase', 'rich'],
    [2, 5, 'midleBase'], [4, 5, 'midleBase'],
    [1, 5, 'smallBase'], [5, 5, 'smallBase'],
    [2, 6, 'midleBase', 'factory'], [3, 6, 'smallBase'], [4, 6, 'midleBase', 'factory'],
  ],
  23: [
    [1, 2, 'smallBase'], [5, 2, 'smallBase'],
    [2, 3, 'midleBase'], [3, 3, 'smallBase'], [4, 3, 'midleBase'],
    [1, 4, 'midleBase', 'shielded'], [5, 4, 'midleBase', 'shielded'],
    [2, 5, 'base'], [3, 5, 'midleBase'], [4, 5, 'base'],
    [2, 6, 'smallBase'], [3, 6, 'midleBase', 'rich'], [4, 6, 'smallBase'],
  ],
  24: [
    [2, 2, 'midleBase'], [3, 2, 'smallBase'], [4, 2, 'midleBase'],
    [1, 3, 'midleBase', 'factory'], [5, 3, 'midleBase', 'factory'],
    [2, 4, 'smallBase'], [4, 4, 'smallBase'],
    [1, 5, 'base'], [3, 5, 'midleBase', 'bunker'], [5, 5, 'base'],
    [2, 6, 'midleBase'], [3, 6, 'smallBase'], [4, 6, 'midleBase'],
  ],
  25: [
    [1, 2, 'midleBase'], [2, 2, 'smallBase'], [4, 2, 'smallBase'], [5, 2, 'midleBase'],
    [3, 3, 'base'],
    [1, 4, 'smallBase', 'rich'], [2, 4, 'midleBase'], [4, 4, 'midleBase'], [5, 4, 'smallBase', 'rich'],
    [2, 5, 'midleBase', 'shielded'], [3, 5, 'midleBase'], [4, 5, 'midleBase', 'shielded'],
    [3, 6, 'base'],
  ],
  26: [
    [3, 2, 'midleBase', 'factory'], [2, 3, 'smallBase'], [4, 3, 'smallBase'],
    [1, 4, 'midleBase', 'bunker'], [5, 4, 'midleBase', 'bunker'],
    [2, 5, 'midleBase'], [3, 5, 'smallBase'], [4, 5, 'midleBase'],
    [1, 5, 'smallBase'], [5, 5, 'smallBase'],
    [2, 6, 'base'], [3, 6, 'midleBase', 'shielded'], [4, 6, 'base'],
  ],
  27: [
    [1, 2, 'smallBase'], [2, 2, 'midleBase'], [4, 2, 'midleBase'], [5, 2, 'smallBase'],
    [1, 3, 'midleBase'], [5, 3, 'midleBase'],
    [2, 4, 'midleBase', 'rich'], [3, 4, 'smallBase'], [4, 4, 'midleBase', 'rich'],
    [1, 5, 'smallBase'], [5, 5, 'smallBase'],
    [2, 6, 'midleBase'], [3, 6, 'base'], [4, 6, 'midleBase'],
  ],
  28: [
    [2, 2, 'smallBase'], [3, 2, 'midleBase', 'factory'], [4, 2, 'smallBase'],
    [1, 3, 'midleBase'], [5, 3, 'midleBase'],
    [2, 4, 'midleBase'], [3, 4, 'base'], [4, 4, 'midleBase'],
    [1, 5, 'smallBase', 'rich'], [5, 5, 'smallBase', 'rich'],
    [2, 5, 'midleBase', 'shielded'], [4, 5, 'midleBase', 'shielded'],
    [3, 6, 'midleBase'],
  ],
  29: [
    [1, 2, 'midleBase'], [3, 2, 'smallBase'], [5, 2, 'midleBase'],
    [2, 3, 'midleBase', 'bunker'], [4, 3, 'midleBase', 'bunker'],
    [1, 4, 'smallBase'], [3, 4, 'midleBase'], [5, 4, 'smallBase'],
    [2, 5, 'midleBase', 'factory'], [3, 5, 'smallBase'], [4, 5, 'midleBase', 'factory'],
    [2, 6, 'smallBase'], [4, 6, 'smallBase'],
  ],
  30: [
    [1, 2, 'base', 'shielded'], [2, 2, 'midleBase'], [4, 2, 'midleBase'], [5, 2, 'base', 'shielded'],
    [3, 2, 'midleBase', 'factory'],
    [2, 3, 'smallBase', 'rich'], [4, 3, 'smallBase', 'rich'],
    [1, 4, 'midleBase'], [3, 4, 'base'], [5, 4, 'midleBase'],
    [2, 5, 'midleBase'], [4, 5, 'midleBase'],
    [2, 6, 'midleBase', 'bunker'], [3, 6, 'smallBase'], [4, 6, 'midleBase', 'bunker'],
  ],
  31: [
    [3, 2, 'midleBase'], [1, 3, 'smallBase'], [5, 3, 'smallBase'],
    [2, 4, 'midleBase', 'rich'], [3, 4, 'smallBase'], [4, 4, 'midleBase', 'rich'],
    [1, 5, 'midleBase', 'factory'], [5, 5, 'midleBase', 'factory'],
    [2, 6, 'base'], [3, 6, 'midleBase', 'shielded'], [4, 6, 'base'],
  ],
  32: [
    [1, 2, 'midleBase'], [2, 2, 'smallBase'], [4, 2, 'smallBase'], [5, 2, 'midleBase'],
    [3, 3, 'base'],
    [1, 4, 'midleBase', 'bunker'], [2, 4, 'smallBase'], [4, 4, 'smallBase'], [5, 4, 'midleBase', 'bunker'],
    [2, 5, 'midleBase', 'rich'], [3, 5, 'midleBase'], [4, 5, 'midleBase', 'rich'],
    [3, 6, 'midleBase', 'factory'],
  ],
  33: [
    [2, 2, 'midleBase'], [3, 2, 'smallBase'], [4, 2, 'midleBase'],
    [1, 3, 'midleBase', 'shielded'], [5, 3, 'midleBase', 'shielded'],
    [2, 4, 'smallBase'], [4, 4, 'smallBase'],
    [1, 5, 'base'], [3, 5, 'midleBase', 'factory'], [5, 5, 'base'],
    [2, 6, 'midleBase', 'rich'], [3, 6, 'smallBase'], [4, 6, 'midleBase', 'rich'],
  ],
  34: [
    [1, 2, 'smallBase', 'factory'], [5, 2, 'smallBase', 'factory'],
    [2, 3, 'midleBase'], [3, 3, 'base'], [4, 3, 'midleBase'],
    [1, 4, 'midleBase'], [5, 4, 'midleBase'],
    [2, 5, 'midleBase', 'shielded'], [3, 5, 'midleBase'], [4, 5, 'midleBase', 'shielded'],
    [1, 6, 'smallBase', 'rich'], [3, 6, 'base'], [5, 6, 'smallBase', 'rich'],
  ],
  35: [
    [2, 2, 'midleBase', 'bunker'], [3, 2, 'midleBase'], [4, 2, 'midleBase', 'bunker'],
    [1, 3, 'smallBase'], [5, 3, 'smallBase'],
    [2, 4, 'midleBase', 'rich'], [3, 4, 'smallBase'], [4, 4, 'midleBase', 'rich'],
    [1, 5, 'midleBase', 'factory'], [5, 5, 'midleBase', 'factory'],
    [2, 6, 'base'], [3, 6, 'midleBase', 'shielded'], [4, 6, 'base'],
  ],
  36: [
    [1, 2, 'midleBase', 'rich'], [2, 2, 'smallBase'], [4, 2, 'smallBase'], [5, 2, 'midleBase', 'rich'],
    [3, 2, 'base', 'factory'],
    [1, 4, 'midleBase', 'shielded'], [5, 4, 'midleBase', 'shielded'],
    [2, 4, 'midleBase'], [3, 4, 'midleBase'], [4, 4, 'midleBase'],
    [2, 5, 'smallBase', 'bunker'], [3, 5, 'base'], [4, 5, 'smallBase', 'bunker'],
    [3, 6, 'midleBase'],
  ],
  37: [
    [3, 2, 'midleBase', 'shielded'], [2, 3, 'midleBase'], [4, 3, 'midleBase'],
    [1, 4, 'base', 'bunker'], [5, 4, 'base', 'bunker'],
    [2, 5, 'midleBase', 'factory'], [3, 5, 'smallBase'], [4, 5, 'midleBase', 'factory'],
    [1, 5, 'smallBase'], [5, 5, 'smallBase'],
    [2, 6, 'midleBase', 'rich'], [3, 6, 'base'], [4, 6, 'midleBase', 'rich'],
  ],
  38: [
    [1, 2, 'smallBase'], [2, 2, 'midleBase', 'factory'], [4, 2, 'midleBase', 'factory'], [5, 2, 'smallBase'],
    [3, 3, 'base'],
    [1, 4, 'midleBase'], [2, 4, 'smallBase', 'rich'], [4, 4, 'smallBase', 'rich'], [5, 4, 'midleBase'],
    [2, 5, 'midleBase', 'shielded'], [3, 5, 'midleBase'], [4, 5, 'midleBase', 'shielded'],
    [3, 6, 'midleBase', 'bunker'],
  ],
  39: [
    [2, 2, 'midleBase'], [3, 2, 'smallBase'], [4, 2, 'midleBase'],
    [1, 3, 'midleBase', 'rich'], [5, 3, 'midleBase', 'rich'],
    [2, 4, 'base', 'factory'], [3, 4, 'midleBase'], [4, 4, 'base', 'factory'],
    [1, 5, 'smallBase'], [5, 5, 'smallBase'],
    [2, 6, 'midleBase', 'bunker'], [3, 6, 'midleBase', 'shielded'], [4, 6, 'midleBase', 'bunker'],
  ],
  40: [
    [1, 2, 'midleBase', 'shielded'], [2, 2, 'smallBase', 'rich'], [4, 2, 'smallBase', 'rich'], [5, 2, 'midleBase', 'shielded'],
    [3, 2, 'base', 'factory'],
    [1, 3, 'midleBase', 'bunker'], [2, 3, 'smallBase'], [4, 3, 'smallBase'], [5, 3, 'midleBase', 'bunker'],
    [2, 4, 'midleBase'], [3, 4, 'base'], [4, 4, 'midleBase'],
    [1, 5, 'smallBase', 'factory'], [2, 5, 'midleBase', 'rich'], [4, 5, 'midleBase', 'rich'], [5, 5, 'smallBase', 'factory'],
    [2, 6, 'midleBase', 'shielded'], [3, 6, 'midleBase'], [4, 6, 'midleBase', 'shielded'],
  ],
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

for (const [id, layout] of Object.entries(missions)) {
  const json = {
    ...stdMain,
    neutral: layout.map(buildNeutral),
  };
  const out = path.join(scenesDir, `objects_${id}.json`);
  fs.writeFileSync(out, `${JSON.stringify(json, null, 3)}\n`);
  console.log('Wrote', out, `(${layout.length} bases)`);
}
