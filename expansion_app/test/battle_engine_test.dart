import 'package:flutter_test/flutter_test.dart';

import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';
import 'package:expansion/domain/enums/tactical_upgrade_type.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';
import 'package:expansion/game_core/battle/battle_tactical_balance.dart';
import 'package:expansion/game_core/battle/neutral_base_balance.dart';
import 'package:expansion/game_core/battle/tactical_upgrade_result.dart';
import 'package:expansion/game_core/battle/battle_fleet_rules.dart';
import 'package:expansion/game_core/battle/battle_victory_reward.dart';

BattleEngine _twoBaseEngine({
  int playerShips = 20,
  int neutralShips = 5,
}) {
  return BattleEngine(
    sceneId: 99,
    gridRows: 5,
    gridCols: 8,
    bases: [
      BattleBase(
        id: 0,
        x: 0,
        y: 2,
        side: BattleSide.player,
        ships: playerShips,
        shield: 0,
        isCommandBase: true,
      ),
      BattleBase(
        id: 1,
        x: 4,
        y: 2,
        side: BattleSide.neutral,
        ships: neutralShips,
        shield: 0,
      ),
      BattleBase(
        id: 2,
        x: 7,
        y: 2,
        side: BattleSide.enemy,
        ships: 15,
        shield: 0,
        isCommandBase: true,
      ),
    ],
  );
}

