import 'package:flame/components.dart';
import '../../core/constants/game_constants.dart';
import '../components/player/ground_component.dart';

class TestLevel extends Component {
  late final GroundComponent ground;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    ground = GroundComponent(
      position: Vector2(0, 400),
      size: Vector2(GameConstants.worldWidth, GameConstants.groundHeight),
    );

    await add(ground);
  }
}
