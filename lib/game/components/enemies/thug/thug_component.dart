import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../combat/health_component.dart';
import '../../combat/hitbox_component.dart';
import '../../combat/hurtbox_component.dart';
import '../../player/player_component.dart';
import 'thug_state.dart';
import 'states/thug_patrol_state.dart';
import 'states/thug_hurt_state.dart';
import 'states/thug_dead_state.dart';

class ThugComponent extends PositionComponent with HasGameReference<FlameGame> {
  late HealthComponent health;
  late HurtboxComponent hurtbox;
  ThugState currentState = ThugPatrolState();

  bool isFacingRight = false;
  double _flashTimer = 0.0;
  final Paint _paint = Paint()..color = Colors.redAccent;
  final Paint _flashPaint = Paint()..color = Colors.white;

  ThugComponent({required Vector2 position})
      : super(position: position, size: Vector2(32, 48), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    health = HealthComponent(
      maxHealth: 50.0,
      onDamaged: (_) => _onDamaged(),
      onDeath: () => setState(ThugDeadState()),
    );
    add(health);

    hurtbox = HurtboxComponent(
      size: size,
      isPlayer: false,
      healthComponent: health,
      onHit: (hit) => _onHitReceived(hit),
    );
    add(hurtbox);
  }

  void setState(ThugState newState) {
    currentState = newState;
  }

  PlayerComponent? findPlayer() {
    return game.componentsAtPoint(position).whereType<PlayerComponent>().firstOrNull ??
        game.world.children.whereType<PlayerComponent>().firstOrNull;
  }

  void spawnAttackHitbox() {
    final offsetX = isFacingRight ? size.x / 2 + 10 : -size.x / 2 - 25;
    final hitbox = HitboxComponent(
      position: Vector2(position.x + offsetX, position.y - size.y / 2),
      size: Vector2(25, 30),
      damage: 10.0,
      knockback: 100.0,
      isPlayerAttack: false,
    );
    game.world.add(hitbox);
  }

  void _onDamaged() {
    _flashTimer = 0.12;
  }

  void _onHitReceived(HitboxComponent hit) {
    final player = findPlayer();
    final knockbackDir = player != null
        ? (position.x - player.position.x).sign
        : (isFacingRight ? -1.0 : 1.0);

    setState(ThugHurtState(knockbackDir: knockbackDir));
  }

  @override
  void update(double dt) {
    super.update(dt);
    currentState.update(this, dt);

    if (_flashTimer > 0) {
      _flashTimer -= dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paintToUse = _flashTimer > 0 ? _flashPaint : _paint;
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paintToUse);
  }
}
