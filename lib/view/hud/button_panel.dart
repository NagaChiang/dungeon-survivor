import 'package:flutter/material.dart';

import '../../app/app_color.dart';
import '../../service/game/input_direction.dart';
import '../common/button.dart';

typedef InputDirectionCallback = void Function(InputDirection direction);

class ButtonPanel extends StatelessWidget {
  const ButtonPanel({
    super.key,
    required this.onTap,
  });

  final InputDirectionCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Row(
              children: [
                const SizedBox(width: _buttonSize + _paddingSize),
                Button(
                  width: _buttonSize,
                  height: _buttonSize,
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: _buttonColor,
                  ),
                  onTapUp: () {
                    onTap(InputDirection.up);
                  },
                ),
                const SizedBox(width: _buttonSize + _paddingSize),
              ],
            ),
            const SizedBox(height: _paddingSize),
            Row(
              children: [
                Button(
                  width: _buttonSize,
                  height: _buttonSize,
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: _buttonColor,
                  ),
                  onTapUp: () {
                    onTap(InputDirection.left);
                  },
                ),
                const SizedBox(width: _paddingSize),
                Button(
                  width: _buttonSize,
                  height: _buttonSize,
                  child: const Icon(
                    Icons.circle,
                    color: _buttonColor,
                  ),
                  onTapUp: () {
                    onTap(InputDirection.stop);
                  },
                ),
                const SizedBox(width: _paddingSize),
                Button(
                  width: _buttonSize,
                  height: _buttonSize,
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: _buttonColor,
                  ),
                  onTapUp: () {
                    onTap(InputDirection.right);
                  },
                ),
              ],
            ),
            const SizedBox(height: _paddingSize),
            Row(
              children: [
                const SizedBox(width: _buttonSize + _paddingSize),
                Button(
                  width: _buttonSize,
                  height: _buttonSize,
                  child: const Icon(
                    Icons.arrow_downward_rounded,
                    color: _buttonColor,
                  ),
                  onTapUp: () {
                    onTap(InputDirection.down);
                  },
                ),
                const SizedBox(width: _buttonSize + _paddingSize),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static const _buttonSize = 48.0;
  static const _paddingSize = 8.0;
  static const _buttonColor = AppColor.white87;
}
