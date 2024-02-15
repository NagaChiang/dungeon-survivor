import 'package:rxdart/rxdart.dart';

import '../tile_map/tile.dart';
import '../tile_map/tile_map.dart';
import 'game_state.dart';

class GameRepository {
  final _gameStateSubject = BehaviorSubject<GameState>();
  late final gameStateStream = _gameStateSubject.stream;

  void init() {
    // TODO: Load game state from storage first

    createNewGame();
  }

  void createNewGame() {
    const player = Tile.player(
      posX: 50,
      posY: 50,
      health: 100,
      maxHealth: 100,
    );

    const tileMap = TileMap(
      widthTileCount: 100,
      heightTileCount: 100,
      tiles: [player],
    );

    const gameState = GameState(tileMap: tileMap);

    _gameStateSubject.add(gameState);
  }
}
