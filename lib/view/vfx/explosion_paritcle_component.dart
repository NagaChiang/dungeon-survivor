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
        final speedX = random.nextDouble() * 2 * particleSpeed - particleSpeed;
        final speedY = random.nextDouble() * 2 * particleSpeed - particleSpeed;
        final accX = -speedX / particleLifespan;
        final accY = -speedY / particleLifespan;

        return AcceleratedParticle(
          speed: Vector2(speedX, speedY),
          acceleration: Vector2(accX, accY),
          child: CircleParticle(
            radius: 1,
            paint: Paint()..color = AppColor.health,
          ),
        );
      },
    );
  }

  static const particleLifespan = 1.0;
  static const particleSpeed = 100.0;
}
