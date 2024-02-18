import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:rxdart/rxdart.dart';

import '../../app/app_color.dart';
import '../../model/tile_map/tile_map.dart';
import 'game_tile_component.dart';
import 'tile_component.dart';

class TileMapComponent extends PositionComponent {
  TileMapComponent({
    required this.widthTileCount,
    required this.heightTileCount,
    required this.tileSize,
  });

  factory TileMapComponent.fromTileMap(TileMap tileMap) {
    final comp = TileMapComponent(
      widthTileCount: tileMap.widthTileCount,
      heightTileCount: tileMap.heightTileCount,
      tileSize: 32,
    );

    comp.updateTileIdSet(tileMap.tileIdSet);

    return comp;
  }

  final int widthTileCount;
  final int heightTileCount;
  final int tileSize;
  final tileIdSet = <String>{};

  final _gridLinePaint = Paint()
    ..color = AppColor.white38
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final _tileCompMapSubject = BehaviorSubject<Map<String, TileComponent>>();
  late final tileCompMapStream = _tileCompMapSubject.stream;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    _renderGridLines(canvas);
  }

  Vector2 getTilePosition(int x, int y) {
    return Vector2(
      (x + 0.5) * tileSize.toDouble(),
      (y + 0.5) * tileSize.toDouble(),
    );
  }

  void registerTile(TileComponent tileComp) {
    final tileCompMap = _tileCompMapSubject.valueOrNull ?? {};
    tileCompMap[tileComp.id] = tileComp;
    _tileCompMapSubject.add(tileCompMap);
  }

  void unregisterTile(TileComponent tile) {
    final tileCompMap = _tileCompMapSubject.valueOrNull ?? {};
    tileCompMap.remove(tile.id);
    _tileCompMapSubject.add(tileCompMap);
  }

  void updateTileIdSet(Set<String> newIdSet) {
    final addedTileIds = newIdSet.difference(tileIdSet);
    for (final id in addedTileIds) {
      final tileComp = GameTileComponent(tileId: id);
      add(tileComp);
    }

    final removedTileIds = tileIdSet.difference(newIdSet);
    final tileCompMap = _tileCompMapSubject.valueOrNull ?? {};
    for (final id in removedTileIds) {
      final tileComp = tileCompMap[id];
      if (tileComp != null) {
        remove(tileComp);
      }
    }

    tileIdSet.clear();
    tileIdSet.addAll(newIdSet);
  }

  void _renderGridLines(Canvas canvas) {
    for (var i = 0; i <= widthTileCount; i++) {
      final x = i * tileSize;
      final y = heightTileCount * tileSize;
      canvas.drawLine(
        Offset(x.toDouble(), 0),
        Offset(x.toDouble(), y.toDouble()),
        _gridLinePaint,
      );
    }

    for (var i = 0; i <= heightTileCount; i++) {
      final x = widthTileCount * tileSize;
      final y = i * tileSize;
      canvas.drawLine(
        Offset(0, y.toDouble()),
        Offset(x.toDouble(), y.toDouble()),
        _gridLinePaint,
      );
    }
  }
}
