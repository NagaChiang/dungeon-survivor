import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../app/app_color.dart';
import '../../app/app_text.dart';
import 'tile_component.dart';

class TileMapComponent extends PositionComponent {
  TileMapComponent({
    required this.widthTileCount,
    required this.heightTileCount,
    required this.tileSideLength,
  });

  final int widthTileCount;
  final int heightTileCount;
  final int tileSideLength;

  final _gridLinePaint = Paint()
    ..color = AppColor.white38
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final tile = TileComponent(xIndex: 10, yIndex: 10);
    final text = TextComponent(
      text: '@',
      textRenderer: TextPaint(
        style: AppText.h6.copyWith(color: AppColor.white87),
      ),
    )..anchor = Anchor.center;

    tile.add(text);
    add(tile);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    _renderGridLines(canvas);
  }

  void _renderGridLines(Canvas canvas) {
    for (var i = 0; i <= widthTileCount; i++) {
      final x = i * tileSideLength;
      final y = heightTileCount * tileSideLength;
      canvas.drawLine(
        Offset(x.toDouble(), 0),
        Offset(x.toDouble(), y.toDouble()),
        _gridLinePaint,
      );
    }

    for (var i = 0; i <= heightTileCount; i++) {
      final x = widthTileCount * tileSideLength;
      final y = i * tileSideLength;
      canvas.drawLine(
        Offset(0, y.toDouble()),
        Offset(x.toDouble(), y.toDouble()),
        _gridLinePaint,
      );
    }
  }
}
