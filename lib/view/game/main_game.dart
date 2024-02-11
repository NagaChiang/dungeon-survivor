import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../tile/tile_map_component.dart';

class MainGame extends FlameGame {
  MainGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 32 * 10,
            height: 32 * 16,
          ),
        ) {
    final tileMap = TileMapComponent(
      widthTileCount: 100,
      heightTileCount: 100,
      tileSideLength: 32,
    );

    tile = tileMap.addTextTile(10, 10, '@');

    world.add(tileMap);
  }

  late PositionComponent tile;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.follow(tile);
  }
}
