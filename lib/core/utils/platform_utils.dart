import 'package:flutter/foundation.dart';

class PlatformUtils {
  static bool isTouchDevice() {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }
}
