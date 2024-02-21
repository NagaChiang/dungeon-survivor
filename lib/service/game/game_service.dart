import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../common/logger.dart';
import '../../model/game/game_repository.dart';
import '../../model/game/game_state.dart';
import '../../model/tile_map/tile.dart';
import '../../model/tile_map/tile_map.dart';
import '../../model/unit/movable.dart';
import '../event/attack_event.dart';
import '../event/damage_event.dart';
import 'direction.dart';

class GameService {
  GameService(this._gameRepo) {
    _createNewGame();
    _subscribeActionTileId();
  }

  final GameRepository _gameRepo;

  Stream<TileMap> get tileMapStream => _gameRepo.tileMapStream;
  Stream<PlayerTile> get playerTileStream => _gameRepo.playerTileStream;
  Stream<String> get playerTileIdStream => _gameRepo.playerTileIdStream;
  Stream<int> get killCountStream => _gameRepo.killCountStream;

  final _attackEventSubject = BehaviorSubject<AttackEvent>();
  late final attackEventStream = _attackEventSubject.stream;

  final _damageEventSubject = BehaviorSubject<DamageEvent>();
  late final damageEventStream = _damageEventSubject.stream;

  final _sub = CompositeSubscription();
  final _uuid = const Uuid();

  void dispose() {
    _sub.clear();
  }

  Stream<Tile> getTileStream(String id) {
    return _gameRepo.getTileStream(id);
  }

  void onInputDirection(Direction direction) {
    final gameState = _gameRepo.gameState;
    if (gameState == null) {
      logger.warning('Game state not found', tag: _tag);
      return;
    }

    if (!gameState.isPlayerAction) {
      logger.trace('Not player action', tag: _tag);
      return;
    }

    final playerTile = gameState.playerTile;
    if (playerTile == null) {
      logger.warning('Player tile not found', tag: _tag);
      return;
    }

    if (!_canMove(playerTile)) {
      _endAction();
      return;
    }

    Future(() => _startPlayerAction(playerTile, direction));
  }

  bool _canMove(Tile tile) {
    final gameState = _gameRepo.gameState;
    if (gameState == null) {
      logger.warning('Game state not found', tag: _tag);
      return false;
    }

    final movable = tile as Movable?;
    if (movable == null) {
      return false;
    }

    return movable.moveCooldown <= 0;
  }

  void _subscribeActionTileId() {
    _gameRepo.actionTileIdStream.listen((actionTileId) {
      logger.trace('Start action: $actionTileId', tag: _tag);

      if (_gameRepo.gameState?.isGameOver == true) {
        return;
      }

      if (actionTileId == _gameRepo.gameState?.playerTileId) {
        return;
      }

      Future(() => _startEnemyAction(actionTileId));
    }).addTo(_sub);
  }

  void _startPlayerAction(Tile playerTile, Direction direction) {
    final gameState = _gameRepo.gameState;
    if (gameState == null) {
      logger.error('Game state not found', tag: _tag);
      return;
    }

    var newGameState = gameState.copyWith();
    newGameState = newGameState.moveTile(playerTile, direction);

    final newPlayerTile = newGameState.playerTile;
    if (newPlayerTile == null) {
      logger.error('Player tile not found', tag: _tag);
      _endAction();

      return;
    }

    const rangeX = 3;
    const rangeY = 1;
    final coords = <(int, int)>[];
    const blacklistCoords = {
      (0, 0),
      (0, -1),
      (0, 1),
      (1, -1),
      (1, 1),
      (-1, -1),
      (-1, 1),
    };

    for (var x = -rangeX; x <= rangeX; x++) {
      for (var y = -rangeY; y <= rangeY; y++) {
        if (blacklistCoords.contains((x, y))) {
          continue;
        }

        coords.add((x, y));
      }
    }

    final targetCoords = coords
        .map(
          (c) => (
            newPlayerTile.coord.$1 + c.$1,
            newPlayerTile.coord.$2 + c.$2,
          ),
        )
        .toList();

    final attackEvent = AttackEvent(
      attackerId: newPlayerTile.id,
      targetCoords: targetCoords,
    );

    _attackEventSubject.add(attackEvent);

    var deadEnemyCount = 0;
    for (final (x, y) in targetCoords) {
      final tiles = newGameState.getTilesAt(x, y);
      for (final tile in tiles) {
        final DamageEvent? damageEvent;
        (newGameState, damageEvent) = newGameState.attackTile(playerTile, tile);

        final newEnemy = newGameState.tileMap.findTile(tile.id) as EnemyTile?;
        if (newEnemy != null && newEnemy.health <= 0) {
          deadEnemyCount++;
        }

        if (damageEvent != null) {
          _damageEventSubject.add(damageEvent);
        }
      }
    }

    newGameState = newGameState.copyWith(
      killCount: newGameState.killCount + deadEnemyCount,
    );

    _gameRepo.updateGameState(newGameState);

    _endAction();
  }

