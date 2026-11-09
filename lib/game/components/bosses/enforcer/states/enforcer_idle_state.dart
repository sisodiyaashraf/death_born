import 'dart:math';
import '../enforcer_boss.dart';
import '../enforcer_state.dart';
import 'enforcer_overhead_slam_state.dart';
import 'enforcer_charge_state.dart';
import 'enforcer_shockwave_state.dart';

class EnforcerIdleState implements EnforcerState {
  double _timer = 0.0;
  final Random _rnd = Random();

  @override
  void update(EnforcerBoss enforcer, double dt) {
    _timer += dt;
    final player = enforcer.findPlayer();
    if (player != null) {
      enforcer.isFacingRight = player.position.x > enforcer.position.x;
    }

    if (_timer >= (enforcer.currentPhase == 2 ? 0.8 : 1.4)) {
      _selectNextAttack(enforcer);
    }
  }

  void _selectNextAttack(EnforcerBoss enforcer) {
    final roll = _rnd.nextInt(3);
    if (roll == 0) {
      enforcer.setEnforcerState(EnforcerOverheadSlamState());
    } else if (roll == 1) {
      enforcer.setEnforcerState(EnforcerChargeState());
    } else {
      enforcer.setEnforcerState(EnforcerShockwaveState());
    }
  }
}