void main() {
  group('defaultFleetSendCount', () {
    test('returns all ships when only one', () {
      expect(defaultFleetSendCount(1), 1);
    });

    test('sends half rounded up', () {
      expect(defaultFleetSendCount(10), 5);
      expect(defaultFleetSendCount(11), 6);
    });
  });

  group('BattleRewardCalculator', () {
    test('mission 1 reward', () {
      final reward = BattleRewardCalculator.forMission(1);
      expect(reward.basePoints, 40);
      expect(reward.missionBonus, 12);
      expect(reward.total, 52);
    });
  });

  group('BattleEngine', () {
    test('sendFleet reduces ships and creates fleet', () {
      final engine = _twoBaseEngine();
      final sent = engine.sendFleet(0, 1, requiredSide: BattleSide.player);
      expect(sent, isTrue);
      final snap = engine.snapshot();
      expect(snap.baseById(0)!.ships, 10);
      expect(snap.fleets, hasLength(1));
      expect(snap.fleets.first.ships, 10);
    });

    test('cannot send through blocked line', () {
      final engine = BattleEngine(
        sceneId: 1,
        gridRows: 5,
        gridCols: 8,
        bases: [
          const BattleBase(
            id: 0,
            x: 0,
            y: 2,
            side: BattleSide.player,
            ships: 10,
            shield: 0,
          ),
          const BattleBase(
            id: 1,
            x: 2,
            y: 2,
            side: BattleSide.neutral,
            ships: 5,
            shield: 0,
          ),
          const BattleBase(
            id: 2,
            x: 4,
            y: 2,
            side: BattleSide.neutral,
            ships: 5,
            shield: 0,
          ),
        ],
      );
      expect(engine.canSendFleet(0, 2), isFalse);
      expect(engine.lineOfSightBlocker(0, 2), isNotNull);
    });

    test('player wins when no enemy bases', () {
      final engine = BattleEngine(
        sceneId: 1,
        gridRows: 5,
        gridCols: 8,
        bases: [
          const BattleBase(
            id: 0,
            x: 0,
            y: 0,
            side: BattleSide.player,
            ships: 10,
            shield: 0,
          ),
        ],
      );
      expect(engine.outcome(), BattleOutcome.playerWin);
    });

    test('player loses when no player bases', () {
      final engine = BattleEngine(
        sceneId: 1,
        gridRows: 5,
        gridCols: 8,
        bases: [
          const BattleBase(
            id: 0,
            x: 0,
            y: 0,
            side: BattleSide.enemy,
            ships: 10,
            shield: 0,
          ),
        ],
      );
      expect(engine.outcome(), BattleOutcome.playerLose);
    });
    test('fleet travel time scales with grid distance', () {
      final nearEngine = BattleEngine(
        sceneId: 1,
        gridRows: 5,
        gridCols: 8,
        bases: [
          const BattleBase(
            id: 0,
            x: 1,
            y: 1,
            side: BattleSide.player,
            ships: 20,
            shield: 0,
          ),
          const BattleBase(
            id: 1,
            x: 2,
            y: 1,
            side: BattleSide.neutral,
            ships: 1,
            shield: 0,
          ),
        ],
      );
      final farEngine = BattleEngine(
        sceneId: 1,
        gridRows: 5,
        gridCols: 8,
        bases: [
          const BattleBase(
            id: 0,
            x: 1,
            y: 1,
            side: BattleSide.player,
            ships: 20,
            shield: 0,
          ),
          const BattleBase(
            id: 1,
            x: 7,
            y: 4,
            side: BattleSide.neutral,
            ships: 1,
            shield: 0,
          ),
        ],
      );

      nearEngine.sendFleet(0, 1, requiredSide: BattleSide.player);
      farEngine.sendFleet(0, 1, requiredSide: BattleSide.player);

      var nearTicks = 0;
      while (nearEngine.snapshot().fleets.isNotEmpty && nearTicks < 500) {
        nearEngine.tick(spawnAsteroids: false);
        nearTicks++;
      }

      var farTicks = 0;
      while (farEngine.snapshot().fleets.isNotEmpty && farTicks < 500) {
        farEngine.tick(spawnAsteroids: false);
        farTicks++;
      }

      expect(nearEngine.snapshot().fleets, isEmpty);
      expect(farEngine.snapshot().fleets, isEmpty);
      expect(farTicks, greaterThan(nearTicks));
    });
    test('mission 1 tutorial capture grants resources for upgrade', () {
      final engine = BattleEngine(
        sceneId: 1,
        gridRows: 8,
        gridCols: 5,
        bases: [
          const BattleBase(
            id: 0,
            x: 3,
            y: 7,
            side: BattleSide.player,
            ships: 100,
            shield: 0,
            isCommandBase: true,
          ),
          const BattleBase(
            id: 1,
            x: 3,
            y: 1,
            side: BattleSide.enemy,
            ships: 100,
            shield: 0,
            isCommandBase: true,
          ),
          const BattleBase(
            id: 9,
            x: 2,
            y: 6,
            side: BattleSide.neutral,
            ships: 30,
            shield: 0,
          ),
        ],
      );

      expect(engine.mission1TutorialCaptureBaseId, 9);
      engine.setTutorialCaptureBonusBaseId(9);
      engine.sendFleet(0, 9, requiredSide: BattleSide.player, shipCount: 50);

      while (engine.snapshot().fleets.isNotEmpty) {
        engine.tick(spawnAsteroids: false);
      }

      final captured = engine.snapshot().baseById(9)!;
      expect(captured.side, BattleSide.player);
      expect(captured.resources, greaterThanOrEqualTo(80));
    });
    test('enemy can apply tactical upgrade with resources', () {
      final engine = BattleEngine(
        sceneId: 2,
        gridRows: 8,
        gridCols: 5,
        bases: [
          const BattleBase(
            id: 1,
            x: 3,
            y: 1,
            side: BattleSide.enemy,
            ships: 40,
            shield: 0,
            resources: 100,
            isCommandBase: true,
          ),
        ],
      );

      final result = engine.applyTacticalUpgrade(
        1,
        TacticalUpgradeType.shield,
      );

      expect(result, TacticalUpgradeResult.success);
      final base = engine.snapshot().baseById(1)!;
      expect(base.shield, 20);
      expect(base.resources, 20);
      expect(base.shieldUpgradeLevel, 1);
    });
    test('asteroid destroys weaker fleet and keeps remaining power', () {
      final engine = BattleEngine(
        sceneId: 2,
        gridRows: 8,
        gridCols: 5,
        bases: [
          const BattleBase(
            id: 0,
            x: 1,
            y: 4,
            side: BattleSide.player,
            ships: 50,
            shield: 0,
          ),
          const BattleBase(
            id: 1,
            x: 5,
            y: 4,
            side: BattleSide.neutral,
            ships: 5,
            shield: 0,
          ),
        ],
      );

      engine.debugPlaceFleetForTest(
        fromBaseId: 0,
        toBaseId: 1,
        ships: 10,
        progress: 0.5,
      );
      engine.debugPlaceAsteroidForTest(gridX: 3, gridY: 4, power: 25);
      engine.tick(spawnAsteroids: false);

      final snap = engine.snapshot();
      expect(snap.fleets, isEmpty);
      expect(snap.asteroids, hasLength(1));
      expect(snap.asteroids.first.power, 15);
      expect(snap.explosions, isNotEmpty);
    });

    test('asteroid removed when fleet is stronger', () {
      final engine = BattleEngine(
        sceneId: 2,
        gridRows: 8,
        gridCols: 5,
        bases: [
          const BattleBase(
            id: 0,
            x: 1,
            y: 4,
            side: BattleSide.player,
            ships: 50,
            shield: 0,
          ),
          const BattleBase(
            id: 1,
            x: 5,
            y: 4,
            side: BattleSide.neutral,
            ships: 5,
            shield: 0,
          ),
        ],
      );

      engine.debugPlaceFleetForTest(
        fromBaseId: 0,
        toBaseId: 1,
        ships: 20,
        progress: 0.5,
      );
      engine.debugPlaceAsteroidForTest(gridX: 3, gridY: 4, power: 8);
      engine.tick(spawnAsteroids: false);

      final snap = engine.snapshot();
      expect(snap.asteroids, isEmpty);
      expect(snap.fleets, hasLength(1));
      expect(snap.fleets.first.ships, 12);
    });
    test('neutral base kinds use distinct max ship limits', () {
      expect(
        NeutralBaseBalance.profileFor(kind: NeutralBaseKind.smallBase).maxShips,
        30,
      );
      expect(
        NeutralBaseBalance.profileFor(kind: NeutralBaseKind.middleBase).maxShips,
        50,
      );
      expect(
        NeutralBaseBalance.profileFor(kind: NeutralBaseKind.base).maxShips,
        80,
      );
    });

    test('build speed upgrade lowers ship growth threshold', () {
      expect(
        BattleTacticalBalance.shipGrowthThresholdTicks(
          speedBuild: 0.1,
          buildUpgradeLevel: 0,
          growthMul: 1,
        ),
        28,
      );
      expect(
        BattleTacticalBalance.shipGrowthThresholdTicks(
          speedBuild: 0.1,
          buildUpgradeLevel: 1,
          growthMul: 1,
        ),
        22,
      );
      expect(
        BattleTacticalBalance.shipGrowthThresholdTicks(
          speedBuild: 0.1,
          buildUpgradeLevel: 3,
          growthMul: 1,
        ),
        14,
      );
    });

    test('upgraded base produces ships faster in battle', () {
      final slowEngine = BattleEngine(
        sceneId: 2,
        gridRows: 8,
        gridCols: 5,
        bases: [
          const BattleBase(
            id: 0,
            x: 1,
            y: 4,
            side: BattleSide.player,
            ships: 10,
            shield: 0,
            maxShips: 200,
          ),
        ],
      );
      final fastEngine = BattleEngine(
        sceneId: 2,
        gridRows: 8,
        gridCols: 5,
        bases: [
          const BattleBase(
            id: 0,
            x: 1,
            y: 4,
            side: BattleSide.player,
            ships: 10,
            shield: 0,
            maxShips: 200,
            buildUpgradeLevel: 3,
          ),
        ],
      );

      for (var i = 0; i < 30; i++) {
        slowEngine.tick(spawnAsteroids: false);
        fastEngine.tick(spawnAsteroids: false);
      }

      final slowShips = slowEngine.snapshot().baseById(0)!.ships;
      final fastShips = fastEngine.snapshot().baseById(0)!.ships;
      expect(fastShips, greaterThan(slowShips));
    });

    test('reinforcement can exceed build cap maxShips', () {
      final engine = BattleEngine(
        sceneId: 99,
        gridRows: 5,
        gridCols: 8,
        bases: [
          const BattleBase(
            id: 0,
            x: 0,
            y: 2,
            side: BattleSide.player,
            ships: 25,
            shield: 0,
            maxShips: 30,
          ),
          const BattleBase(
            id: 1,
            x: 4,
            y: 2,
            side: BattleSide.player,
            ships: 50,
            shield: 0,
            maxShips: 30,
          ),
        ],
      );

      engine.debugPlaceFleetForTest(
        fromBaseId: 1,
        toBaseId: 0,
        ships: 15,
        progress: 0.99,
      );
      engine.tick(spawnAsteroids: false);

      expect(engine.snapshot().baseById(0)!.ships, 40);
    });

    test('auto build stops when ships reach maxShips', () {
      final engine = BattleEngine(
        sceneId: 99,
        gridRows: 5,
        gridCols: 8,
        bases: [
          const BattleBase(
            id: 0,
            x: 0,
            y: 2,
            side: BattleSide.player,
            ships: 30,
            shield: 0,
            maxShips: 30,
            speedBuild: 0.1,
          ),
        ],
      );

      for (var i = 0; i < 50; i++) {
        engine.tick(spawnAsteroids: false);
      }

      expect(engine.snapshot().baseById(0)!.ships, 30);
    });

    test('auto build resumes after ships drop below maxShips', () {
      final engine = BattleEngine(
        sceneId: 99,
        gridRows: 5,
        gridCols: 8,
        bases: [
          const BattleBase(
            id: 0,
            x: 0,
            y: 2,
            side: BattleSide.player,
            ships: 29,
            shield: 0,
            maxShips: 30,
            speedBuild: 0.1,
          ),
        ],
      );

      for (var i = 0; i < 40; i++) {
        engine.tick(spawnAsteroids: false);
      }

      expect(engine.snapshot().baseById(0)!.ships, greaterThanOrEqualTo(30));
    });
  });
}
