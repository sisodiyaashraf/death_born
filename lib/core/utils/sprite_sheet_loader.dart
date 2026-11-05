import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class SpriteSheetLoader {
  static Future<SpriteAnimation> loadAnimation({
    required FlameGame game,
    required String imagePath,
    required Vector2 frameSize,
    required int row,
    required int frameCount,
    double stepTime = 0.1,
    bool loop = true,
  }) async {
    final image = await game.images.load(imagePath);
    final sheet = SpriteSheet(
      image: image,
      srcSize: frameSize,
    );

    final sprites = List<Sprite>.generate(
      frameCount,
      (i) => sheet.getSprite(row, i),
    );

    return SpriteAnimation.spriteList(
      sprites,
      stepTime: stepTime,
      loop: loop,
    );
  }
}
