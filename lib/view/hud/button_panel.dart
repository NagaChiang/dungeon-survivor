import 'package:flutter/material.dart';

import '../../app/app_color.dart';
import '../common/button.dart';

class ButtonPanel extends StatelessWidget {
  const ButtonPanel({super.key});

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
                    // TODO
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
                    // TODO
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
                    // TODO
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
                    // TODO
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
                    // TODO
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
  static const _buttonColor = AppColor.white54;
}
