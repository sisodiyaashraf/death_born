import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../components/player/player_component.dart';
import 'graveyard_parallax.dart';
import 'level_loader.dart';

class GraveyardLevel extends Component with HasGameReference<FlameGame> {
  final LevelLoader loader = LevelLoader();

  final void Function(Vector2 respawnPoint) onCheckpointActivated;
  final void Function(PlayerComponent player) onPlayerSpawned;

  GraveyardLevel({
    required this.onCheckpointActivated,
    required this.onPlayerSpawned,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(GraveyardParallax());

    await loader.loadLevel(
      game: game,
      world: game.world,
      tmxPath: 'graveyard_map.tmx',
      onCheckpointActivated: onCheckpointActivated,
      onPlayerSpawned: onPlayerSpawned,
    );
  }
}
