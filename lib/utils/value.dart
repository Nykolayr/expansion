import 'dart:ui';

/// адресс где находится политика безопасности
const politicUrl = 'https://flutter.dev';

/// путь где находится описание объектов для карт
const pathAssetScenes = 'assets/scenes';

/// размерность экрана битвы по горизонтали
const rowBattle = 5;

/// размерность экрана битвы по вертикали
const columnBattle = 8;

/// размеры эталлоного устройства
const Size standardDeviceSize = Size(392.7, 850.9);

/// размер устройства
Size deviceSize = Size.zero;
// шаг по оси х (5 позиций)
final double stepX = standardDeviceSize.width / 6;
// шаг по оси х (7 позиций)
final double stepY = standardDeviceSize.height / 9;
// количество тиков которые нужно пропустить для рендеринга
const maxHoldTic = 2;
// количество тиков для нового астероида
const maxAsteroidTic = 500;
// скорость астероидов
const double asteroidSpeed = 1;
// умножитель скорости для кораблей
const speedShipsMult = 1.4;
// делитель скорости для производства кораблей на базе
// при уменьшении скорость увеличивается
const delSpeedBuild = 12;
// Множитель, который определяет диапазон очков
// также начальное значение для апгрейда
const int scoreMultiplier = 200;
// размер корабля
const double shipSize = 40;
