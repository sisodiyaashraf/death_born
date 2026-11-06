import 'package:flame/components.dart';

class HealthComponent extends Component {
  double currentHealth;
  final double maxHealth;
  final void Function(double damage)? onDamaged;
  void Function()? onDeath;

  HealthComponent({
    required this.maxHealth,
    double? initialHealth,
    this.onDamaged,
    this.onDeath,
  }) : currentHealth = initialHealth ?? maxHealth;

  bool get isDead => currentHealth <= 0;

  void takeDamage(double amount) {
    if (isDead || amount <= 0) return;
    currentHealth = (currentHealth - amount).clamp(0.0, maxHealth);
    onDamaged?.call(amount);
    if (currentHealth <= 0) {
      onDeath?.call();
    }
  }

  void heal(double amount) {
    if (isDead || amount <= 0) return;
    currentHealth = (currentHealth + amount).clamp(0.0, maxHealth);
  }
}
