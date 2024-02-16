import 'dart:async';

import 'package:flame/components.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../game/game_view_model.dart';
import 'tile_map_component.dart';

class GameTileMapComponent extends Component with HasGameRef {
  late final GameViewModel _viewModel;

  TileMapComponent? _tileMapComp;

  final _sub = CompositeSubscription();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _viewModel = gameRef.buildContext!.read();

    _subscribeTileMap();
  }

  @override
  void onRemove() {
    _sub.clear();
    super.onRemove();
  }

  void _subscribeTileMap() {
    _viewModel.tileMapStream.listen((tileMap) {
      if (_tileMapComp == null) {
        final comp = TileMapComponent(
          widthTileCount: tileMap.widthTileCount,
          heightTileCount: tileMap.heightTileCount,
          tileSize: 32,
          tileIds: tileMap.tileIds,
        );

        add(comp);
        _tileMapComp = comp;
      } else {
        // TODO: Update tile map component
      }
    }).addTo(_sub);
  }
}
