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

    var newGameState = gameState.moveTile(playerTile, direction);

    _gameRepo.updateGameState(newGameState);

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

    var newGameState = gameState.copyWith();
    final actionTile = newGameState.tileMap.findTile(actionTileId);
    if (actionTile == null) {
      logger.error('Action tile not found: $actionTileId', tag: _tag);
      return;
    }

    if (!_canMove(actionTile)) {
      _endAction();
      return;
    }

    final direction = newGameState.getValidDirectionToPlayer(actionTile);
    newGameState = newGameState.moveTile(actionTile, direction);

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

    final oldTimeSec = oldGameState.turnCount;
    final nextTurnCount = isNextPlayerAction ? oldTimeSec + 1 : oldTimeSec;
    var newGameState = oldGameState.copyWith(
      turnCount: nextTurnCount,
      actionTileId: nextActionTileId,
    );

    if (newTile != null) {
      newGameState = newGameState.addOrUpdateTile(newTile);
    }

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
