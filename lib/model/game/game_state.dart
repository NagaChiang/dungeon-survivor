import 'package:freezed_annotation/freezed_annotation.dart';

import '../tile_map/tile.dart';
import '../tile_map/tile_map.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

@freezed
class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    required TileMap tileMap,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  PlayerTile? findPlayerTile() => tileMap.findPlayerTile();
  List<Tile> getTilesAt(int x, int y) => tileMap.getTilesAt(x, y);
  bool isBlockingAt(int x, int y) => tileMap.isBlockingAt(x, y);

  GameState copyWithTile(Tile tile) {
    final newTileMap = tileMap.copyWithTile(tile);
    return copyWith(tileMap: newTileMap);
  }
}
