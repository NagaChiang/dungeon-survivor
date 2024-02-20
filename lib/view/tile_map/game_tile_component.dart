import 'package:flame/components.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../game/game_view_model.dart';
import '../vfx/explosion_paritcle_component.dart';
import '../vfx/popup_text_component.dart';
import 'tile_component.dart';

class GameTileComponent extends Component with HasGameRef {
  GameTileComponent({
    required this.id,
  });

  final String id;

  late final GameViewModel _viewModel;

  final _tileCompSubject = BehaviorSubject<TileComponent>();
  late final tileCompStream = _tileCompSubject.stream;

  final _sub = CompositeSubscription();

  @override
  void onLoad() {
    super.onLoad();

    _viewModel = gameRef.buildContext!.read();

    _subscribeTile();
    _subscribeDamageEvent();
  }

  @override
  void onRemove() {
    _spawnExplosion();

    _sub.clear();
    super.onRemove();
  }

  void _subscribeTile() {
    _viewModel.getTileStream(id).listen((tile) {
      var comp = _tileCompSubject.valueOrNull;
      if (comp == null) {
        comp = TileComponent.fromTile(tile);

        add(comp);
        _tileCompSubject.add(comp);
      }

      comp.tileX = tile.x;
      comp.tileY = tile.y;
    }).addTo(_sub);
  }

  void _subscribeDamageEvent() {
    CombineLatestStream.combine2(
      _tileCompSubject,
      _viewModel.getTileDamageEventStream(id),
      (comp, event) => (comp, event),
    ).listen((record) {
      final (comp, event) = record;
      final popupTextComp = PopupTextComponent(
        position: comp.position,
        text: event.damage.toString(),
      );

      game.world.add(popupTextComp);
    }).addTo(_sub);
  }

  void _spawnExplosion() {
    final comp = _tileCompSubject.valueOrNull;
    if (comp == null) {
      return;
    }

    final explosion = ExplosionParticleComponent(
      position: comp.position,
    );

    game.world.add(explosion);
  }
}
