import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';

import '../components/enemies/thug/thug_component.dart';
import '../components/player/ground_component.dart';
import '../components/player/player_component.dart';
import 'graveyard_checkpoint.dart';

class LevelLoader {
  TiledComponent? tiledMap;
  Vector2 mapSize = Vector2(960, 640);

  Future<void> loadLevel({
    required FlameGame game,
    required World world,
    required String tmxPath,
    required void Function(Vector2 respawnPoint) onCheckpointActivated,
    required void Function(PlayerComponent player) onPlayerSpawned,
  }) async {
    try {
      tiledMap = await TiledComponent.load(tmxPath, Vector2.all(32));
      await world.add(tiledMap!);

      final tileMapWidth = (tiledMap!.tileMap.map.width * 32).toDouble();
      final tileMapHeight = (tiledMap!.tileMap.map.height * 32).toDouble();
      mapSize = Vector2(tileMapWidth, tileMapHeight);

      _parseObjects(world, onCheckpointActivated, onPlayerSpawned);
    } catch (_) {
      _loadFallbackLevel(world, onCheckpointActivated, onPlayerSpawned);
    }

    _applyCameraBounds(game);
  }

  void _parseObjects(
    World world,
    void Function(Vector2 point) onCheckpointActivated,
    void Function(PlayerComponent player) onPlayerSpawned,
  ) {
    if (tiledMap == null) return;

    final collisionsGroup = tiledMap!.tileMap.getLayer<ObjectGroup>('collisions');
    if (collisionsGroup != null) {
      for (final obj in collisionsGroup.objects) {
        world.add(
          GroundComponent(
            position: Vector2(obj.x, obj.y),
            size: Vector2(obj.width, obj.height),
          ),
        );
      }
    }

    final checkpointsGroup = tiledMap!.tileMap.getLayer<ObjectGroup>('checkpoints');
    if (checkpointsGroup != null) {
      for (final obj in checkpointsGroup.objects) {
        world.add(
          GraveCheckpoint(
            position: Vector2(obj.x, obj.y + obj.height),
            size: Vector2(obj.width, obj.height),
            onActivated: onCheckpointActivated,
          ),
        );
      }
    }

    final spawnsGroup = tiledMap!.tileMap.getLayer<ObjectGroup>('spawns');
    if (spawnsGroup != null) {
      for (final obj in spawnsGroup.objects) {
        if (obj.name == 'player' || obj.type == 'player') {
          final player = PlayerComponent(position: Vector2(obj.x, obj.y));
          world.add(player);
          onPlayerSpawned(player);
        } else if (obj.type == 'thug') {
          world.add(ThugComponent(position: Vector2(obj.x, obj.y)));
        }
      }
    }
  }

  void _loadFallbackLevel(
    World world,
    void Function(Vector2 point) onCheckpointActivated,
    void Function(PlayerComponent player) onPlayerSpawned,
  ) {
    world.add(GroundComponent(position: Vector2(0, 480), size: Vector2(960, 160)));

    final cp = GraveCheckpoint(
      position: Vector2(300, 480),
      size: Vector2(32, 40),
      onActivated: onCheckpointActivated,
    );
    world.add(cp);

    final player = PlayerComponent(position: Vector2(100, 430));
    world.add(player);
    onPlayerSpawned(player);

    world.add(ThugComponent(position: Vector2(400, 430)));
  }

  void _applyCameraBounds(FlameGame game) {
    game.camera.setBounds(
      Rectangle.fromLTWH(0, 0, mapSize.x, mapSize.y),
    );
  }
}
