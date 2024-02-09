import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dungeon Survivor',
      debugShowCheckedModeBanner: false,
      home: Material(
        child: Placeholder(),
      ),
    );
  }
}
