import 'package:fhir_validation/fhir_validation.dart';
import 'package:test/test.dart';

import 'support/test_model.dart';

void main() {
  group('FhirValidationEngine', () {
    const validator = FhirValidationEngine(testModel);

    group('validateFhirString', () {
      test('handles invalid JSON string', () async {
        const invalidJson = '{ "resourceType": "Patient", invalid }';

        final results = await validator.validateFhirString(
          structureToValidate: invalidJson,
        );

        expect(results.hasErrors, isTrue);
        expect(
          results.results.any(
            (r) => r.diagnostics.contains('Failed to parse resource JSON'),
          ),
          isTrue,
        );
      });

      test('handles missing resourceType', () async {
        const jsonString = '''
        {
          "id": "example",
          "name": [{
            "family": "Doe"
          }]
        }
        ''';

        final results = await validator.validateFhirString(
          structureToValidate: jsonString,
        );

        expect(results.hasErrors, isTrue);
        expect(
          results.results.any(
            (r) => r.diagnostics.contains('ResourceType is missing'),
          ),
          isTrue,
        );
      });
    });

    group('validateFhirMap', () {
      test('handles missing resourceType in map', () async {
        final invalidMap = {
          'id': 'example',
          'name': [
            {'family': 'Doe'},
          ],
        };

        final results = await validator.validateFhirMap(
          structureToValidate: invalidMap,
        );

        expect(results.hasErrors, isTrue);
        expect(
          results.results.any(
            (r) => r.diagnostics.contains('ResourceType is missing'),
          ),
          isTrue,
        );
      });
    });
  });

  /// The engine looks every canonical up in a [ResourceCache]. Until this
  /// seam existed it built its own empty [CanonicalResourceCache] per call
  /// and there was no way to give it one.
  group('the resource cache seam', () {
    test('the default cache resolves nothing, and says so', () async {
      final results = await const FhirValidationEngine(
        testModel,
      ).validateFhirMap(
        structureToValidate: {'resourceType': 'Patient', 'id': 'p1'},
      );

      expect(
        results.results.map((r) => r.diagnostics),
        contains(contains('No StructureDefinition found for resourceType')),
      );
    });

    test('a supplied cache is what the type is looked up in', () async {
      final cache = CanonicalResourceCache()..see(patientDefinition);

      final results = await const FhirValidationEngine(
        testModel,
      ).validateFhirMap(
        structureToValidate: {'resourceType': 'Patient', 'id': 'p1'},
        resourceCache: cache,
      );

      expect(
        results.results.map((r) => r.diagnostics),
        isNot(contains(contains('No StructureDefinition found'))),
      );
      expect(results.hasErrors, isFalse);
    });

    test('validateFhirString passes the cache through', () async {
      final cache = CanonicalResourceCache()..see(patientDefinition);

      final results = await const FhirValidationEngine(
        testModel,
      ).validateFhirString(
        structureToValidate: '{"resourceType":"Patient","id":"p1"}',
        resourceCache: cache,
      );

      expect(
        results.results.map((r) => r.diagnostics),
        isNot(contains(contains('No StructureDefinition found'))),
      );
    });

    test('a given StructureDefinition is used without a lookup', () async {
      final results = await const FhirValidationEngine(
        testModel,
      ).validateFhirMap(
        structureToValidate: {'resourceType': 'Patient', 'id': 'p1'},
        structureDefinition: patientDefinition,
      );
      expect(results.hasErrors, isFalse);
    });

    test('an element the definition does not know is an error', () async {
      final results = await const FhirValidationEngine(
        testModel,
      ).validateFhirMap(
        structureToValidate: {
          'resourceType': 'Patient',
          'id': 'p1',
          'nickname': 'x',
        },
        structureDefinition: patientDefinition,
      );
      expect(
        results.results.map((r) => r.diagnostics),
        contains(contains('Element not found in StructureDefinition')),
      );
    });
  });
}
