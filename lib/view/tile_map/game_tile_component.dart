import 'dart:async';

import 'package:flame/components.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../game/game_view_model.dart';
import 'tile_component.dart';

class GameTileComponent extends Component with HasGameRef {
  GameTileComponent({
    required this.tileId,
  });

  final String tileId;

  late final GameViewModel _viewModel;

  TileComponent? _tileComp;

  final _sub = CompositeSubscription();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _viewModel = gameRef.buildContext!.read();

    _subscribeTilePosition();
  }

  @override
  void onRemove() {
    _sub.clear();
    super.onRemove();
  }

  void _subscribeTilePosition() {
    _viewModel.getTileStream(tileId).listen((tile) {
      var comp = _tileComp;
      if (comp == null) {
        comp = TileComponent(
          posX: tile.posX,
          posY: tile.posY,
        );

        add(comp);
        _tileComp = comp;
      }

      comp.posX = tile.posX;
      comp.posY = tile.posY;
    }).addTo(_sub);
  }
}
