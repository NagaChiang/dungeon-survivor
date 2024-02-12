import 'package:flutter/material.dart';

import '../../app/app_color.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.width,
    this.height,
    required this.child,
    required this.onTapUp,
  });

  final double? width;
  final double? height;
  final Widget child;
  final VoidCallback onTapUp;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTapUp: (_) => onTapUp(),
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColor.black500,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
