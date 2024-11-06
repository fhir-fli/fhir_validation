import 'package:fhir_definitions/fhir_definitions.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:fhir_validation/test/test1/test.dart';
import 'package:flutter_test/flutter_test.dart';

/// Testing FHIR Validation
Future<void> fhirValidationTest() async {
  // Singleton cache instance
  final resourceCache = ResourceCache();
  Future<void> saveResource(Map<String, dynamic> resource) async {
    final resourceType = resource['resourceType'];
    switch (resourceType) {
      case 'StructureDefinition':
        resourceCache.set(resource['url'] as String, resource);
      case 'ValueSet':
        if (resource['url'] != null) {
          resourceCache.set(resource['url'] as String, resource);
        }
      case 'CodeSystem':
        if (resource['url'] != null) {
          resourceCache.set(resource['url'] as String, resource);
        }
      case 'NamingSystem':
        for (final uniqueId
            in resource['uniqueId'] as List<Map<String, dynamic>>) {
          final value = uniqueId['value'] as String? ?? '';
          final type = (uniqueId['type'] as String).toLowerCase();
          if (type == 'oid' && !resourceCache.containsKey(value)) {
            resourceCache.set(value, resource);
          } else if (type == 'uri' && !resourceCache.containsKey(value)) {
            resourceCache.set(value, resource);
          }
        }
    }
  }

  final validator = FhirValidator();
  group('FHIR Mapping', () {
    test('Test1', () async {
      final supportResources = [
        supportResource1,
        supportResource2,
        supportResource3,
        supportResource4,
      ];
      for (final resource in supportResources) {
        await saveResource(resource);
      }
      final result1 = await validator.validateFhirMap(
        resourceToValidate: resource1,
        client: null,
      );
      expect(
        result1.toOperationOutcome().toJson(),
        response1,
      );

      final result1a = await validator.validateFhirMap(
        resourceToValidate: resource1a,
        client: null,
      );
      expect(
        result1a.toOperationOutcome().toJson(),
        response1a,
      );
    });
  });
}
