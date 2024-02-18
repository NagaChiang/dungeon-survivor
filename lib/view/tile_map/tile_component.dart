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
    final textComp = TextComponent(
      text: tile.glyph,
      textRenderer: TextPaint(
        style: AppText.h6.copyWith(color: tile.color),
      ),
      anchor: Anchor.center,
      position: Vector2(0, -2),
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

    final targetPos = ancestor.getTilePosition(tileX, tileY);
    position.setFrom(targetPos);

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
    _updatePosition(dt);
  }

  void _updatePosition(double dt) {
    final targetPos = ancestor.getTilePosition(tileX, tileY);
    final t = (dt * _moveSpeed).clamp(0.0, 1.0);
    position.lerp(targetPos, t);
  }

  static const _moveSpeed = 20.0;
}
