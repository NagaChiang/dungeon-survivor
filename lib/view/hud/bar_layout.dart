import 'package:flutter/material.dart';

import '../../app/app_color.dart';
import '../../app/app_text.dart';

class BarLayout extends StatelessWidget {
  const BarLayout({
    super.key,
    required this.label,
    required this.health,
    required this.maxHealth,
  });

  final String label;
  final int health;
  final int maxHealth;

  @override
  Widget build(BuildContext context) {
    final healthWidthFactor = health / maxHealth;

    return Row(
      children: [
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: AppText.body2.copyWith(
              color: AppColor.white87,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 16,
            child: Stack(
              children: [
                if (healthWidthFactor > 0)
                  FractionallySizedBox(
                    widthFactor: healthWidthFactor,
                    child: Container(color: AppColor.health),
                  ),
                Container(
                  padding: const EdgeInsets.only(right: 4),
                  alignment: Alignment.centerRight,
                  child: Text(
                    '$health / $maxHealth',
                    style: AppText.body2.copyWith(
                      color: AppColor.white87,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
