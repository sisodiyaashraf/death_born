import 'package:flame/components.dart';

enum SpawnType { player, thugEnemy, alenoidNpc }

class LevelSpawnPoint extends Component {
  final Vector2 position;
  final SpawnType spawnType;

  LevelSpawnPoint({
    required this.position,
    required this.spawnType,
  });
}
