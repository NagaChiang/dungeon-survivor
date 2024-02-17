import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'tile.dart';

part 'tile_map.freezed.dart';
part 'tile_map.g.dart';

@freezed
class TileMap with _$TileMap {
  const TileMap._();

  const factory TileMap({
    required int widthTileCount,
    required int heightTileCount,
    required List<Tile> tiles,
  }) = _TileMap;

  factory TileMap.fromJson(Map<String, dynamic> json) =>
      _$TileMapFromJson(json);

  Set<String> get tileIdSet => tiles.map((tile) => tile.id).toSet();

  Tile? findTile(String id) {
    return tiles.firstWhereOrNull((tile) => tile.id == id);
  }

  PlayerTile? findPlayerTile() {
    return tiles.firstWhereOrNull((tile) => tile is PlayerTile) as PlayerTile?;
  }

  List<Tile> getTilesAt(int x, int y) {
    return tiles.where((tile) => tile.x == x && tile.y == y).toList();
  }

  bool isBlockingAt(int x, int y) {
    if (!isValidPosition(x, y)) {
      return true;
    }

    return getTilesAt(x, y).any((tile) => tile.isBlocking);
  }

  bool isValidPosition(int x, int y) {
    return x >= 0 && x < widthTileCount && y >= 0 && y < heightTileCount;
  }

  TileMap copyWithTile(Tile tile) {
    final newTiles = tiles.map(
      (t) {
        if (t.id == tile.id) {
          return tile;
        }

        return t;
      },
    ).toList();

    return copyWith(tiles: newTiles);
  }
}
