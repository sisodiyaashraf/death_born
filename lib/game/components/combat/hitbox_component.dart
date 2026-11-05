import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class HitboxComponent extends PositionComponent with CollisionCallbacks {
  final double damage;
  final double knockback;
  final bool isPlayerAttack;
  final double lifespan;
  double _timer = 0.0;

  HitboxComponent({
    required Vector2 position,
    required Vector2 size,
    required this.damage,
    required this.knockback,
    required this.isPlayerAttack,
    this.lifespan = 0.1,
  }) : super(position: position, size: size) {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer >= lifespan) {
      removeFromParent();
    }
  }
}
