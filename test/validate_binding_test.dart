import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:test/test.dart';

import 'support/test_model.dart';

// Test ResourceCache that provides ValueSets
class _TestResourceCache extends CanonicalResourceCache {
  _TestResourceCache() {
    _valueSets['http://hl7.org/fhir/ValueSet/observation-status'] = resource({
      'resourceType': 'ValueSet',
      'id': 'observation-status',
      'url': 'http://hl7.org/fhir/ValueSet/observation-status',
      'name': 'ObservationStatus',
      'status': 'active',
      'compose': {
        'include': [
          {
            'system': 'http://hl7.org/fhir/observation-status',
            'concept': [
              {'code': 'registered'},
              {'code': 'preliminary'},
              {'code': 'final'},
              {'code': 'amended'},
              {'code': 'corrected'},
              {'code': 'cancelled'},
              {'code': 'entered-in-error'},
              {'code': 'unknown'},
            ],
          },
        ],
      },
    });
    _valueSets['http://example.org/ValueSet/test'] = resource({
      'resourceType': 'ValueSet',
      'id': 'test',
      'url': 'http://example.org/ValueSet/test',
      'name': 'TestValueSet',
      'status': 'active',
      'compose': {
        'include': [
          {
            'system': 'http://example.org/test',
            'concept': [
              {'code': 'some-code'},
              {'code': 'other-code'},
            ],
          },
        ],
      },
    });
    _valueSets['http://hl7.org/fhir/ValueSet/observation-category'] = resource({
      'resourceType': 'ValueSet',
      'id': 'observation-category',
      'url': 'http://hl7.org/fhir/ValueSet/observation-category',
      'name': 'ObservationCategory',
      'status': 'active',
      'compose': {
        'include': [
          {
            'system':
                'http://terminology.hl7.org/CodeSystem/observation-category',
            'concept': [
              {'code': 'social-history'},
              {'code': 'vital-signs'},
              {'code': 'imaging'},
              {'code': 'laboratory'},
              {'code': 'procedure'},
              {'code': 'survey'},
              {'code': 'exam'},
              {'code': 'therapy'},
            ],
          },
        ],
      },
    });
  }
  final Map<String, FhirNode> _valueSets = {};

  @override
  Future<FhirNode?> getCanonicalResource(String url, [String? version]) async {
    final cached = _valueSets[url];
    if (cached != null) {
      return cached;
    }
    return super.getCanonicalResource(url, version);
  }
}

