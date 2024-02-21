import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';

import '../../app/app_color.dart';

class ExplosionParticleComponent extends ParticleSystemComponent {
  ExplosionParticleComponent({
    super.position,
  }) : super(anchor: Anchor.center) {
    final random = Random();

    particle = Particle.generate(
      count: 50,
      lifespan: particleLifespan,
      generator: (_) {
        final radianX = random.nextDouble() * 2 * pi;
        final radianY = random.nextDouble() * 2 * pi;
        final speedX = particleSpeed * cos(radianX);
        final speedY = particleSpeed * sin(radianY);
        final accX = -speedX / particleLifespan;
        final accY = -speedY / particleLifespan;
        final radius = random.nextDouble() * 2 + 1;

        return AcceleratedParticle(
          speed: Vector2(speedX, speedY),
          acceleration: Vector2(accX, accY),
          child: ScalingParticle(
            to: 0.1,
            child: CircleParticle(
              radius: radius,
              paint: Paint()..color = AppColor.health,
            ),
          ),
        );
      },
    );
  }

  static const particleLifespan = 0.6;
  static const particleSpeed = 200.0;
}
