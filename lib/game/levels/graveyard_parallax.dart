import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class GraveyardParallax extends Component {
  late ParallaxComponent parallaxComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    try {
      parallaxComponent = await ParallaxComponent.load(
        [
          ParallaxImageData('sky.png'),
          ParallaxImageData('far_scenery.png'),
          ParallaxImageData('near_fog.png'),
        ],
        baseVelocity: Vector2(10, 0),
        velocityMultiplierDelta: Vector2(1.5, 0),
      );
      await add(parallaxComponent);
    } catch (_) {
      await add(_FallbackParallaxComponent());
    }
  }
}

class _FallbackParallaxComponent extends PositionComponent {
  final Paint _skyPaint = Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF090915), Color(0xFF1B1B36)],
    ).createShader(const Rect.fromLTWH(0, 0, 2000, 600));

  final Paint _fogPaint = Paint()..color = const Color(0x33667799);

  _FallbackParallaxComponent() : super(size: Vector2(2000, 600));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _skyPaint);
    canvas.drawRect(Rect.fromLTWH(0, size.y * 0.6, size.x, size.y * 0.4), _fogPaint);
  }
}
