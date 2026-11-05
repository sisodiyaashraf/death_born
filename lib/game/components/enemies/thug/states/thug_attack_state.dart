import '../thug_component.dart';
import '../thug_state.dart';
import 'thug_chase_state.dart';

class ThugAttackState implements ThugState {
  double _timer = 0.0;
  bool _hasAttacked = false;

  @override
  void update(ThugComponent thug, double dt) {
    _timer += dt;

    if (_timer >= 0.2 && !_hasAttacked) {
      _hasAttacked = true;
      thug.spawnAttackHitbox();
    }

    if (_timer >= 0.6) {
      thug.setState(ThugChaseState());
    }
  }
}
