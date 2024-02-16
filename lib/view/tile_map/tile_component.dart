import 'package:flame/components.dart';

import '../../app/app_text.dart';
import '../../model/tile_map/tile.dart';
import 'tile_map_component.dart';

class TileComponent extends PositionComponent
    with HasAncestor<TileMapComponent> {
  TileComponent({
    required this.id,
    required this.tileX,
    required this.tileY,
  }) : super(
          anchor: Anchor.center,
        );

  factory TileComponent.fromTile(Tile tile) {
    // TODO: Tile decides its appearance

    final textComp = TextComponent(
      text: tile.glyph,
      textRenderer: TextPaint(
        style: AppText.h6.copyWith(color: tile.color),
      ),
      anchor: Anchor.center,
    );

    final tileComp = TileComponent(
      id: tile.id,
      tileX: tile.x,
      tileY: tile.y,
    );

    tileComp.add(textComp);

    return tileComp;
  }

  final String id;
  int tileX;
  int tileY;

  @override
  void onMount() {
    super.onMount();
    ancestor.registerTile(this);
  }

  @override
  void onRemove() {
    ancestor.unregisterTile(this);
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updatePosition();
  }

  void _updatePosition() {
    final tileSize = ancestor.tileSize;
    x = (tileX + 0.5) * tileSize.toDouble();
    y = (tileY + 0.5) * tileSize.toDouble();
  }
}
