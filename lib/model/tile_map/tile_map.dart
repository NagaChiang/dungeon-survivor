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

  List<String> get tileIds => tiles.map((tile) => tile.id).toList();

  Tile? findTile(String id) {
    return tiles.firstWhereOrNull((tile) => tile.id == id);
  }

  PlayerTile? findPlayerTile() {
    return tiles.firstWhereOrNull((tile) => tile is PlayerTile) as PlayerTile?;
  }
}
