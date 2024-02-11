import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../view/game/main_game.dart';
import '../view/game/game_screen.dart';
import 'app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dungeon Survivor',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const Material(
        child: Stack(
          children: [
            GameWidget.controlled(gameFactory: MainGame.new),
            GameScreen(),
          ],
        ),
      ),
    );
  }
}