  void _startEnemyAction(String actionTileId) {
    final gameState = _gameRepo.gameState;
    if (gameState == null) {
      logger.error('Game state not found', tag: _tag);
      return;
    }

    var newGameState = gameState.copyWith();
    final actionTile = newGameState.tileMap.findTile(actionTileId);
    if (actionTile == null) {
      logger.error('Action tile not found: $actionTileId', tag: _tag);
      return;
    }

    if (_canMove(actionTile)) {
      final direction = newGameState.getValidDirectionToPlayer(actionTile);
      newGameState = newGameState.moveTile(actionTile, direction);
    }

    if (newGameState.isCloseToPlayer(actionTile)) {
      final DamageEvent? damageEvent;
      (newGameState, damageEvent) = newGameState.attackPlayer(actionTile);

      if (damageEvent != null) {
        final playerCoord = newGameState.playerTile?.coord;
        final attackEvent = AttackEvent(
          attackerId: actionTile.id,
          targetCoords: [playerCoord!],
        );

        _attackEventSubject.add(attackEvent);
        _damageEventSubject.add(damageEvent);
      }
    }

    _gameRepo.updateGameState(newGameState);

    _endAction();
  }

  void _endAction() {
    final oldGameState = _gameRepo.gameState;
    if (oldGameState == null) {
      logger.warning('Game state not found', tag: _tag);
      return;
    }

    logger.trace(
      'End action: ${oldGameState.actionTileId}',
      tag: _tag,
    );

    var newGameState = oldGameState.removeDeadTiles();
    final nextActionTileId = newGameState.findNextActionTileId();
    final isNextPlayerAction = nextActionTileId == newGameState.playerTileId;

    final oldTimeSec = newGameState.turnCount;
    final nextTurnCount = isNextPlayerAction ? oldTimeSec + 1 : oldTimeSec;
    newGameState = newGameState.copyWith(
      turnCount: nextTurnCount,
      actionTileId: nextActionTileId,
    );

    _gameRepo.updateGameState(newGameState);

    if (isNextPlayerAction) {
      logger.trace('New turn: $nextTurnCount', tag: _tag);
      _endTurn();
    }
  }

  void _endTurn() {
    final gameState = _gameRepo.gameState;
    if (gameState == null) {
      logger.warning('Game state not found', tag: _tag);
      return;
    }

    var newGameState = gameState.updateMoveCooldown();
    newGameState = newGameState.spawnEnemies();
    _gameRepo.updateGameState(newGameState);
  }

  void _createNewGame() {
    final player = Tile.createPlayer(
      _uuid.v4(),
      50,
      50,
    );

    final tileMap = TileMap(
      widthTileCount: 100,
      heightTileCount: 100,
      tiles: [player],
    );

    final gameState = GameState(
      turnCount: 0,
      killCount: 0,
      actionTileId: player.id,
      tileMap: tileMap,
    );

    _gameRepo.updateGameState(gameState);
  }

  static const _tag = 'GameService';

  static GameService create(BuildContext context) {
    return GameService(context.read());
  }
}
