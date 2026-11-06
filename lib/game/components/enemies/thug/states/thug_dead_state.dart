import '../thug_component.dart';
import '../thug_state.dart';

class ThugDeadState implements ThugState {
  double _timer = 0.0;

  @override
  void update(ThugComponent thug, double dt) {
    _timer += dt;
    if (_timer >= 0.5) {
      thug.removeFromParent();
    }
  }
}
