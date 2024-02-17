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

  final int dx;
  final int dy;
}
