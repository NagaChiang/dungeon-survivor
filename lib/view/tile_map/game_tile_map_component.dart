import 'package:flame/components.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../game/game_view_model.dart';
import 'game_tile_component.dart';
import 'tile_map_component.dart';

class GameTileMapComponent extends Component with HasGameRef {
  late final GameViewModel _viewModel;

  TileMapComponent? _tileMapComp;

  final _tileCompMapSubject = BehaviorSubject<Map<String, GameTileComponent>>();
  late final tileCompMapStream = _tileCompMapSubject.stream;

  final _sub = CompositeSubscription();

  @override
  void onLoad() {
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
      var tileMapComp = _tileMapComp;
      if (tileMapComp == null) {
        tileMapComp = TileMapComponent.fromTileMap(tileMap);
        add(tileMapComp);

        _tileMapComp = tileMapComp;
        _tileCompMapSubject.addStream(tileMapComp.tileCompMapStream);
      }

      tileMapComp.updateTileIdSet(tileMap.tileIdSet);
    }).addTo(_sub);
  }
}
