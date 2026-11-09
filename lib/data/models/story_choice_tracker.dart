class StoryChoiceTracker {
  final Set<String> _recordedChoices = {};

  StoryChoiceTracker([Set<String>? initialChoices]) {
    if (initialChoices != null) {
      _recordedChoices.addAll(initialChoices);
    }
  }

  Set<String> get choices => Set.unmodifiable(_recordedChoices);

  void recordChoice(String choiceId) {
    _recordedChoices.add(choiceId);
  }

  bool hasChoice(String choiceId) {
    return _recordedChoices.contains(choiceId);
  }
}
