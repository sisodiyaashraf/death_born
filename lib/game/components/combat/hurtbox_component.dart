import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'health_component.dart';
import 'hitbox_component.dart';

class HurtboxComponent extends PositionComponent with CollisionCallbacks {
  final bool isPlayer;
  final HealthComponent healthComponent;
  final void Function(HitboxComponent hit)? onHit;
  bool isInvulnerable = false;

  HurtboxComponent({
    required Vector2 size,
    required this.isPlayer,
    required this.healthComponent,
    this.onHit,
  }) : super(size: size) {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is HitboxComponent && !isInvulnerable) {
      if (other.isPlayerAttack != isPlayer) {
        healthComponent.takeDamage(other.damage);
        onHit?.call(other);
      }
    }
  }
}
