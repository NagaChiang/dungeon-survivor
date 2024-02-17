import 'package:freezed_annotation/freezed_annotation.dart';

import '../../service/game/direction.dart';
import '../tile_map/tile.dart';
import '../tile_map/tile_map.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required int timeSec,
    required String actionTileId,
    required TileMap tileMap,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  bool get isPlayerAction => actionTileId == playerTileId;

  // Proxy methods
  PlayerTile? get playerTile => tileMap.playerTile;
  String? get playerTileId => tileMap.playerTileId;
  List<Tile> getTilesAt(int x, int y) => tileMap.getTilesAt(x, y);
  bool isBlockingAt(int x, int y) => tileMap.isBlockingAt(x, y);

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

  GameState copyWithTile(Tile tile) {
    final newTileMap = tileMap.copyWithTile(tile);
    return copyWith(tileMap: newTileMap);
  }
}
