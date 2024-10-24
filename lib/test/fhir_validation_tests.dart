import 'package:flutter_test/flutter_test.dart';
import 'package:fhir_r4/fhir_r4.dart';

import '../fhir_validation.dart';
import 'test2/test.dart' as test2;

Future<void> fhirValidationTest() async {
  // Singleton cache instance
  final ResourceCache resourceCache = ResourceCache();
  void saveResource(Resource resource) {
    switch (resource) {
      case StructureDefinition _:
        resourceCache.set(resource.url.toString(), resource.toJson());
        break;
      case ValueSet _:
        if (resource.url != null) {
          resourceCache.set(resource.url!.toString(), resource.toJson());
        }
        break;
      case CodeSystem _:
        if (resource.url != null) {
          resourceCache.set(resource.url!.toString(), resource.toJson());
        }
        break;
      case NamingSystem _:
        for (final NamingSystemUniqueId uniqueId in resource.uniqueId) {
          final String value = uniqueId.value.value ?? '';
          final String? type = uniqueId.type.toString().toLowerCase();
          if (type == 'oid' && !resourceCache.containsKey(value)) {
            resourceCache.set(value, resource.toJson());
          } else if (type == 'uri' && !resourceCache.containsKey(value)) {
            resourceCache.set(value, resource.toJson());
          }
        }
    }
  }

  final FhirValidator validator = FhirValidator();
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
      final Resource resource = await test2.resource();
      final List<Resource> supportResources = await test2.supportResources();
      for (final Resource resource in supportResources) {
        saveResource(resource);
      }
      final ValidationResults result =
          await validator.validateFhirResource(resourceToValidate: resource);
      expect(result.toOperationOutcome().toJson(),
          (await test2.response()).toJson());
    });
  });
}
