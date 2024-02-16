import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../app/app_color.dart';
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

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    _renderGridLines(canvas);
  }

  PositionComponent addTile(
    int posX,
    int posY,
    PositionComponent component,
  ) {
    final tile = TileComponent(posX: posX, posY: posY);
    component.anchor = Anchor.center;
    tile.add(component);
    add(tile);

    return tile;
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
