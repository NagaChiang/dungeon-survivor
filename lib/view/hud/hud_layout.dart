import 'package:flutter/widgets.dart';

import 'button_panel.dart';

class HudLayout extends StatelessWidget {
  const HudLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonPanel(),
          ],
        ),
      ],
    );
  }
}
