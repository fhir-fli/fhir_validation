import 'package:fhir_node/fhir_node.dart';
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

    // A complex element's type is looked up by its type code, which
    // ElementDefinition.type.code (profiles-types.ndjson, 4.3.0) makes
    // relative to http://hl7.org/fhir/StructureDefinition. The lookups for
    // a nested element asked for the bare code, `HumanName`, which no cache
    // keyed by canonical URL holds.
    test('a data type is found from its type code', () async {
      final cache =
          CanonicalResourceCache()
            ..see(_patientWithName)
            ..see(_humanName);

      final results = await const FhirValidationEngine(
        testModel,
      ).validateFhirMap(
        structureToValidate: {
          'resourceType': 'Patient',
          'id': 'p1',
          'name': [
            {'family': 'Doe'},
          ],
        },
        resourceCache: cache,
      );

      expect(
        results.results.map((r) => r.diagnostics),
        isNot(contains(contains('No StructureDefinition'))),
      );
      expect(results.hasErrors, isFalse);
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

/// Patient with an id and a name of type HumanName.
final JsonNode _patientWithName = resource({
  'resourceType': 'StructureDefinition',
  'id': 'Patient',
  'url': 'http://hl7.org/fhir/StructureDefinition/Patient',
  'name': 'Patient',
  'status': 'active',
  'kind': 'resource',
  'abstract': false,
  'type': 'Patient',
  'baseDefinition': 'http://hl7.org/fhir/StructureDefinition/DomainResource',
  'derivation': 'specialization',
  'snapshot': {
    'element': [
      {'id': 'Patient', 'path': 'Patient', 'min': 0, 'max': '*'},
      {
        'id': 'Patient.id',
        'path': 'Patient.id',
        'min': 0,
        'max': '1',
        'type': [
          {'code': 'http://hl7.org/fhirpath/System.String'},
        ],
      },
      {
        'id': 'Patient.name',
        'path': 'Patient.name',
        'min': 0,
        'max': '*',
        'type': [
          {'code': 'HumanName'},
        ],
      },
    ],
  },
});

/// HumanName with a family of the System String type, at its canonical.
final JsonNode _humanName = resource({
  'resourceType': 'StructureDefinition',
  'id': 'HumanName',
  'url': 'http://hl7.org/fhir/StructureDefinition/HumanName',
  'name': 'HumanName',
  'status': 'active',
  'kind': 'complex-type',
  'abstract': false,
  'type': 'HumanName',
  'baseDefinition': 'http://hl7.org/fhir/StructureDefinition/Element',
  'derivation': 'specialization',
  'snapshot': {
    'element': [
      {'id': 'HumanName', 'path': 'HumanName', 'min': 0, 'max': '*'},
      {
        'id': 'HumanName.family',
        'path': 'HumanName.family',
        'min': 0,
        'max': '1',
        'type': [
          {'code': 'http://hl7.org/fhirpath/System.String'},
        ],
      },
    ],
  },
});
