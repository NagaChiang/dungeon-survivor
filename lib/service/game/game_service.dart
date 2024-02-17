import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app/app_color.dart';
import '../../common/logger.dart';
import '../../model/game/game_repository.dart';
import '../../model/game/game_state.dart';
import '../../model/tile_map/tile.dart';
import '../../model/tile_map/tile_map.dart';
import 'input_direction.dart';

class GameService {
  GameService(this._gameRepo) {
    _createNewGame();
  }

  final GameRepository _gameRepo;

  Stream<TileMap> get tileMapStream => _gameRepo.tileMapStream;
  Stream<PlayerTile> get playerTileStream => _gameRepo.playerTileStream;
  Stream<String> get playerTileIdStream => _gameRepo.playerTileIdStream;

  final _uuid = const Uuid();

  Stream<Tile> getTileStream(String id) {
    return _gameRepo.getTileStream(id);
  }

  void onInputDirection(InputDirection direction) {
    logger.trace('Input direction: ${direction.name}', tag: _tag);
  }

  void _createNewGame() {
    final player = Tile.player(
      id: _uuid.v4(),
      glyph: '@',
      colorValue: AppColor.white87.value,
      x: 50,
      y: 50,
      health: 100,
      maxHealth: 100,
    );

    final rats = List.generate(
      10,
      (index) => Tile.enemy(
        id: _uuid.v4(),
        glyph: 'r',
        colorValue: Colors.orangeAccent.value,
        x: 50 + index + 1,
        y: 50 + index + 1,
        health: 10,
        maxHealth: 10,
      ),
    );

    final tileMap = TileMap(
      widthTileCount: 100,
      heightTileCount: 100,
      tiles: [player, ...rats],
    );

    final gameState = GameState(tileMap: tileMap);
    _gameRepo.updateGameState(gameState);
  }

  static const _tag = 'GameService';

  static GameService create(BuildContext context) {
    return GameService(context.read());
  }
}
