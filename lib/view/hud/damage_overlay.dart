import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../app/app_color.dart';
import '../game/game_view_model.dart';

class DamageOverlay extends StatefulWidget {
  const DamageOverlay({super.key});

  @override
  State<DamageOverlay> createState() => _DamageOverlayState();

  static const String overlayName = 'damage';
}

class _DamageOverlayState extends State<DamageOverlay>
    with TickerProviderStateMixin {
  late final _viewModel = context.read<GameViewModel>();

  late final _fadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  late final _fadeAnimation = Tween<double>(
    begin: 1.0,
    end: 0.0,
  ).animate(_fadeController);

  final _sub = CompositeSubscription();

  @override
  void initState() {
    super.initState();

    _fadeController.value = 1.0;

    _subscribePlayerDamagedEvent();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 1.2,
              colors: [
                Colors.transparent,
                AppColor.health,
              ],
              stops: [0.1, 1],
            ),
          ),
        ),
      ),
    );
  }

  void _subscribePlayerDamagedEvent() {
    _viewModel.playerDamagedStream.listen((event) {
      _fadeController.reset();
      _fadeController.forward();
    }).addTo(_sub);
  }
}
