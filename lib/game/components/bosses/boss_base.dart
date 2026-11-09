import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../combat/health_component.dart';

abstract class BossBase extends PositionComponent
    with CollisionCallbacks, HasGameReference<FlameGame> {
  final String bossName;
  late HealthComponent health;
  int currentPhase = 1;
  final int totalPhases;

  bool isIntroComplete = false;
  bool isDefeated = false;

  BossBase({
    required Vector2 position,
    required Vector2 size,
    required this.bossName,
    required double maxHealth,
    this.totalPhases = 2,
  }) : super(position: position, size: size, anchor: Anchor.center) {
    health = HealthComponent(
      maxHealth: maxHealth,
      onDamaged: (dmg) => _onTakeDamage(dmg),
      onDeath: () => _handleDefeat(),
    );
    add(health);
  }

  void startIntro() {
    isIntroComplete = true;
    onIntro();
  }

  void _onTakeDamage(double damage) {
    final healthRatio = health.currentHealth / health.maxHealth;
    if (totalPhases > 1 && currentPhase == 1 && healthRatio <= 0.5) {
      currentPhase = 2;
      onPhaseChanged(2);
    }
  }

  void _handleDefeat() {
    if (isDefeated) return;
    isDefeated = true;
    onDefeated();
  }

  void onIntro();
  void onPhaseChanged(int newPhase);
  void onDefeated();
}
