import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/game_constants.dart';
import '../../powers/power_controller.dart';
import '../combat/health_component.dart';
import '../combat/hitbox_component.dart';
import '../combat/hurtbox_component.dart';
import 'ground_component.dart';
import 'player_sprites.dart';

class PlayerComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<FlameGame> {
  final Vector2 velocity = Vector2.zero();
  bool isGrounded = false;
  bool isFacingRight = true;

  late HealthComponent health;
  late HurtboxComponent hurtbox;
  final PowerController powerController = PowerController();

  PlayerState currentState = PlayerState.idle;
  final PlayerSprites _playerSprites = PlayerSprites();
  SpriteAnimationTicker? _currentTicker;

  double _hitStopTimer = 0.0;
  double _invulnerableTimer = 0.0;
  double _blinkTimer = 0.0;
  bool _isVisible = true;

  PlayerComponent({required Vector2 position})
      : super(
          position: position,
          size: Vector2(GameConstants.playerWidth, GameConstants.playerHeight),
          anchor: Anchor.center,
        ) {
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _playerSprites.loadAnimations(game);

    health = HealthComponent(
      maxHealth: 100.0,
      onDamaged: (_) => _onDamaged(),
      onDeath: () => _setPlayerState(PlayerState.dead),
    );
    add(health);

    hurtbox = HurtboxComponent(
      size: size,
      isPlayer: true,
      healthComponent: health,
      onHit: (hit) => _onHitReceived(hit),
    );
    add(hurtbox);

    _setPlayerState(PlayerState.idle);
  }

  @override
  void update(double dt) {
    powerController.update(dt);

    if (_hitStopTimer > 0) {
      _hitStopTimer -= dt;
      return;
    }

    super.update(dt);

    if (_invulnerableTimer > 0) {
      _invulnerableTimer -= dt;
      _blinkTimer += dt;
      if (_blinkTimer >= 0.08) {
        _isVisible = !_isVisible;
        _blinkTimer = 0.0;
      }
      if (_invulnerableTimer <= 0) {
        _isVisible = true;
        hurtbox.isInvulnerable = false;
      }
    }

    if (!isGrounded) {
      velocity.y += GameConstants.gravity * dt;
    }

    position += velocity * dt;

    if (velocity.x > 0 && !isFacingRight) {
      isFacingRight = true;
      scale.x = 1.0;
    } else if (velocity.x < 0 && isFacingRight) {
      isFacingRight = false;
      scale.x = -1.0;
    }

    _currentTicker?.update(dt);
    _updateState();
  }

  void moveLeft() => velocity.x = -GameConstants.playerMoveSpeed;
  void moveRight() => velocity.x = GameConstants.playerMoveSpeed;
  void stopHorizontal() => velocity.x = 0;

  void jump() {
    if (isGrounded) {
      velocity.y = GameConstants.playerJumpForce;
      isGrounded = false;
      _setPlayerState(PlayerState.jump);
    }
  }

  void attack() {
    if (currentState != PlayerState.dead && currentState != PlayerState.attack) {
      _setPlayerState(PlayerState.attack);
      _spawnAttackHitbox();
    }
  }

  bool usePower(String powerId) {
    if (currentState == PlayerState.dead) return false;
    return powerController.triggerPower(powerId, this);
  }

  void _spawnAttackHitbox() {
    final offsetX = isFacingRight ? size.x / 2 + 10 : -size.x / 2 - 30;
    final hitbox = HitboxComponent(
      position: Vector2(position.x + offsetX, position.y - size.y / 2),
      size: Vector2(30, 40),
      damage: 25.0,
      knockback: 150.0,
      isPlayerAttack: true,
    );
    game.world.add(hitbox);
  }

  void _onDamaged() {
    _hitStopTimer = 0.06;
    _invulnerableTimer = 1.0;
    hurtbox.isInvulnerable = true;
    _setPlayerState(PlayerState.hurt);
  }

  void _onHitReceived(HitboxComponent hit) {
    velocity.x = (position.x < hit.position.x) ? -120.0 : 120.0;
    velocity.y = -100.0;
  }

  void _updateState() {
    if (currentState == PlayerState.dead) return;

    if (currentState == PlayerState.attack || currentState == PlayerState.hurt) {
      final isDone = _currentTicker?.done() ?? false;
      if (isDone) {
        _setPlayerState(PlayerState.idle);
      }
      return;
    }

    if (!isGrounded) {
      _setPlayerState(velocity.y < 0 ? PlayerState.jump : PlayerState.fall);
    } else if (velocity.x != 0) {
      _setPlayerState(PlayerState.run);
    } else {
      _setPlayerState(PlayerState.idle);
    }
  }

  void _setPlayerState(PlayerState newState) {
    if (currentState == newState && _currentTicker != null) return;
    currentState = newState;
    final anim = _playerSprites.animations[newState];
    if (anim != null) {
      _currentTicker = anim.createTicker();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is GroundComponent) {
      final playerBottom = position.y + size.y / 2;
      final groundTop = other.position.y;

      if (velocity.y >= 0 && playerBottom - velocity.y * 0.1 <= groundTop + 10) {
        position.y = groundTop - size.y / 2;
        velocity.y = 0;
        isGrounded = true;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    if (!_isVisible) return;
    super.render(canvas);

    if (_currentTicker != null) {
      final sprite = _currentTicker!.getSprite();
      sprite.render(
        canvas,
        size: size,
        overridePaint: Paint()..filterQuality = FilterQuality.none,
      );
    }
  }
}
