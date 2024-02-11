import 'package:flame/components.dart';

import 'tile_map_component.dart';

class TileComponent extends PositionComponent
    with HasAncestor<TileMapComponent> {
  TileComponent({
    required this.xIndex,
    required this.yIndex,
  }) {
    anchor = Anchor.center;
  }

  int xIndex;
  int yIndex;

  @override
  void update(double dt) {
    super.update(dt);

    _updatePosition();
  }

  void _updatePosition() {
    final tileSideLength = ancestor.tileSideLength;
    x = (xIndex + 0.5) * tileSideLength.toDouble();
    y = (yIndex + 0.5) * tileSideLength.toDouble();
  }
}
