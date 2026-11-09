import '../components/player/player_component.dart';

abstract class Power {
  final String id;
  final String name;
  final double cooldownDuration;
  double cooldownRemaining = 0.0;
  bool isUnlocked = true;

  Power({
    required this.id,
    required this.name,
    required this.cooldownDuration,
  });

  bool get isReady => cooldownRemaining <= 0 && isUnlocked;

  bool tryActivate(PlayerComponent player) {
    if (!isReady) return false;
    final success = activate(player);
    if (success) {
      cooldownRemaining = cooldownDuration;
    }
    return success;
  }

  bool activate(PlayerComponent player);

  void updateCooldown(double dt) {
    if (cooldownRemaining > 0) {
      cooldownRemaining = (cooldownRemaining - dt).clamp(0.0, cooldownDuration);
    }
  }

  double get cooldownProgress =>
      cooldownDuration > 0 ? (cooldownRemaining / cooldownDuration) : 0.0;
}
