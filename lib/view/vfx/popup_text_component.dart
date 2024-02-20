import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';

import '../../app/app_color.dart';
import '../../app/app_text.dart';

class PopupTextComponent extends TextComponent {
  PopupTextComponent({
    super.position,
    super.text,
  }) : super(
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: AppText.h6.copyWith(color: AppColor.white70),
          ),
        ) {
    final random = Random();
    final dx = random.nextDouble() * offsetLength - (offsetLength / 2);

    add(
      MoveEffect.by(
        Vector2(dx, -offsetLength),
        EffectController(duration: 0.5, curve: Curves.easeInOutSine),
      ),
    );

    add(
      ScaleEffect.to(
        Vector2(0.5, 0.5),
        EffectController(duration: 0.5, curve: Curves.easeInOutSine),
      ),
    );

    add(RemoveEffect(delay: 0.5));
  }

  static const double offsetLength = 16;
}
