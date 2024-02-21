import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../common/random_extension.dart';
import '../../service/event/damage_event.dart';
import '../../service/game/direction.dart';
import '../tile_map/tile.dart';
import '../tile_map/tile_map.dart';
import '../unit/attackable.dart';
import '../unit/health.dart';
import '../unit/movable.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required int turnCount,
    required int killCount,
    required String actionTileId,
    required TileMap tileMap,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  bool get isPlayerAction => actionTileId == playerTileId;

  // Proxy methods
  PlayerTile? get playerTile => tileMap.playerTile;
  String? get playerTileId => tileMap.playerTileId;
  int get tileCount => tileMap.tileCount;

  Tile? findTile(String id) => tileMap.findTile(id);
  List<Tile> getTilesAt(int x, int y) => tileMap.getTilesAt(x, y);
  bool isBlockingAt(int x, int y) => tileMap.isBlockingAt(x, y);

  bool get isGameOver => playerTile == null;

  Direction getValidDirectionToPlayer(Tile tile) {
    return tileMap.getValidDirectionToPlayer(tile);
  }

  String findNextActionTileId() {
    final tiles = tileMap.tiles;
    final index = tiles.indexWhere((tile) => tile.id == actionTileId);
    assert(index >= 0, 'Action tile should exist: $actionTileId');

    final nextIndex = (index + 1) % tiles.length;
    return tiles[nextIndex].id;
  }

  GameState addOrUpdateTile(Tile tile) {
    final newTileMap = tileMap.addOrUpdateTile(tile);
    return copyWith(tileMap: newTileMap);
  }

  GameState removeTile(String id) {
    final newTileMap = tileMap.removeTile(id);
    return copyWith(tileMap: newTileMap);
  }

  GameState moveTile(Tile tile, Direction direction) {
    final newTileMap = tileMap.moveTile(tile, direction);
    return copyWith(tileMap: newTileMap);
  }

  GameState updateMoveCooldown() {
    var newGameState = copyWith();
    for (final tile in tileMap.tiles) {
      final movable = tile as Movable?;
      if (movable == null) {
        continue;
      }

      var cooldown = movable.moveCooldown;
      if (cooldown <= 0) {
        cooldown = movable.maxMoveCooldown;
      }

      cooldown -= 1;

      final newTile = tile.updateMoveCooldown(cooldown);
      newGameState = newGameState.addOrUpdateTile(newTile);
    }

    return newGameState;
  }

  GameState removeDeadTiles() {
    var newGameState = copyWith();
    for (final tile in tileMap.tiles) {
      final health = tile as Health?;
      if (health == null) {
        continue;
      }

      if (health.health <= 0) {
        newGameState = newGameState.removeTile(tile.id);
      }
    }

    return newGameState;
  }

  GameState spawnEnemies({
    int count = 50,
    int minPlayerDistance = 8,
    int maxPlayerDistance = 12,
    int maxTileCount = 100,
    int maxTryCount = 10,
  }) {
    final random = Random();
    const uuid = Uuid();

    var newGameState = copyWith();
    final playerTile = this.playerTile;
    if (playerTile == null) {
      return newGameState;
    }

    for (var i = 0; i < count; i++) {
      if (newGameState.tileCount >= maxTileCount) {
        break;
      }

      int dx;
      int dy;
      bool isValid = false;
      int tryCount = 0;
      do {
        dx = random.nextIntRange(0, maxPlayerDistance);
        dy = random.nextIntRange(0, maxPlayerDistance);
        isValid = dx >= minPlayerDistance || dy >= minPlayerDistance;
        tryCount += 1;
      } while (!isValid && tryCount < maxTryCount);

      if (!isValid) {
        continue;
      }

      final x = playerTile.x + (dx * random.nextSign());
      final y = playerTile.y + (dy * random.nextSign());
      if (newGameState.isBlockingAt(x, y)) {
        continue;
      }

      final enemyTile = Tile.createEnemy(uuid.v4(), x, y);
      newGameState = newGameState.addOrUpdateTile(enemyTile);
    }

    return newGameState;
  }

  bool isCloseToPlayer(Tile tile) {
    final playerTile = this.playerTile;
    if (playerTile == null) {
      return false;
    }

    return tileMap.isCloseToTile(tile, playerTile);
  }

  (GameState, DamageEvent?) attackPlayer(Tile attacker) {
    final playerTile = this.playerTile;
    if (playerTile == null) {
      return (this, null);
    }

    return attackTile(attacker, playerTile);
  }

  (GameState, DamageEvent?) attackTile(Tile attacker, Tile defender) {
    final isAttackerExist = tileMap.tiles.any((t) => t.id == attacker.id);
    final isDefenderExist = tileMap.tiles.any((t) => t.id == defender.id);
    if (!isAttackerExist || !isDefenderExist) {
      return (this, null);
    }

    final attackable = attacker as Attackable?;
    if (attackable == null) {
      return (this, null);
    }

    final health = defender as Health?;
    if (health == null) {
      return (this, null);
    }

    final newHealth = max(health.health - attackable.damage, 0);
    final newDefender = defender.updateHealth(newHealth);

    final damageEvent = DamageEvent(
      attackerId: attacker.id,
      defenderId: defender.id,
      damage: attackable.damage,
    );

    return (addOrUpdateTile(newDefender), damageEvent);
  }
}
