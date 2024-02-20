import 'package:flame/components.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../game/game_view_model.dart';
import '../vfx/square_effet_component.dart';
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
    _subscribeAttackEvent();
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

  void _subscribeAttackEvent() {
    _viewModel.attackEventStream.listen((event) {
      final tileMapComp = _tileMapComp;
      if (tileMapComp == null) {
        return;
      }

      for (final coord in event.targetCoords) {
        final pos = tileMapComp.getTilePosition(coord.$1, coord.$2);
        final comp = RectangleEffectComponent(
          position: pos,
          size: Vector2.all(tileMapComp.tileSize.toDouble()),
        );

        game.world.add(comp);
      }
    }).addTo(_sub);
  }
}
