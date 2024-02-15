import 'dart:async';

import 'package:flame/components.dart';
import 'package:rxdart/rxdart.dart';

import '../game/game_view_model.dart';
import 'tile_map_component.dart';

class GameTileMapComponent extends PositionComponent {
  GameTileMapComponent(this._viewModel);

  final GameViewModel _viewModel;

  TileMapComponent? _tileMapComp;

  final _compositeSub = CompositeSubscription();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _subscribeTileMap();
  }

  @override
  void onRemove() {
    _compositeSub.clear();
    super.onRemove();
  }

  void _subscribeTileMap() {
    _viewModel.tileMapStream.listen((tileMap) {
      if (_tileMapComp == null) {
        final comp = TileMapComponent(
          widthTileCount: tileMap.widthTileCount,
          heightTileCount: tileMap.heightTileCount,
          tileSize: 32,
        );

        add(comp);
        _tileMapComp = comp;
      }
    }).addTo(_compositeSub);
  }
}
