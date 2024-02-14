import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../service/game/game_service.dart';

class GameViewModel {
  GameViewModel(this._gameService);

  final GameService _gameService;

  static GameViewModel create(BuildContext context) {
    return GameViewModel(context.read());
  }
}
