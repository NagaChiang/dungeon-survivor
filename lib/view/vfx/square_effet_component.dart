import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../app/app_color.dart';

class RectangleEffectComponent extends RectangleComponent {
  RectangleEffectComponent({
    super.position,
    super.size,
  }) : super(
          anchor: Anchor.center,
          paint: Paint()..color = AppColor.white54,
        ) {
    add(OpacityEffect.to(
      0.0,
      EffectController(duration: 0.5),
    ));

    add(RemoveEffect(delay: 0.5));
  }
}
