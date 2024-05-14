import 'models/models.dart';
import 'services/services.dart';
import 'systems/systems.dart';
import 'systems/systems.dart';

class FhirValidator {
  final LocalStorageService _localStorageService = LocalStorageService();
  final OnlineRetrievalService _onlineRetrievalService =
      OnlineRetrievalService();

  FhirValidator();

  bool validateResource(FhirResource resource) {
    return _fhirValidationService.validateResource(resource);
  }

  bool validateSystem(String system, String code) {
    return _fhirValidationSystem.validateSystem(system, code);
  }
}
