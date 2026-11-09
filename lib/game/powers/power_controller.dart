import 'package:flutter/foundation.dart';

import '../components/player/player_component.dart';
import 'grave_step_power.dart';
import 'grave_strike_power.dart';
import 'power_base.dart';

class PowerController extends ChangeNotifier {
  final List<Power> powers = [
    GraveStepPower(),
    GraveStrikePower(),
  ];

  Power? getPower(String id) {
    return powers.where((p) => p.id == id).firstOrNull;
  }

  bool triggerPower(String id, PlayerComponent player) {
    final power = getPower(id);
    if (power == null) return false;

    final activated = power.tryActivate(player);
    if (activated) {
      notifyListeners();
    }
    return activated;
  }

  void update(double dt) {
    bool updated = false;
    for (final power in powers) {
      if (power.cooldownRemaining > 0) {
        power.updateCooldown(dt);
        updated = true;
      }
    }
    if (updated) {
      notifyListeners();
    }
  }
}
