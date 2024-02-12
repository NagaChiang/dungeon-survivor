import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../view/game/main_game.dart';
import '../view/hud/hud_view.dart';
import 'app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dungeon Survivor',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: GameWidget.controlled(
        gameFactory: MainGame.new,
        overlayBuilderMap: {
          HudView.overlayName: (_, __) => const HudView(),
        },
        initialActiveOverlays: const [
          HudView.overlayName,
        ],
      ),
    );
  }
}
