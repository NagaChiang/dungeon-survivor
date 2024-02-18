import 'package:flutter/widgets.dart';

import 'bar_layout.dart';
import 'button_panel.dart';

class HudLayout extends StatelessWidget {
  const HudLayout({
    super.key,
    required this.health,
    required this.maxHealth,
    required this.onInputDirection,
  });

  final int health;
  final int maxHealth;
  final InputDirectionCallback onInputDirection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          BarLayout(
            label: 'Health',
            health: health,
            maxHealth: maxHealth,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonPanel(onTap: onInputDirection),
            ],
          ),
        ],
      ),
    );
  }
}
