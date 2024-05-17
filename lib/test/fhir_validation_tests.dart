import 'package:flutter_test/flutter_test.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validator.dart';

import 'package:fhir_validation/systems/resource_cache.dart';
import 'test1/test.dart' as test1;

Future<void> fhirValidationTest() async {
  // Singleton cache instance
  final ResourceCache resourceCache = ResourceCache();
  void saveResource(Resource resource) {
    switch (resource) {
      case StructureDefinition _:
        if (resource.url != null) {
          resourceCache.set(resource.url!.toString(), resource.toJson());
        }
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
        for (final uniqueId in resource.uniqueId) {
          final value = uniqueId.value ?? '';
          final type = uniqueId.type?.value?.toLowerCase();
          if (type == 'oid' && !resourceCache.containsKey(value)) {
            resourceCache.set(value, resource.toJson());
          } else if (type == 'uri' && !resourceCache.containsKey(value)) {
            resourceCache.set(value, resource.toJson());
          }
        }
    }
  }

  final validator = FhirValidator();
  // group('FHIR Mapping', () {
  // test('Test1', () async {
  final resource = await test1.resource();
  final supportResources = await test1.supportResources();
  for (final resource in supportResources) {
    saveResource(resource);
  }
  final result =
      await validator.validateFhirResource(resourceToValidate: resource);
  print(result.prettyPrint());
  // });
  // });
}

void test(String s, Future<Null> Function() param1) {}
