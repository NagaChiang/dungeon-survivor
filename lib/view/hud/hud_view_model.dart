import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../service/game/game_service.dart';
import '../../service/game/input_direction.dart';

class HudViewModel extends ChangeNotifier {
  HudViewModel(this._gameService);

  final GameService _gameService;

  void onInputDirection(InputDirection direction) {
    _gameService.onInputDirection(direction);
  }

  static HudViewModel create(BuildContext context) {
    return HudViewModel(context.read());
  }
}
