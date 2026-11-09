import 'package:flutter/foundation.dart';
import '../../data/models/dialogue_models.dart';
import '../../data/repositories/dialogue_repository.dart';
import '../services/humanity_service.dart';

class DialogueController extends ChangeNotifier {
  final DialogueRepository _repository = DialogueRepository();
  DialogueSceneModel? _currentScene;
  int _currentLineIndex = 0;
  bool _isActive = false;

  DialogueSceneModel? get currentScene => _currentScene;
  int get currentLineIndex => _currentLineIndex;
  bool get isActive => _isActive;

  DialogueLineModel? get currentLine {
    if (_currentScene == null || _currentLineIndex >= _currentScene!.lines.length) {
      return null;
    }
    return _currentScene!.lines[_currentLineIndex];
  }

  Future<void> startDialogue(String sceneId) async {
    try {
      _currentScene = await _repository.loadScene(sceneId);
      _currentLineIndex = 0;
      _isActive = true;
      notifyListeners();
    } catch (_) {
      _isActive = false;
      notifyListeners();
    }
  }

  void advanceLine() {
    if (!_isActive || currentLine == null) return;

    if (currentLine!.choices.isNotEmpty) return;

    if (_currentLineIndex + 1 < _currentScene!.lines.length) {
      _currentLineIndex++;
      notifyListeners();
    } else {
      endDialogue();
    }
  }

  void selectChoice(DialogueChoiceModel choice) {
    if (choice.humanityImpact > 0) {
      HumanityService.instance.addHumanity(choice.humanityImpact);
    } else if (choice.humanityImpact < 0) {
      HumanityService.instance.addCorruption(choice.humanityImpact.abs());
    }

    if (_currentLineIndex + 1 < _currentScene!.lines.length) {
      _currentLineIndex++;
      notifyListeners();
    } else {
      endDialogue();
    }
  }

  void endDialogue() {
    _isActive = false;
    _currentScene = null;
    _currentLineIndex = 0;
    notifyListeners();
  }
}
