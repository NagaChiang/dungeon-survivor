import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';

import '../tile_map/game_tile_map_component.dart';
import 'game_view_model.dart';

class MainGame extends FlameGame {
  MainGame()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: 32 * 10,
            height: 32 * 16,
          ),
        );

  late final GameViewModel _viewModel;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void onAttach() {
    super.onAttach();

    _viewModel = buildContext!.read();

    final tileMap = GameTileMapComponent(_viewModel);
    world.add(tileMap);
  }
}
