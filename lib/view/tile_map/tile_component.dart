import 'package:flame/components.dart';

import 'tile_map_component.dart';

class TileComponent extends PositionComponent
    with HasAncestor<TileMapComponent> {
  TileComponent({
    required this.posX,
    required this.posY,
  }) {
    anchor = Anchor.center;
  }

  int posX;
  int posY;

  @override
  void update(double dt) {
    super.update(dt);

    _updatePosition();
  }

  void _updatePosition() {
    final tileSize = ancestor.tileSize;
    x = (posX + 0.5) * tileSize.toDouble();
    y = (posY + 0.5) * tileSize.toDouble();
  }
}
