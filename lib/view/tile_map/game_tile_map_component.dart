import 'package:flame/components.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../game/game_view_model.dart';
import 'game_tile_component.dart';
import 'tile_component.dart';
import 'tile_map_component.dart';

class GameTileMapComponent extends Component with HasGameRef {
  late final GameViewModel _viewModel;

  TileMapComponent? _tileMapComp;

  final _tilesSubject = BehaviorSubject<List<TileComponent>>();
  late final tilesStream = _tilesSubject.stream;

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
      var comp = _tileMapComp;
      if (comp == null) {
        comp = TileMapComponent(
          widthTileCount: tileMap.widthTileCount,
          heightTileCount: tileMap.heightTileCount,
          tileSize: 32,
          tileIds: tileMap.tileIds,
        );

        add(comp);
        _tileMapComp = comp;

        _tilesSubject.addStream(comp.tilesStream);
      }

      for (final tileId in tileMap.tileIds) {
        final tileComp = GameTileComponent(tileId: tileId);
        comp.add(tileComp);
      }

      // TODO: Update tile map component
    }).addTo(_sub);
  }
}
