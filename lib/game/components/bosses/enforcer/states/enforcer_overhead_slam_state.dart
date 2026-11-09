import 'package:flame/components.dart';
import '../../../combat/hitbox_component.dart';
import '../enforcer_boss.dart';
import '../enforcer_state.dart';
import 'enforcer_idle_state.dart';

class EnforcerOverheadSlamState implements EnforcerState {
  double _timer = 0.0;
  bool _hasSlammed = false;

  @override
  void update(EnforcerBoss enforcer, double dt) {
    _timer += dt;

    if (_timer >= 0.5 && !_hasSlammed) {
      _hasSlammed = true;
      _spawnSlamHitbox(enforcer);
    }

    if (_timer >= 1.0) {
      enforcer.setEnforcerState(EnforcerIdleState());
    }
  }

  void _spawnSlamHitbox(EnforcerBoss enforcer) {
    final offsetX = enforcer.isFacingRight ? 35.0 : -35.0;
    final hitbox = HitboxComponent(
      position: Vector2(enforcer.position.x + offsetX, enforcer.position.y),
      size: Vector2(40, 50),
      damage: 25.0,
      knockback: 180.0,
      isPlayerAttack: false,
    );
    enforcer.game.world.add(hitbox);
  }
}
