import 'package:flame/components.dart';
import '../../../combat/hitbox_component.dart';
import '../enforcer_boss.dart';
import '../enforcer_state.dart';
import 'enforcer_idle_state.dart';

class EnforcerChargeState implements EnforcerState {
  double _timer = 0.0;
  bool _hitboxSpawned = false;

  @override
  void update(EnforcerBoss enforcer, double dt) {
    _timer += dt;
    final dir = enforcer.isFacingRight ? 1.0 : -1.0;
    enforcer.position.x += dir * 260.0 * dt;

    if (!_hitboxSpawned) {
      _hitboxSpawned = true;
      final hitbox = HitboxComponent(
        position: Vector2(enforcer.position.x, enforcer.position.y),
        size: Vector2(40, 50),
        damage: 20.0,
        knockback: 200.0,
        isPlayerAttack: false,
        lifespan: 0.8,
      );
      enforcer.game.world.add(hitbox);
    }

    if (_timer >= 0.8) {
      enforcer.setEnforcerState(EnforcerIdleState());
    }
  }
}
