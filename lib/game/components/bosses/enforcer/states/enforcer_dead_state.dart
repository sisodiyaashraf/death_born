import '../../../pickups/toy_car_pickup.dart';
import '../enforcer_boss.dart';
import '../enforcer_state.dart';

class EnforcerDeadState implements EnforcerState {
  double _timer = 0.0;
  bool _droppedPickup = false;

  @override
  void update(EnforcerBoss enforcer, double dt) {
    _timer += dt;

    if (!_droppedPickup) {
      _droppedPickup = true;
      enforcer.game.world.add(
        ToyCarPickup(position: enforcer.position.clone()),
      );
    }

    if (_timer >= 0.5) {
      enforcer.removeFromParent();
    }
  }
}
