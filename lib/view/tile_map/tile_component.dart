import 'package:flame/components.dart';

import '../../app/app_color.dart';
import '../../app/app_text.dart';
import '../../model/tile_map/tile.dart';
import 'tile_map_component.dart';

class TileComponent extends PositionComponent
    with HasAncestor<TileMapComponent> {
  TileComponent({
    required this.id,
    required this.posX,
    required this.posY,
  }) : super(
          anchor: Anchor.center,
        );

  factory TileComponent.fromTile(Tile tile) {
    // TODO: Tile decides its appearance

    final textComp = TextComponent(
      text: '@',
      textRenderer: TextPaint(
        style: AppText.h6.copyWith(color: AppColor.white87),
      ),
      anchor: Anchor.center,
    );

    final tileComp = TileComponent(
      id: tile.id,
      posX: tile.posX,
      posY: tile.posY,
    );

    tileComp.add(textComp);

    return tileComp;
  }

  final String id;
  int posX;
  int posY;

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
    x = (posX + 0.5) * tileSize.toDouble();
    y = (posY + 0.5) * tileSize.toDouble();
  }
}
