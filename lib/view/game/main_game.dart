import 'dart:async';

import 'package:flame/game.dart';

import '../map/map_component.dart';

class MainGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    final map = MapComponent();
    add(map);
  }
}
