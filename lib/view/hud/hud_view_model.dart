import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../service/game/game_service.dart';

class HudViewModel extends ChangeNotifier {
  HudViewModel(this._gameService);

  final GameService _gameService;

  static HudViewModel create(BuildContext context) {
    return HudViewModel(context.read());
  }
}
