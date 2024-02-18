import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/game/game_repository.dart';
import '../service/game/game_service.dart';
import '../view/game/game_view_model.dart';
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
      home: MultiProvider(
        providers: [
          Provider(create: (_) => GameRepository()),
        ],
        child: MultiProvider(
          providers: [
            Provider(
              create: GameService.create,
              dispose: (_, service) => service.dispose(),
            ),
          ],
          child: MultiProvider(
            providers: [
              Provider(create: GameViewModel.create),
            ],
            child: Material(
              child: GameWidget.controlled(
                gameFactory: MainGame.new,
                overlayBuilderMap: {
                  HudView.overlayName: (_, __) => const HudView(),
                },
                initialActiveOverlays: const [
                  HudView.overlayName,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
