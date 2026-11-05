import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EnemyPlaceholder extends PositionComponent with CollisionCallbacks {
  final Paint _paint = Paint()..color = Colors.redAccent;

  EnemyPlaceholder({required Vector2 position})
      : super(position: position, size: Vector2(30, 40)) {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRect(rect, _paint);
  }
}
