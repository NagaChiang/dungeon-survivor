import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../service/game/direction.dart';
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

  PlayerTile? get playerTile {
    return tiles.firstWhereOrNull((tile) => tile is PlayerTile) as PlayerTile?;
  }

  String? get playerTileId => playerTile?.id;

  Tile? findTile(String id) {
    return tiles.firstWhereOrNull((tile) => tile.id == id);
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

  Direction getValidDirectionToPlayer(Tile tile) {
    final playerTile = this.playerTile;
    if (playerTile == null) {
      return Direction.stop;
    }

    return getValidDirectionTo(tile, playerTile);
  }

  Direction getValidDirectionTo(Tile fromTile, Tile toTile) {
    final dx = toTile.x - fromTile.x;
    final dy = toTile.y - fromTile.y;

    if (dx == 0 && dy == 0) {
      return Direction.stop;
    }

    final xDir = Direction.fromXY(dx, 0);
    final xTileX = fromTile.x + xDir.dx;
    final xTileY = fromTile.y + xDir.dy;
    final xIsBlocking = isBlockingAt(xTileX, xTileY);

    final yDir = Direction.fromXY(0, dy);
    final yTileX = fromTile.x + yDir.dx;
    final yTileY = fromTile.y + yDir.dy;
    final yIsBlocking = isBlockingAt(yTileX, yTileY);

    if (dx.abs() > dy.abs() && !xIsBlocking) {
      return xDir;
    }

    if (!yIsBlocking) {
      return yDir;
    }

    return Direction.stop;
  }
}
