import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/tile_map/tile.dart';
import '../../model/tile_map/tile_map.dart';
import '../../service/event/attack_event.dart';
import '../../service/event/damage_event.dart';
import '../../service/game/game_service.dart';

class GameViewModel {
  GameViewModel(this._gameService);

  final GameService _gameService;

  Stream<TileMap> get tileMapStream => _gameService.tileMapStream;
  Stream<Tile> get playerTileStream => _gameService.playerTileStream;
  Stream<String> get playerTileIdStream => _gameService.playerTileIdStream;
  Stream<AttackEvent> get attackEventStream => _gameService.attackEventStream;
  Stream<DamageEvent> get damageEventStream => _gameService.damageEventStream;

  Stream<DamageEvent> get playerDamagedStream {
    return CombineLatestStream.combine2(
      damageEventStream,
      playerTileIdStream,
      (event, playerId) => (event, playerId),
    ).mapNotNull(
      (record) {
        final (event, playerId) = record;
        if (event.defenderId == playerId) {
          return event;
        } else {
          return null;
        }
      },
    );
  }

  Stream<Tile> getTileStream(String id) {
    return _gameService.getTileStream(id);
  }

  static GameViewModel create(BuildContext context) {
    return GameViewModel(context.read());
  }
}
