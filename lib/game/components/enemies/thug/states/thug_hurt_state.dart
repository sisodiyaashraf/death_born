import '../thug_component.dart';
import '../thug_state.dart';
import 'thug_chase_state.dart';

class ThugHurtState implements ThugState {
  double _timer = 0.0;
  final double knockbackDir;

  ThugHurtState({required this.knockbackDir});

  @override
  void update(ThugComponent thug, double dt) {
    _timer += dt;

    if (_timer < 0.15) {
      thug.position.x += knockbackDir * 150.0 * dt;
    }

    if (_timer >= 0.3) {
      thug.setState(ThugChaseState());
    }
  }
}
