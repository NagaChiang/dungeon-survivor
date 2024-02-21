import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../service/game/direction.dart';
import '../../service/game/game_service.dart';

class HudViewModel extends ChangeNotifier {
  HudViewModel(this._gameService) {
    _subscribeHealth();
    _subscribeKillCount();
  }

  final GameService _gameService;

  var _health = 0;
  int get health => _health;

  var _maxHealth = 0;
  int get maxHealth => _maxHealth;

  var _killCount = 0;
  int get killCount => _killCount;

  final _sub = CompositeSubscription();

  @override
  void dispose() {
    _sub.clear();
    super.dispose();
  }

  void onInputDirection(Direction direction) {
    _gameService.onInputDirection(direction);
  }

  void _subscribeHealth() {
    _gameService.playerTileStream.listen((tile) {
      _health = tile.health;
      _maxHealth = tile.maxHealth;

      notifyListeners();
    }).addTo(_sub);
  }

  void _subscribeKillCount() {
    _gameService.killCountStream.listen((killCount) {
      _killCount = killCount;
      notifyListeners();
    }).addTo(_sub);
  }

  static HudViewModel create(BuildContext context) {
    return HudViewModel(context.read());
  }
}
