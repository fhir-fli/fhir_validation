import 'package:fhir_validation/fhir_validation.dart';
import 'package:test/test.dart';

import 'support/test_model.dart';

void main() {
  group('validateCardinality', () {
    Future<ValidationResults> run(
      ObjectNode node,
      Map<String, ElementNode> elements,
    ) => validateCardinality(
      node: node,
      elements: elements,
      originalPath: 'Patient',
      replacePath: 'Patient',
      results: ValidationResults(),
      resourceCache: CanonicalResourceCache(),
    );

    test('validates element with correct cardinality', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.id')
            ..key = ValueNode('id', 'id')
            ..value = LiteralNode('12345', '12345', path: 'Patient.id'),
        );

      final validationResults = await run(node, {
        'Patient.id': typed('Patient.id', 'string', min: 0, max: '1'),
      });

      // Should have no errors for correct cardinality
      expect(
        validationResults.results.where((r) => r.severity == Severity.error),
        isEmpty,
      );
    });

    test('reports error for missing required element (min > 0)', () async {
      final validationResults = await run(ObjectNode(path: 'Patient'), {
        'Patient.name': typed('Patient.name', 'HumanName', min: 1, max: '*'),
      });

      // Should have error for missing required element
      expect(validationResults.missingResults, isNotEmpty);
      expect(
        validationResults.missingResults.first.diagnostics,
        contains('minimum required'),
      );
    });

    test('reports error for too many occurrences (exceeds max)', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.identifier')
            ..key = ValueNode('identifier', 'identifier')
            ..value = (ArrayNode(path: 'Patient.identifier')
              ..children.addAll([
                ObjectNode(path: 'Patient.identifier[0]'),
                ObjectNode(path: 'Patient.identifier[1]'),
                ObjectNode(path: 'Patient.identifier[2]'),
              ])),
        );

      final validationResults = await run(node, {
        'Patient.identifier': typed(
          'Patient.identifier',
          'Identifier',
          min: 0,
          max: '2',
        ),
      });

      // Should have error for exceeding max
      expect(validationResults.results, isNotEmpty);
      expect(
        validationResults.results.any(
          (r) => r.diagnostics.contains('maximum allowed'),
        ),
        isTrue,
      );
    });

    test('validates array with correct cardinality', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.name')
            ..key = ValueNode('name', 'name')
            ..value = ArrayNode(path: 'Patient.name')
            ..children.addAll([
              ObjectNode(path: 'Patient.name[0]'),
              ObjectNode(path: 'Patient.name[1]'),
            ]),
        );

      final validationResults = await run(node, {
        'Patient.name': typed('Patient.name', 'HumanName', min: 0, max: '*'),
      });

      // Should have no errors
      expect(
        validationResults.results.where((r) => r.severity == Severity.error),
        isEmpty,
      );
    });

    test('validates element with min=0 (optional element)', () async {
      final validationResults = await run(ObjectNode(path: 'Patient'), {
        'Patient.birthDate': typed(
          'Patient.birthDate',
          'date',
          min: 0,
          max: '1',
        ),
      });

      // Should have no errors for optional element
      expect(
        validationResults.results.where((r) => r.severity == Severity.error),
        isEmpty,
      );
    });

    test('validates element with max=* (unbounded)', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.name')
            ..key = ValueNode('name', 'name')
            ..value = ArrayNode(path: 'Patient.name')
            ..children.addAll([
              ObjectNode(path: 'Patient.name[0]'),
              ObjectNode(path: 'Patient.name[1]'),
              ObjectNode(path: 'Patient.name[2]'),
              ObjectNode(path: 'Patient.name[3]'),
            ]),
        );

      final validationResults = await run(node, {
        'Patient.name': typed('Patient.name', 'HumanName', min: 0, max: '*'),
      });

      // Should have no errors for unbounded max
      expect(
        validationResults.results.where((r) => r.severity == Severity.error),
        isEmpty,
      );
    });

    test('a required element that is present but empty is reported', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.name')
            ..key = ValueNode('name', 'name')
            ..value = ObjectNode(path: 'Patient.name'),
        );

      final validationResults = await run(node, {
        'Patient.name': typed('Patient.name', 'HumanName', min: 1, max: '*'),
      });

      expect(
        validationResults.results.map((r) => r.diagnostics),
        contains(contains('Required element is not populated')),
      );
    });

    test('validates nested element cardinality', () async {
      final node = ObjectNode(path: 'Patient')
        ..children.add(
          PropertyNode(path: 'Patient.name')
            ..key = ValueNode('name', 'name')
            ..value = ArrayNode(path: 'Patient.name')
            ..children.add(
              ObjectNode(path: 'Patient.name[0]')
                ..children.add(
                  PropertyNode(path: 'Patient.name[0].given')
                    ..key = ValueNode('given', 'given')
                    ..value = ArrayNode(path: 'Patient.name[0].given')
                    ..children.add(
                      LiteralNode(
                        'John',
                        'John',
                        path: 'Patient.name[0].given[0]',
                      ),
                    ),
                ),
            ),
        );

      final validationResults = await run(node, {
        'Patient.name': typed('Patient.name', 'HumanName', min: 0, max: '*'),
        'Patient.name.given': typed(
          'Patient.name.given',
          'string',
          min: 0,
          max: '*',
        ),
      });

      // Should have no errors
      expect(
        validationResults.results.where((r) => r.severity == Severity.error),
        isEmpty,
      );
    });
  });
}
