import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:rxdart/rxdart.dart';

import '../../app/app_color.dart';
import '../../common/logger.dart';
import 'tile_component.dart';

class TileMapComponent extends PositionComponent {
  TileMapComponent({
    required this.widthTileCount,
    required this.heightTileCount,
    required this.tileSize,
    required this.tileIds,
  });

  final int widthTileCount;
  final int heightTileCount;
  final int tileSize;
  final List<String> tileIds;

  final _gridLinePaint = Paint()
    ..color = AppColor.white38
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  final _tilesSubject = BehaviorSubject<List<TileComponent>>();
  late final tilesStream = _tilesSubject.stream;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    _renderGridLines(canvas);
  }

  void registerTile(TileComponent tile) {
    logger.trace('registerTile: $tile', tag: _tag);

    final tiles = _tilesSubject.valueOrNull ?? [];
    tiles.add(tile);
    _tilesSubject.add(tiles);
  }

  void unregisterTile(TileComponent tile) {
    logger.trace('unregisterTile: $tile', tag: _tag);

    final tiles = _tilesSubject.valueOrNull ?? [];
    tiles.remove(tile);
    _tilesSubject.add(tiles);
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

  static const _tag = 'TileMapComponent';
}
