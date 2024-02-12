import 'package:flutter/widgets.dart';

import 'button_panel.dart';

class HudLayout extends StatelessWidget {
  const HudLayout({
    super.key,
    required this.onInputDirection,
  });

  final InputDirectionCallback onInputDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonPanel(onTap: onInputDirection),
          ],
        ),
      ],
    );
  }
}
