import 'package:flutter/foundation.dart';
import '../../data/models/humanity_state.dart';
import '../../data/models/story_choice_tracker.dart';
import '../../data/repositories/humanity_repository.dart';

class HumanityService extends ChangeNotifier {
  static HumanityService? _instance;
  static HumanityService get instance => _instance ?? HumanityService();

  final HumanityRepository? _repository;
  HumanityState _state = HumanityState.initial();
  final StoryChoiceTracker _choiceTracker = StoryChoiceTracker();

  HumanityService({HumanityRepository? repository}) : _repository = repository {
    _instance = this;
    _init();
  }

  HumanityState get state => _state;
  StoryChoiceTracker get choiceTracker => _choiceTracker;
  double get humanity => _state.humanity;
  double get corruption => _state.corruption;
  Alignment get alignment => _state.alignment;

  Future<void> _init() async {
    if (_repository != null) {
      _state = await _repository!.loadHumanityState();
      final savedChoices = await _repository!.loadChoices();
      for (final c in savedChoices) {
        _choiceTracker.recordChoice(c);
      }
      notifyListeners();
    }
  }

  void addHumanity(double amount) {
    if (amount <= 0) return;
    _state = _state.copyWith(
      humanity: _state.humanity + amount,
      corruption: _state.corruption - (amount * 0.5),
    );
    _persist();
    notifyListeners();
  }

  void addCorruption(double amount) {
    if (amount <= 0) return;
    _state = _state.copyWith(
      corruption: _state.corruption + amount,
      humanity: _state.humanity - (amount * 0.5),
    );
    _persist();
    notifyListeners();
  }

  void recordChoice(String choiceId) {
    _choiceTracker.recordChoice(choiceId);
    _repository?.saveChoice(choiceId);
    notifyListeners();
  }

  void _persist() {
    _repository?.saveHumanityState(_state);
  }
}
