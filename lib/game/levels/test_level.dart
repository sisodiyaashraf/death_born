import 'package:flame/components.dart';
import '../../core/constants/game_constants.dart';
import '../components/enemies/thug/thug_component.dart';
import '../components/player/ground_component.dart';
import 'level_spawn_point.dart';

class TestLevel extends Component {
  late final GroundComponent ground;
  final List<LevelSpawnPoint> spawnPoints = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    ground = GroundComponent(
      position: Vector2(0, 400),
      size: Vector2(GameConstants.worldWidth, GameConstants.groundHeight),
    );
    await add(ground);

    spawnPoints.addAll([
      LevelSpawnPoint(position: Vector2(100, 376), spawnType: SpawnType.player),
      LevelSpawnPoint(position: Vector2(400, 376), spawnType: SpawnType.thugEnemy),
      LevelSpawnPoint(position: Vector2(700, 376), spawnType: SpawnType.thugEnemy),
    ]);
  }

  void spawnEnemies(World world) {
    for (final spawn in spawnPoints) {
      if (spawn.spawnType == SpawnType.thugEnemy) {
        world.add(ThugComponent(position: spawn.position));
      }
    }
  }

  Vector2? getPlayerSpawnPosition() {
    return spawnPoints
        .where((s) => s.spawnType == SpawnType.player)
        .firstOrNull
        ?.position;
  }
}
