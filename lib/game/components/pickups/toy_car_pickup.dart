import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../player/player_component.dart';

class ToyCarPickup extends PositionComponent with CollisionCallbacks {
  final Paint _paint = Paint()..color = Colors.amberAccent;
  final void Function()? onCollected;
  bool isCollected = false;

  ToyCarPickup({required Vector2 position, this.onCollected})
      : super(position: position, size: Vector2(24, 16), anchor: Anchor.center) {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is PlayerComponent && !isCollected) {
      isCollected = true;
      onCollected?.call();
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), _paint);
  }
}
