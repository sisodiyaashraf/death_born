import '../../domain/services/humanity_service.dart';

class HumanityServiceStub {
  static void addCorruption(double amount) {
    HumanityService.instance.addCorruption(amount);
  }
}
