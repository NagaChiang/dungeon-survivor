import 'dart:ui';

import 'package:flame/components.dart';

import '../../app/app_color.dart';

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
