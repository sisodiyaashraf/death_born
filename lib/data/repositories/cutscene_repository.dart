import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/cutscene_model.dart';

class CutsceneRepository {
  Future<CutsceneScene> loadScene(String sceneId) async {
    final String jsonString = await rootBundle.loadString('assets/cutscenes/$sceneId.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return CutsceneScene.fromJson(jsonMap);
  }
}
