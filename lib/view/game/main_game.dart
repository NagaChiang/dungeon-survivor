import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';

import '../tile_map/tile_map_component.dart';
import 'game_view_model.dart';

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
      tileSize: 32,
    );

    tile = tileMap.addTextTile(10, 10, '@');

    world.add(tileMap);
  }

  late final GameViewModel viewModel;

  late PositionComponent tile;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    camera.follow(tile);
  }

  @override
  void onAttach() {
    super.onAttach();

    viewModel = buildContext!.read();
  }
}
