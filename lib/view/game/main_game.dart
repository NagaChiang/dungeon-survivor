import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

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
  late final GameTileMapComponent _tileMapComp;

  final _sub = CompositeSubscription();

  @override
  void onAttach() {
    super.onAttach();

    _viewModel = buildContext!.read();

    _createTileMap();

    _subscribeFollowPlayer();
  }

  void _createTileMap() {
    _tileMapComp = GameTileMapComponent();
    world.add(_tileMapComp);
  }

  void _subscribeFollowPlayer() {
    CombineLatestStream.combine2(
      _viewModel.playerTileIdStream,
      _tileMapComp.tileCompMapStream,
      (playerTileId, tileCompMap) => tileCompMap[playerTileId],
    ).whereNotNull().flatMap((gameTile) => gameTile.tileCompStream).listen(
      (tileComp) {
        camera.follow(tileComp, snap: true);
      },
    ).addTo(_sub);
  }
}
