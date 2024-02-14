import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../../app/app_color.dart';
import '../../app/app_text.dart';
import 'tile_component.dart';

class TileMapComponent extends PositionComponent {
  TileMapComponent({
    required this.widthTileCount,
    required this.heightTileCount,
    required this.tileSize,
  });

  final int widthTileCount;
  final int heightTileCount;
  final int tileSize;

  final _gridLinePaint = Paint()
    ..color = AppColor.white38
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;

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

  PositionComponent addTextTile(
    int posX,
    int posY,
    String str,
  ) {
    final text = TextComponent(
      text: str,
      textRenderer: TextPaint(
        style: AppText.h6.copyWith(color: AppColor.white87),
      ),
    );

    return addTile(posX, posY, text);
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
