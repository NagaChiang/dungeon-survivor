import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'hud_layout.dart';
import 'hud_view_model.dart';

class HudView extends StatelessWidget {
  const HudView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: HudViewModel.create,
      builder: (context, _) {
        final vm = context.read<HudViewModel>();
        final health = context.select((HudViewModel vm) => vm.health);
        final maxHealth = context.select((HudViewModel vm) => vm.maxHealth);

        return HudLayout(
          health: health,
          maxHealth: maxHealth,
          onInputDirection: vm.onInputDirection,
        );
      },
    );
  }

  static const overlayName = 'hud';
}
