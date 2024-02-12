import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'hud_layout.dart';
import 'hud_view_model.dart';

class HudView extends StatelessWidget {
  const HudView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HudViewModel.create(context),
      builder: (context, _) {
        final vm = context.read<HudViewModel>();

        return HudLayout(
          onInputDirection: vm.onInputDirection,
        );
      },
    );
  }

  static const overlayName = 'hud';
}
