import 'package:flutter/widgets.dart';

import '../../app/app_color.dart';
import '../../app/app_text.dart';
import 'bar_layout.dart';
import 'button_panel.dart';

class HudLayout extends StatelessWidget {
  const HudLayout({
    super.key,
    required this.health,
    required this.maxHealth,
    required this.killCount,
    required this.onInputDirection,
  });

  final int health;
  final int maxHealth;
  final int killCount;
  final InputDirectionCallback onInputDirection;

  @override
  Widget build(BuildContext context) {
    final killCountStyle = AppText.body2.copyWith(color: AppColor.white87);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BarLayout(
            label: 'Health',
            health: health,
            maxHealth: maxHealth,
          ),
          Text('Kills: $killCount', style: killCountStyle),
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
