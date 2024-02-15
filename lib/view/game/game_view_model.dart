import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../model/tile_map/tile_map.dart';
import '../../service/game/game_service.dart';

class GameViewModel {
  GameViewModel(this._gameService);

  final GameService _gameService;

  Stream<TileMap> get tileMapStream => _gameService.tileMapStream;

  static GameViewModel create(BuildContext context) {
    return GameViewModel(context.read());
  }
}
