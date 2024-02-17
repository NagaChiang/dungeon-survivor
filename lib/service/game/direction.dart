enum Direction {
  stop(0, 0),
  left(-1, 0),
  right(1, 0),
  up(0, -1),
  down(0, 1),
  ;

  const Direction(
    this.dx,
    this.dy,
  );

  factory Direction.fromXY(int dx, int dy) {
    if (dx == 0 && dy == 0) {
      return stop;
    }

    if (dx < 0 && dy == 0) {
      return left;
    }

    if (dx > 0 && dy == 0) {
      return right;
    }

    if (dx == 0 && dy < 0) {
      return up;
    }

    if (dx == 0 && dy > 0) {
      return down;
    }

    throw ArgumentError('Invalid dx, dy: ($dx, $dy)');
  }

  final int dx;
  final int dy;
}
