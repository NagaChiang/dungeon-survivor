import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';

class MapComponent extends PositionComponent {
  late TiledComponent _tiledComponent;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initTiledComponent();
  }

  Future<void> _initTiledComponent() async {
    const width = 10;
    const height = 10;
    const tileSize = 32;

    final tileset = Tileset(
      firstGid: 0,
      tileWidth: tileSize,
      tileHeight: tileSize,
      tiles: [],
    );

    final objectGroup = ObjectGroup(
      name: 'unit',
      objects: [
        TiledObject(
          id: 0,
          width: tileSize.toDouble(),
          height: tileSize.toDouble(),
          x: 10,
          y: 3,
        ),
      ],
    );

    final tiledMap = TiledMap(
      width: width,
      height: height,
      tileWidth: tileSize,
      tileHeight: tileSize,
      tilesets: [tileset],
      layers: [objectGroup],
    );

    final renderableTiledMap = await RenderableTiledMap.fromTiledMap(
      tiledMap,
      Vector2.all(tileSize.toDouble()),
    );

    _tiledComponent = TiledComponent(renderableTiledMap);

    add(_tiledComponent);

    for (final object in objectGroup.objects) {
      final unit = CircleComponent(
        position: Vector2(object.x, object.y),
        radius: tileSize / 2,
        paint: BasicPalette.white.paint(),
      );

      add(unit);
    }
  }
}
