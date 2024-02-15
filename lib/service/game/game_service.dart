import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../common/logger.dart';
import '../../model/game/game_repository.dart';
import '../../model/tile_map/tile_map.dart';
import 'input_direction.dart';

class GameService {
  GameService(this._gameRepo);

  final GameRepository _gameRepo;

  Stream<TileMap> get tileMapStream => _gameRepo.tileMapStream;

  void onInputDirection(InputDirection direction) {
    logger.trace('Input direction: ${direction.name}', tag: _tag);
  }

  static const _tag = 'GameService';

  static GameService create(BuildContext context) {
    return GameService(context.read());
  }
}
