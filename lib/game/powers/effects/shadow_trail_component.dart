import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShadowTrailComponent extends PositionComponent {
  double _timer = 0.0;
  final double lifespan = 0.3;
  final Paint _paint = Paint()..color = Colors.lightGreenAccent;

  ShadowTrailComponent({required Vector2 position, required Vector2 size})
      : super(position: position, size: size, anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer >= lifespan) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final opacity = (1.0 - (_timer / lifespan)).clamp(0.0, 1.0);
    _paint.color = Colors.greenAccent.withValues(alpha: opacity * 0.7);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), _paint);
  }
}
