import '../thug_component.dart';
import '../thug_state.dart';
import 'thug_chase_state.dart';

class ThugPatrolState implements ThugState {
  double _direction = 1.0;
  double _movedDistance = 0.0;
  static const double maxPatrolDist = 120.0;

  @override
  void update(ThugComponent thug, double dt) {
    final moveAmount = _direction * 60.0 * dt;
    thug.position.x += moveAmount;
    _movedDistance += moveAmount.abs();

    if (_movedDistance >= maxPatrolDist) {
      _direction *= -1;
      _movedDistance = 0.0;
    }

    final player = thug.findPlayer();
    if (player != null) {
      final distance = (player.position.x - thug.position.x).abs();
      if (distance < 180.0) {
        thug.setState(ThugChaseState());
      }
    }
  }
}
