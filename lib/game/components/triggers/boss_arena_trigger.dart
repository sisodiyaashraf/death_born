import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../bosses/enforcer/enforcer_boss.dart';
import '../player/ground_component.dart';
import '../player/player_component.dart';

class BossArenaTrigger extends PositionComponent with CollisionCallbacks {
  final Vector2 arenaCenter;
  bool isTriggered = false;
  bool isBossDefeated = false;

  GroundComponent? leftWall;
  GroundComponent? rightWall;

  BossArenaTrigger({
    required Vector2 position,
    required Vector2 size,
    required this.arenaCenter,
  }) : super(position: position, size: size) {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is PlayerComponent && !isTriggered) {
      isTriggered = true;
      _lockArena(other);
    }
  }

  void _lockArena(PlayerComponent player) {
    leftWall = GroundComponent(
      position: Vector2(arenaCenter.x - 250, arenaCenter.y - 200),
      size: Vector2(20, 300),
    );
    rightWall = GroundComponent(
      position: Vector2(arenaCenter.x + 230, arenaCenter.y - 200),
      size: Vector2(20, 300),
    );

    parent?.add(leftWall!);
    parent?.add(rightWall!);

    final boss = EnforcerBoss(
      position: Vector2(arenaCenter.x + 120, arenaCenter.y + 140),
      onDefeatedCallback: unlockArena,
    );
    parent?.add(boss);
    boss.startIntro();
  }

  void unlockArena() {
    isBossDefeated = true;
    leftWall?.removeFromParent();
    rightWall?.removeFromParent();
  }
}
