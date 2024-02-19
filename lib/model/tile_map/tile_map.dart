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
  String? get playerTileId => playerTile?.id;
  int get tileCount => tiles.length;

  PlayerTile? get playerTile {
    return tiles.firstWhereOrNull((tile) => tile is PlayerTile) as PlayerTile?;
  }

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

  TileMap addOrUpdateTile(Tile tile) {
    var isUpdated = false;
    final newTiles = tiles.map(
      (t) {
        if (t.id == tile.id) {
          isUpdated = true;
          return tile;
        }

        return t;
      },
    ).toList();

    if (!isUpdated) {
      newTiles.add(tile);
    }

    return copyWith(tiles: newTiles);
  }

  TileMap removeTile(String id) {
    final newTiles = tiles.where((t) => t.id != id).toList();
    return copyWith(tiles: newTiles);
  }

  TileMap moveTile(Tile tile, Direction direction) {
    final isExist = tiles.any((t) => t.id == tile.id);
    if (!isExist) {
      return this;
    }

    final newX = tile.x + direction.dx;
    final newY = tile.y + direction.dy;
    final isBlocking = isBlockingAt(newX, newY);
    if (isBlocking) {
      return this;
    }

    final newTile = tile.copyWith(x: newX, y: newY);

    return addOrUpdateTile(newTile);
  }

  Direction getValidDirectionToPlayer(Tile tile) {
    final playerTile = this.playerTile;
    if (playerTile == null) {
      return Direction.stop;
    }

    return getValidDirectionTo(tile, playerTile);
  }

  Direction getValidDirectionTo(Tile fromTile, Tile toTile) {
    final coords = Direction.values
        .where(
          (d) => d != Direction.stop,
        )
        .map((dir) => (fromTile.x + dir.dx, fromTile.y + dir.dy))
        .sortedByCompare(
          (coord) => (toTile.x - coord.$1).abs() + (toTile.y - coord.$2).abs(),
          (a, b) => a.compareTo(b),
        )
        .where(
          (coord) => !isBlockingAt(coord.$1, coord.$2),
        );

    final coord = coords.firstOrNull;
    if (coord != null) {
      final dx = coord.$1 - fromTile.x;
      final dy = coord.$2 - fromTile.y;
      return Direction.fromDelta(dx, dy);
    }

    return Direction.stop;
  }

  bool isCloseToTile(Tile fromTile, Tile toTile) {
    final coordSet = <(int, int)>{};
    for (int x = -1; x <= 1; x++) {
      for (int y = -1; y <= 1; y++) {
        if (x == 0 && y == 0) {
          continue;
        }

        coordSet.add((toTile.x + x, toTile.y + y));
      }
    }

    return coordSet.contains((fromTile.x, fromTile.y));
  }
}