void main() {
  group('validateBindings', () {
    Future<ValidationResults> run(
      Node node,
      Map<String, ElementNode> elements,
    ) => validateBindings(
      node: node,
      elements: elements,
      results: ValidationResults(),
      resourceCache: _TestResourceCache(),
    );

    test('validates code against value set successfully', () async {
      final node = ObjectNode(path: 'Observation')
        ..children.add(
          PropertyNode(path: 'Observation.status')
            ..key = ValueNode('status', 'status')
            ..value = LiteralNode('final', 'final', path: 'Observation.status'),
        );

      final validationResults = await run(node, {
        'Observation.status': typed(
          'Observation.status',
          'code',
          binding: {
            'strength': 'required',
            'valueSet': 'http://hl7.org/fhir/ValueSet/observation-status',
          },
        ),
      });

      expect(validationResults.results, isEmpty);
    });

    test('a required binding rejects an unknown code as an error', () async {
      final node = ObjectNode(path: 'Observation')
        ..children.add(
          PropertyNode(path: 'Observation.status')
            ..key = ValueNode('status', 'status')
            ..value = LiteralNode(
              'invalid-code',
              'invalid-code',
              path: 'Observation.status',
            ),
        );

      final validationResults = await run(node, {
        'Observation.status': typed(
          'Observation.status',
          'code',
          binding: {
            'strength': 'required',
            'valueSet': 'http://hl7.org/fhir/ValueSet/observation-status',
          },
        ),
      });

      final diagnostic = validationResults.results.single;
      expect(diagnostic.severity, Severity.error);
      expect(
        diagnostic.diagnostics,
        'Code "invalid-code" is not valid according to ValueSet '
        'http://hl7.org/fhir/ValueSet/observation-status',
      );
    });

    test(
      'an extensible binding reports an unknown code as a warning',
      () async {
        final node = ObjectNode(path: 'Observation')
          ..children.add(
            PropertyNode(path: 'Observation.status')
              ..key = ValueNode('status', 'status')
              ..value = LiteralNode(
                'bogus',
                'bogus',
                path: 'Observation.status',
              ),
          );

        final validationResults = await run(node, {
          'Observation.status': typed(
            'Observation.status',
            'code',
            binding: {
              'strength': 'extensible',
              'valueSet': 'http://hl7.org/fhir/ValueSet/observation-status',
            },
          ),
        });

        expect(validationResults.results.single.severity, Severity.warning);
      },
    );

    test('a repeating coded element is checked item by item', () async {
      final node = ObjectNode(path: 'Observation')
        ..children.add(
          PropertyNode(path: 'Observation.status')
            ..key = ValueNode('status', 'status')
            ..value = (ArrayNode(path: 'Observation.status')
              ..children.addAll([
                LiteralNode('final', 'final', path: 'Observation.status[0]'),
                LiteralNode('bogus', 'bogus', path: 'Observation.status[1]'),
              ])),
        );

      final validationResults = await run(node, {
        'Observation.status': typed(
          'Observation.status',
          'code',
          binding: {
            'strength': 'required',
            'valueSet': 'http://hl7.org/fhir/ValueSet/observation-status',
          },
        ),
      });

      expect(
        validationResults.results.map((r) => r.diagnostics),
        [contains('Code "bogus" is not valid')],
      );
    });

    test('handles element without binding', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.id')
            ..key = ValueNode('id', 'id')
            ..value = LiteralNode('12345', '12345', path: 'Patient.id'),
        );

      final validationResults = await run(node, {
        'Patient.id': typed('Patient.id', 'string'),
      });

      // Should have no binding-related errors
      expect(
        validationResults.results.where(
          (r) => r.diagnostics.contains('ValueSet'),
        ),
        isEmpty,
      );
    });

    test('handles element with binding but no valueSet', () async {
      final node = ObjectNode(path: 'Observation')
        ..children.add(
          PropertyNode(path: 'Observation.status')
            ..key = ValueNode('status', 'status')
            ..value = LiteralNode('final', 'final', path: 'Observation.status'),
        );

      final validationResults = await run(node, {
        'Observation.status': typed(
          'Observation.status',
          'code',
          binding: {'strength': 'required'},
        ),
      });

      expect(validationResults.results, isEmpty);
    });

    test('a value set that includes another, and a CodeSystem', () async {
      final cache =
          CanonicalResourceCache()
            ..see(
              resource({
                'resourceType': 'CodeSystem',
                'url': 'http://example.org/cs',
                'concept': [
                  {
                    'code': 'parent',
                    'concept': [
                      {'code': 'child'},
                    ],
                  },
                ],
              }),
            )
            ..see(
              resource({
                'resourceType': 'ValueSet',
                'url': 'http://example.org/vs/inner',
                'compose': {
                  'include': [
                    {
                      'concept': [
                        {'code': 'inner'},
                      ],
                    },
                  ],
                },
                'expansion': {
                  'contains': [
                    {'code': 'expanded'},
                  ],
                },
              }),
            )
            ..see(
              resource({
                'resourceType': 'ValueSet',
                'url': 'http://example.org/vs/outer',
                'compose': {
                  'include': [
                    {
                      'valueSet': ['http://example.org/vs/inner'],
                    },
                    {'system': 'http://example.org/cs'},
                  ],
                },
              }),
            );

      expect(
        await getValueSetCodes('http://example.org/vs/outer', cache),
        {'inner', 'expanded', 'parent', 'child'},
      );
      expect(
        () => getValueSetCodes('http://example.org/missing', cache),
        throwsException,
      );
    });
  });
}
