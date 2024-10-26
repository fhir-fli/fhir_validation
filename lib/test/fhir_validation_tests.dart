import 'package:fhir_definitions/fhir_definitions.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:fhir_validation/test/test2/test.dart' as test2;
import 'package:flutter_test/flutter_test.dart';

/// Testing FHIR Validation
Future<void> fhirValidationTest() async {
  // Singleton cache instance
  final resourceCache = ResourceCache();
  Future<void> saveResource(Resource resource) async {
    switch (resource) {
      case StructureDefinition _:
        await resourceCache.set(resource.url.toString(), resource.toJson());
      case ValueSet _:
        if (resource.url != null) {
          await resourceCache.set(resource.url!.toString(), resource.toJson());
        }
      case CodeSystem _:
        if (resource.url != null) {
          await resourceCache.set(resource.url!.toString(), resource.toJson());
        }
      case NamingSystem _:
        for (final uniqueId in resource.uniqueId) {
          final value = uniqueId.value.value ?? '';
          final type = uniqueId.type.toString().toLowerCase();
          if (type == 'oid' && !(await resourceCache.containsKey(value))) {
            await resourceCache.set(value, resource.toJson());
          } else if (type == 'uri' &&
              !(await resourceCache.containsKey(value))) {
            await resourceCache.set(value, resource.toJson());
          }
        }
    }
  }

  final validator = FhirValidator();
  group('FHIR Mapping', () {
    // test('Test1', () async {
    //   final Resource resource = await test1.resource();
    //   final List<Resource> supportResources = await test1.supportResources();
    //   for (final Resource resource in supportResources) {
    //     saveResource(resource);
    //   }
    //   final ValidationResults result =
    //       await validator.validateFhirResource(resourceToValidate: resource);
    //   expect(result.toOperationOutcome().toJson(),
    //       (await test1.response()).toJson());
    // });
    test('Test2', () async {
      final resource = await test2.resource();
      final supportResources = await test2.supportResources();
      for (final resource in supportResources) {
        saveResource(resource);
      }
      final result =
          await validator.validateFhirResource(resourceToValidate: resource);
      expect(
        result.toOperationOutcome().toJson(),
        (await test2.response()).toJson(),
      );
    });
  });
}
