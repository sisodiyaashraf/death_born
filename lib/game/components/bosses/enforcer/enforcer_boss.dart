import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../combat/hitbox_component.dart';
import '../../combat/hurtbox_component.dart';
import '../../player/player_component.dart';
import '../boss_base.dart';
import 'enforcer_state.dart';
import 'states/enforcer_idle_state.dart';
import 'states/enforcer_hurt_state.dart';
import 'states/enforcer_dead_state.dart';

class EnforcerBoss extends BossBase {
  late HurtboxComponent hurtbox;
  EnforcerState currentState = EnforcerIdleState();
  bool isFacingRight = false;

  final void Function()? onDefeatedCallback;

  EnforcerBoss({
    required Vector2 position,
    this.onDefeatedCallback,
  }) : super(
          position: position,
          size: Vector2(48, 64),
          bossName: 'The Enforcer',
          maxHealth: 200.0,
          totalPhases: 2,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    hurtbox = HurtboxComponent(
      size: size,
      isPlayer: false,
      healthComponent: health,
      onHit: (hit) => _onHitCheck(hit),
    );
    add(hurtbox);
  }

  void setEnforcerState(EnforcerState newState) {
    currentState = newState;
  }

  void _onHitCheck(HitboxComponent hit) {
    final player = findPlayer();
    if (player == null) return;

    final hitFromRight = hit.position.x > position.x;
    final isHitFromFront = (isFacingRight && hitFromRight) || (!isFacingRight && !hitFromRight);

    if (isHitFromFront) {
      health.heal(hit.damage);
      return;
    }

    setEnforcerState(EnforcerHurtState());
  }

  PlayerComponent? findPlayer() {
    return game.componentsAtPoint(position).whereType<PlayerComponent>().firstOrNull ??
        game.world.children.whereType<PlayerComponent>().firstOrNull;
  }

  @override
  void update(double dt) {
    super.update(dt);
    currentState.update(this, dt);
  }

  @override
  void onIntro() {}

  @override
  void onPhaseChanged(int newPhase) {}

  @override
  void onDefeated() {
    setEnforcerState(EnforcerDeadState());
    onDefeatedCallback?.call();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = currentPhase == 2 ? Colors.deepOrangeAccent : const Color(0xFF8B0000);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), paint);

    final shieldX = isFacingRight ? size.x * 0.75 : size.x * 0.05;
    canvas.drawRect(
      Rect.fromLTWH(shieldX, 8, 8, size.y - 16),
      Paint()..color = Colors.blueGrey,
    );
  }
}
