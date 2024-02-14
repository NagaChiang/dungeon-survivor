abstract interface class Health {
  Health({
    required this.health,
    required this.maxHealth,
  });

  int health;
  int maxHealth;

  void takeDamage(int damage) {
    assert(damage >= 0, 'Damage must be non-negative.');

    health = (health - damage).clamp(0, maxHealth);
  }

  void heal(int amount) {
    assert(amount >= 0, 'Healing amount must be non-negative.');

    health = (health + amount).clamp(0, maxHealth);
  }
}
