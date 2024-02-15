import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../model/game/game_repository.dart';
import 'input_direction.dart';

class GameService {
  GameService(this._gameRepo);

  final GameRepository _gameRepo;

  void onInputDirection(InputDirection direction) {}

  static GameService create(BuildContext context) {
    return GameService(context.read());
  }
}
