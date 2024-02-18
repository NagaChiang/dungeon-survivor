import 'dart:math';

extension RandomExtension on Random {
  int nextSign() {
    return nextBool() ? 1 : -1;
  }

  int nextIntRange(int min, int max) {
    return nextInt(max - min) + min;
  }
}
