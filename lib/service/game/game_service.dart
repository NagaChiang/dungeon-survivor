import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../app/app_color.dart';
import '../../common/logger.dart';
import '../../model/game/game_repository.dart';
import '../../model/game/game_state.dart';
import '../../model/tile_map/tile.dart';
import '../../model/tile_map/tile_map.dart';
import '../../model/unit/movable.dart';
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

    if (direction == Direction.stop) {
      _endAction();
      return;
    }

    _moveTile(playerTile, direction);
    _endAction();
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

  void _moveTile(Tile tile, Direction direction) {
    final oldGameState = _gameRepo.gameState;
    if (oldGameState == null) {
      logger.warning('Game state not found', tag: _tag);
      return;
    }

    final newX = tile.x + direction.dx;
    final newY = tile.y + direction.dy;
    final isBlocking = oldGameState.isBlockingAt(newX, newY);
    if (isBlocking) {
      return;
    }

    final newTile = tile.copyWith(x: newX, y: newY);
    final newGameState = oldGameState.copyWithTile(newTile);

    _gameRepo.updateGameState(newGameState);
  }

  void _subscribeActionTileId() {
    _gameRepo.actionTileIdStream.listen((actionTileId) {
      logger.trace('Start action: $actionTileId', tag: _tag);

      if (actionTileId == _gameRepo.gameState?.playerTileId) {
        return;
      }

      _startEnemyAction(actionTileId);
    }).addTo(_sub);
  }

  void _startEnemyAction(String actionTileId) {
    final gameState = _gameRepo.gameState;
    if (gameState == null) {
      logger.error('Game state not found', tag: _tag);
      return;
    }

    final actionTile = gameState.tileMap.findTile(actionTileId);
    if (actionTile == null) {
      logger.error('Action tile not found: $actionTileId', tag: _tag);
      return;
    }

    if (!_canMove(actionTile)) {
      _endAction();
      return;
    }

    final direction = gameState.getValidDirectionToPlayer(actionTile);

    _moveTile(actionTile, direction);
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

    final oldTile = oldGameState.findTile(oldGameState.actionTileId);
    final oldMovable = oldTile as Movable?;

    Tile? newTile;
    if (oldMovable != null) {
      var cooldown = oldMovable.moveCooldown;
      if (cooldown <= 0) {
        cooldown = oldMovable.maxMoveCooldown;
      }

      cooldown -= 1;
      switch (oldTile) {
        case (PlayerTile _):
          newTile = oldTile.copyWith(moveCooldown: cooldown);
          break;
        case (EnemyTile _):
          newTile = oldTile.copyWith(moveCooldown: cooldown);
          break;
        default:
          break;
      }
    }

    final nextActionTileId = oldGameState.findNextActionTileId();
    final isNextPlayerAction = nextActionTileId == oldGameState.playerTileId;

    final oldTimeSec = oldGameState.timeSec;
    final nextTimeSec = isNextPlayerAction ? oldTimeSec + 1 : oldTimeSec;
    var newGameState = oldGameState.copyWith(
      timeSec: nextTimeSec,
      actionTileId: nextActionTileId,
    );

    if (newTile != null) {
      newGameState = newGameState.copyWithTile(newTile);
    }

    if (isNextPlayerAction) {
      logger.trace('New time: $nextTimeSec', tag: _tag);
    }

    _gameRepo.updateGameState(newGameState);
  }

  void _createNewGame() {
    final player = Tile.player(
      id: _uuid.v4(),
      x: 50,
      y: 50,
      glyph: '@',
      colorValue: AppColor.white87.value,
      isBlocking: true,
      health: 100,
      maxHealth: 100,
      moveCooldown: 0,
      maxMoveCooldown: 1,
    );

    final rats = List.generate(
      10,
      (index) {
        return Tile.enemy(
          id: _uuid.v4(),
          x: 50 + index + 1,
          y: 50 + index + 1,
          glyph: 'r',
          colorValue: Colors.orangeAccent.value,
          isBlocking: true,
          health: 10,
          maxHealth: 10,
          moveCooldown: 0,
          maxMoveCooldown: 2,
        );
      },
    );

    final tileMap = TileMap(
      widthTileCount: 100,
      heightTileCount: 100,
      tiles: [player, ...rats],
    );

    final gameState = GameState(
      timeSec: 0,
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
