import 'package:rxdart/rxdart.dart';

import '../tile_map/tile.dart';
import 'game_state.dart';

class GameRepository {
  final _gameStateSubject = BehaviorSubject<GameState>();
  late final gameStateStream = _gameStateSubject.stream;

  late final tileMapStream = gameStateStream.map(
    (gameState) => gameState.tileMap,
  );

  late final playerTileStream = tileMapStream
      .map(
        (tileMap) => tileMap.playerTile,
      )
      .whereNotNull()
      .distinct();

  late final playerTileIdStream = playerTileStream
      .map(
        (playerTile) => playerTile.id,
      )
      .distinct();

  late final actionTileIdStream = gameStateStream
      .map(
        (gameState) => gameState.actionTileId,
      )
      .distinct();

  GameState? get gameState => _gameStateSubject.valueOrNull;

  void updateGameState(GameState gameState) {
    _gameStateSubject.add(gameState);
  }

  Stream<Tile> getTileStream(String id) {
    return tileMapStream
        .map(
          (tileMap) => tileMap.findTile(id),
        )
        .whereNotNull()
        .distinct();
  }
}
