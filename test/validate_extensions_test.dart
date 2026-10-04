import 'package:fhir_validation/fhir_validation.dart';
import 'package:test/test.dart';

import 'support/test_model.dart';

void main() {
  group('validateExtensions', () {
    test('validates extension structure successfully', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.extension')
            ..key = ValueNode('extension', 'extension')
            ..value = ArrayNode(path: 'Patient.extension')
            ..children.add(
              ObjectNode(path: 'Patient.extension[0]')
                ..children.addAll([
                  PropertyNode(path: 'Patient.extension[0].url')
                    ..key = ValueNode('url', 'url')
                    ..value = LiteralNode(
                      'http://example.org/fhir/StructureDefinition/example-extension',
                      'http://example.org/fhir/StructureDefinition/example-extension',
                      path: 'Patient.extension[0].url',
                    ),
                  PropertyNode(path: 'Patient.extension[0].valueString')
                    ..key = ValueNode('valueString', 'valueString')
                    ..value = LiteralNode(
                      'test',
                      'test',
                      path: 'Patient.extension[0].valueString',
                    ),
                ]),
            ),
        );

      final elements = {
        'Patient.extension': typed(
          'Patient.extension',
          'Extension',
          profile: [
            'http://example.org/fhir/StructureDefinition/example-extension',
          ],
        ),
      };
      final results = ValidationResults();
      final resourceCache = CanonicalResourceCache();

      final validationResults = await validateExtensions(
        model: testModel,
        node: node,
        elements: elements,
        results: results,
        resourceCache: resourceCache,
      );

      expect(validationResults, isNotNull);
      expect(validationResults.results, isA<List<ValidationDiagnostics>>());
    });

    test('an extension profile in the cache validates the extension', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.extension')
            ..key = ValueNode('extension', 'extension')
            ..value = (ObjectNode(path: 'Patient.extension')
              ..children.add(
                PropertyNode(path: 'Patient.extension.bogus')
                  ..key = ValueNode('bogus', 'bogus')
                  ..value = LiteralNode(
                    'x',
                    'x',
                    path: 'Patient.extension.bogus',
                  ),
              )),
        );
      final extensionDefinition = resource({
        'resourceType': 'StructureDefinition',
        'url': 'http://example.org/ext',
        'snapshot': {
          'element': [
            {
              'path': 'Extension.url',
              'type': [
                {'code': 'uri'},
              ],
            },
          ],
        },
      });
      final cache = CanonicalResourceCache()..see(extensionDefinition);

      final validationResults = await validateExtensions(
        model: testModel,
        node: node,
        elements: {
          'Patient.extension': typed(
            'Patient.extension',
            'Extension',
            profile: ['http://example.org/ext'],
          ),
        },
        results: ValidationResults(),
        resourceCache: cache,
      );

      expect(
        validationResults.results.map((r) => r.diagnostics),
        contains(contains('Element not found in StructureDefinition')),
      );
    });

    test('handles extension without profile URL', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.extension')
            ..key = ValueNode('extension', 'extension')
            ..value = ArrayNode(path: 'Patient.extension')
            ..children.add(
              ObjectNode(path: 'Patient.extension[0]')
                ..children.add(
                  PropertyNode(path: 'Patient.extension[0].url')
                    ..key = ValueNode('url', 'url')
                    ..value = LiteralNode(
                      'http://example.org/extension',
                      'http://example.org/extension',
                      path: 'Patient.extension[0].url',
                    ),
                ),
            ),
        );

      final validationResults = await validateExtensions(
        model: testModel,
        node: node,
        elements: {
          'Patient.extension': typed('Patient.extension', 'Extension'),
        },
        results: ValidationResults(),
        resourceCache: CanonicalResourceCache(),
      );

      expect(validationResults, isNotNull);
      // May not validate if StructureDefinition cannot be fetched
    });

    test('handles element without extension type', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.id')
            ..key = ValueNode('id', 'id')
            ..value = LiteralNode('12345', '12345', path: 'Patient.id'),
        );

      final validationResults = await validateExtensions(
        model: testModel,
        node: node,
        elements: {'Patient.id': typed('Patient.id', 'string')},
        results: ValidationResults(),
        resourceCache: CanonicalResourceCache(),
      );

      // Should have no extension-related errors
      expect(
        validationResults.results.where(
          (r) => r.diagnostics.contains('Extension'),
        ),
        isEmpty,
      );
    });

    test('handles invalid extension node type', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.extension')
            ..key = ValueNode('extension', 'extension')
            ..value = LiteralNode(
              'invalid',
              'invalid',
              path: 'Patient.extension',
            ),
        );

      final validationResults = await validateExtensions(
        model: testModel,
        node: node,
        elements: {
          'Patient.extension': typed('Patient.extension', 'Extension'),
        },
        results: ValidationResults(),
        resourceCache: CanonicalResourceCache(),
      );

      // Should have error for invalid extension node type
      expect(
        validationResults.results.any(
          (r) => r.diagnostics.contains('Extension must be an ObjectNode'),
        ),
        isTrue,
      );
    });
  });
}
