import '../enforcer_boss.dart';
import '../enforcer_state.dart';
import 'enforcer_idle_state.dart';

class EnforcerHurtState implements EnforcerState {
  double _timer = 0.0;

  @override
  void update(EnforcerBoss enforcer, double dt) {
    _timer += dt;
    if (_timer >= 0.25) {
      enforcer.setEnforcerState(EnforcerIdleState());
    }
  }
}
