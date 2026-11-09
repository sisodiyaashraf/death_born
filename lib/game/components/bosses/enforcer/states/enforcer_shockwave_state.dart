import 'package:flame/components.dart';
import '../../../combat/hitbox_component.dart';
import '../enforcer_boss.dart';
import '../enforcer_state.dart';
import 'enforcer_idle_state.dart';

class EnforcerShockwaveState implements EnforcerState {
  double _timer = 0.0;
  bool _spawnedWave = false;

  @override
  void update(EnforcerBoss enforcer, double dt) {
    _timer += dt;

    if (_timer >= 0.4 && !_spawnedWave) {
      _spawnedWave = true;
      _spawnShockwave(enforcer);
    }

    if (_timer >= 0.9) {
      enforcer.setEnforcerState(EnforcerIdleState());
    }
  }

  void _spawnShockwave(EnforcerBoss enforcer) {
    for (final dir in [-1.0, 1.0]) {
      final wave = HitboxComponent(
        position: Vector2(enforcer.position.x + (dir * 40), enforcer.position.y + 10),
        size: Vector2(30, 20),
        damage: 15.0,
        knockback: 120.0,
        isPlayerAttack: false,
        lifespan: 0.5,
      );
      enforcer.game.world.add(wave);
    }
  }
}
