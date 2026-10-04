import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:test/test.dart';

import 'support/test_model.dart';

void main() {
  group('validateStructure Tests', () {
    test('Validates a simple ObjectNode successfully', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.id')
            ..key = ValueNode('id', 'id')
            ..value = LiteralNode('12345', '12345', path: 'Patient.id'),
        );
      final elements = {'Patient.id': typed('Patient.id', 'string')};

      final results = await validateStructure(
        model: testModel,
        node: node,
        elements: elements,
        type: 'Patient',
        resourceCache: CanonicalResourceCache(),
      );

      expect(results.results, isEmpty); // No errors expected
    });

    test('Reports missing fields in ObjectNode', () async {
      // Create a node with a property that's NOT in the StructureDefinition
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.unknownField')
            ..key = ValueNode('unknownField', 'unknownField')
            ..value = LiteralNode('test', 'test', path: 'Patient.unknownField'),
        );

      final results = await validateStructure(
        model: testModel,
        node: node,
        elements: {},
        type: 'Patient',
        resourceCache: CanonicalResourceCache(),
      );

      expect(results.results, isNotEmpty);
      expect(
        results.results.first.diagnostics,
        contains('Element not found in StructureDefinition'),
      );
    });

    test(
      'a resourceType property of a known type is not an unknown element',
      () async {
        final node = ObjectNode(path: 'Patient')
          ..children.add(
            PropertyNode(path: 'Patient.resourceType')
              ..key = ValueNode('resourceType', 'resourceType')
              ..value = LiteralNode(
                'Patient',
                'Patient',
                path: 'Patient.resourceType',
              ),
          );

        final results = await validateStructure(
          model: testModel,
          node: node,
          elements: {},
          type: 'Patient',
          resourceCache: CanonicalResourceCache(),
        );

        expect(results.results, isEmpty);
      },
    );

    test('Validates nested properties in ObjectNode', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.name')
            ..key = ValueNode('name', 'name')
            ..value = (ArrayNode(path: 'Patient.name')
              ..children.add(
                ObjectNode(path: 'Patient.name[0]')
                  ..children.add(
                    PropertyNode(path: 'Patient.name[0].given')
                      ..key = ValueNode('given', 'given')
                      ..value = LiteralNode(
                        'John',
                        'John',
                        path: 'Patient.name[0].given',
                      ),
                  ),
              )),
        );
      final elements = {
        'Patient.name': typed('Patient.name', 'HumanName'),
        'Patient.name.given': typed('Patient.name.given', 'string'),
      };
      // Create a minimal StructureDefinition for HumanName
      final humanNameStructureDefinition = resource({
        'resourceType': 'StructureDefinition',
        'id': 'HumanName',
        'url': 'http://hl7.org/fhir/StructureDefinition/HumanName',
        'name': 'HumanName',
        'type': 'HumanName',
        'kind': 'complex-type',
        'abstract': false,
        'status': 'active',
        'snapshot': {
          'element': [
            {'path': 'HumanName', 'min': 0, 'max': '1'},
            {
              'path': 'HumanName.given',
              'min': 0,
              'max': '*',
              'type': [
                {'code': 'string'},
              ],
            },
          ],
        },
      });
      // Create a resourceCache that can return the HumanName
      // StructureDefinition.
      final resourceCache = _TestResourceCache(humanNameStructureDefinition);

      final results = await validateStructure(
        model: testModel,
        node: node,
        elements: elements,
        type: 'Patient',
        resourceCache: resourceCache,
      );

      expect(results.results, isEmpty); // No errors expected
    });

    test('Fails validation for invalid primitive value', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.active')
            ..key = ValueNode('active', 'active')
            ..value = LiteralNode('yes', 'yes', path: 'Patient.active'),
        );

      final results = await validateStructure(
        model: testModel,
        node: node,
        elements: {'Patient.active': typed('Patient.active', 'boolean')},
        type: 'Patient',
        resourceCache: CanonicalResourceCache(),
      );

      expect(
        results.results.map((r) => r.diagnostics),
        contains('Invalid value for primitive type: boolean'),
      );
    });

    test('a required binding rejects a code outside the value set', () async {
      final node = ObjectNode(path: 'Observation')
        ..children.add(
          PropertyNode(path: 'Observation.status')
            ..key = ValueNode('status', 'status')
            ..value = LiteralNode('bogus', 'bogus', path: 'Observation.status'),
        );
      final cache =
          CanonicalResourceCache()..see(
            resource({
              'resourceType': 'ValueSet',
              'url': 'http://example.org/vs/status',
              'compose': {
                'include': [
                  {
                    'system': 'http://example.org/cs',
                    'concept': [
                      {'code': 'final'},
                      {'code': 'amended'},
                    ],
                  },
                ],
              },
            }),
          );

      final results = await validateStructure(
        model: testModel,
        node: node,
        elements: {
          'Observation.status': typed(
            'Observation.status',
            'code',
            binding: {
              'strength': 'required',
              'valueSet': 'http://example.org/vs/status',
            },
          ),
        },
        type: 'Observation',
        resourceCache: cache,
      );

      expect(
        results.results.map((r) => r.diagnostics),
        contains(
          contains('"bogus" is not a valid code in the required value set'),
        ),
      );
    });

    test('a string pattern and a numeric range are checked', () async {
      final node = ObjectNode(path: 'Observation')
        ..children.addAll([
          PropertyNode(path: 'Observation.id')
            ..key = ValueNode('id', 'id')
            ..value = LiteralNode(
              'no spaces',
              'no spaces',
              path: 'Observation.id',
            ),
          PropertyNode(path: 'Observation.valueInteger')
            ..key = ValueNode('valueInteger', 'valueInteger')
            ..value = LiteralNode(7, '7', path: 'Observation.valueInteger'),
        ]);

      final results = await validateStructure(
        model: testModel,
        node: node,
        elements: {
          'Observation.id': element({
            'path': 'Observation.id',
            'type': [
              {'code': 'string'},
            ],
            'patternString': r'^[A-Za-z0-9\-\.]+$',
          }),
          'Observation.value[x]': element({
            'path': 'Observation.value[x]',
            'type': [
              {'code': 'integer'},
              {'code': 'string'},
            ],
            'minValueInteger': 10,
            'maxValueInteger': 20,
          }),
        },
        type: 'Observation',
        resourceCache: CanonicalResourceCache(),
      );

      final diagnostics = results.results.map((r) => r.diagnostics).toList();
      expect(
        diagnostics,
        contains(contains('does not match the required pattern')),
      );
      expect(
        diagnostics,
        contains(contains('less than the minimum allowed value: 10')),
      );
    });

    test('a date that does not parse is reported', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.birthDate')
            ..key = ValueNode('birthDate', 'birthDate')
            ..value = LiteralNode(
              'yesterday',
              'yesterday',
              path: 'Patient.birthDate',
            ),
        );
      final results = await validateStructure(
        model: testModel,
        node: node,
        elements: {'Patient.birthDate': typed('Patient.birthDate', 'date')},
        type: 'Patient',
        resourceCache: CanonicalResourceCache(),
      );
      expect(
        results.results.map((r) => r.diagnostics),
        contains('Value "yesterday" is not a valid date format.'),
      );
    });
  });
}

// Test ResourceCache that provides StructureDefinitions
class _TestResourceCache extends CanonicalResourceCache {
  _TestResourceCache(FhirNode? humanName) {
    if (humanName != null) {
      _cache['HumanName'] = humanName;
      _cache['http://hl7.org/fhir/StructureDefinition/HumanName'] = humanName;
    }
  }
  final Map<String, FhirNode> _cache = {};

  @override
  Future<FhirNode?> getStructureDefinition(String? type) async {
    if (type == null) return null;
    final cached =
        _cache[type] ?? _cache['http://hl7.org/fhir/StructureDefinition/$type'];
    if (cached != null) return cached;
    return super.getStructureDefinition(type);
  }
}
