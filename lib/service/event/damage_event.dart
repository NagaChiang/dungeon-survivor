class DamageEvent {
  const DamageEvent({
    required this.attackerId,
    required this.defenderId,
    required this.damage,
  });

  final String attackerId;
  final String defenderId;
  final int damage;
}
