import '../thug_component.dart';
import '../thug_state.dart';
import 'thug_attack_state.dart';
import 'thug_patrol_state.dart';

class ThugChaseState implements ThugState {
  @override
  void update(ThugComponent thug, double dt) {
    final player = thug.findPlayer();
    if (player == null) {
      thug.setState(ThugPatrolState());
      return;
    }

    final diff = player.position.x - thug.position.x;
    final distance = diff.abs();

    if (distance <= 40.0) {
      thug.setState(ThugAttackState());
      return;
    } else if (distance > 240.0) {
      thug.setState(ThugPatrolState());
      return;
    }

    final direction = diff.sign;
    thug.position.x += direction * 100.0 * dt;
    thug.isFacingRight = direction > 0;
  }
}
