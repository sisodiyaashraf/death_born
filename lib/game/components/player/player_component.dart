import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/game_constants.dart';
import 'ground_component.dart';
import 'player_sprites.dart';

class PlayerComponent extends PositionComponent
    with CollisionCallbacks, HasGameReference<FlameGame> {
  final Vector2 velocity = Vector2.zero();
  bool isGrounded = false;
  bool isFacingRight = true;

  PlayerState currentState = PlayerState.idle;
  final PlayerSprites _playerSprites = PlayerSprites();
  SpriteAnimationTicker? _currentTicker;

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
    _setPlayerState(PlayerState.idle);
  }

  @override
  void update(double dt) {
    super.update(dt);

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
    if (currentState != PlayerState.dead) {
      _setPlayerState(PlayerState.attack);
    }
  }

  void takeDamage() {
    if (currentState != PlayerState.dead) {
      _setPlayerState(PlayerState.hurt);
    }
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
      if (velocity.y < 0) {
        _setPlayerState(PlayerState.jump);
      } else {
        _setPlayerState(PlayerState.fall);
      }
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
