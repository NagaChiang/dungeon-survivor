class AttackEvent {
  const AttackEvent({
    required this.attackerId,
    required this.targetCoords,
  });

  final String attackerId;
  final List<(int, int)> targetCoords;
}
