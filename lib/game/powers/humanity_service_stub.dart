class HumanityService {
  static final HumanityService instance = HumanityService._internal();

  HumanityService._internal();

  double _corruptionMeter = 0.5;

  double get corruptionMeter => _corruptionMeter;

  void addCorruption(double amount) {
    _corruptionMeter = (_corruptionMeter + amount / 100.0).clamp(0.0, 1.0);
  }
}
