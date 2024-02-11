import 'dart:async';

import 'package:flame/game.dart';

import '../tile/tile_map_component.dart';

class MainGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final tileMap = TileMapComponent(
      widthTileCount: 100,
      heightTileCount: 100,
      tileSideLength: 32,
    );

    final text = tileMap.addTextTile(10, 10, '@');

    add(tileMap);

    camera.follow(text);
  }
}
