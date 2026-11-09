import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_r4_validation/fhir_r4_validation.dart' show r4Validation;
import 'package:fhir_validation/fhir_validation.dart';
import 'package:test/test.dart';

import 'support/test_model.dart';

/// Where this validator reports what HL7's InstanceValidator reports
/// (hapifhir/org.hl7.fhir.core master f6d3c306, read 2026-11-09).
///
/// Invariants run through the R4B model, because evaluating a constraint
/// needs a version's FHIRPath binding; the constraints are copied verbatim
/// from the published hl7.fhir.r4b.core 4.3.0 StructureDefinitions.
void main() {
  const ns = 'xmlns="http://www.w3.org/1999/xhtml"';

  // Narrative.div, hl7.fhir.r4b.core 4.3.0 StructureDefinition-Narrative.json.
  final narrativeDiv = element({
    'path': 'Narrative.div',
    'type': [
      {'code': 'xhtml'},
    ],
    'constraint': [
      {
        'key': 'txt-1',
        'severity': 'error',
        'human':
            'The narrative SHALL contain only the basic html formatting '
            'elements and attributes described in chapters 7-11 (except '
            'section 4 of chapter 9) and 15 of the HTML 4.0 standard, <a> '
            'elements (either name or href), images and internally '
            'contained style attributes',
        'expression': 'htmlChecks()',
      },
      {
        'key': 'txt-2',
        'severity': 'error',
        'human': 'The narrative SHALL have some non-whitespace content',
        'expression': 'htmlChecks()',
      },
    ],
  });

  Future<ValidationResults> div(String xhtml) => validateInvariants(
    model: r4Validation,
    node: LiteralNode(xhtml, xhtml, path: 'Patient.text.div'),
    element: narrativeDiv,
    results: ValidationResults(),
    resourceCache: CanonicalResourceCache(),
  );

  group('a failed constraint is reported at its own severity', () {
    // InstanceValidator.checkInvariant: ConstraintSeverity.ERROR -> ruleInv
    // (an error), WARNING -> warningInv, best practice -> the bpWarnings
    // setting, whose default (ValidatorSettings) is Warning.
    Future<ValidationResults> failing(Map<String, dynamic> constraint) =>
        validateInvariants(
          model: r4Validation,
          node: LiteralNode('x', 'x', path: 'Patient.id'),
          element: element({
            'path': 'Patient.id',
            'type': [
              {'code': 'string'},
            ],
            'constraint': [
              {'human': 'never true', 'expression': 'false', ...constraint},
            ],
          }),
          results: ValidationResults(),
          resourceCache: CanonicalResourceCache(),
        );

    test('severity error is an error, and names the key', () async {
      final r = await failing({'key': 'x-1', 'severity': 'error'});
      expect([for (final d in r.results) d.severity], [Severity.error]);
      expect(r.results.single.diagnostics, contains('x-1'));
    });

    test('severity warning is a warning', () async {
      final r = await failing({'key': 'x-2', 'severity': 'warning'});
      expect([for (final d in r.results) d.severity], [Severity.warning]);
    });

    test('a best-practice constraint is a warning', () async {
      final r = await failing({
        'key': 'dom-6',
        'severity': 'warning',
        'extension': [
          {
            'url':
                'http://hl7.org/fhir/StructureDefinition/'
                'elementdefinition-bestpractice',
            'valueBoolean': true,
          },
        ],
      });
      expect([for (final d in r.results) d.severity], [Severity.warning]);
    });
  });

  test('a repeating element is constrained item by item', () async {
    final names = ArrayNode(path: 'Patient.name')
      ..children.addAll([
        ObjectNode(path: 'Patient.name[0]')
          ..children.add(
            PropertyNode(path: 'Patient.name[0].family')
              ..key = ValueNode('family', 'family')
              ..value = LiteralNode(
                'Doe',
                'Doe',
                path: 'Patient.name[0].family',
              ),
          ),
        ObjectNode(path: 'Patient.name[1]')
          ..children.add(
            PropertyNode(path: 'Patient.name[1].text')
              ..key = ValueNode('text', 'text')
              ..value = LiteralNode('Jo', 'Jo', path: 'Patient.name[1].text'),
          ),
      ]);
    final r = await validateInvariants(
      model: r4Validation,
      node:
          PropertyNode(path: 'Patient.name')
            ..key = ValueNode('name', 'name')
            ..value = names,
      element: element({
        'path': 'Patient.name',
        'type': [
          {'code': 'HumanName'},
        ],
        'constraint': [
          {
            'key': 'x-family',
            'severity': 'error',
            'human': 'a family name',
            'expression': 'family.exists()',
          },
        ],
      }),
      results: ValidationResults(),
      resourceCache: CanonicalResourceCache(),
    );
    expect(
      [for (final d in r.results) '${d.path} ${d.severity}'],
      ['Patient.name[1] error'],
    );
  });

  group('inline structures and contained resources are read in full', () {
    Future<List<String>> run(
      Node node,
      Map<String, dynamic> elementJson,
    ) async {
      final r = await validateInvariants(
        model: r4Validation,
        node: node,
        element: element(elementJson),
        results: ValidationResults(),
        resourceCache: CanonicalResourceCache(),
      );
      return [for (final d in r.results) '${d.path} ${d.severity}'];
    }

    // DataRequirement.codeFilter, hl7.fhir.r4b.core 4.3.0 profiles-types.
    final codeFilter = {
      'path': 'DataRequirement.codeFilter',
      'type': [
        {'code': 'Element'},
      ],
      'constraint': [
        {
          'key': 'drq-1',
          'severity': 'error',
          'human':
              'Either a path or a searchParam must be provided, but not both',
          'expression': 'path.exists() xor searchParam.exists()',
        },
      ],
    };

    PropertyNode filters(List<Map<String, String>> items) {
      final array = ArrayNode(path: 'DataRequirement.codeFilter');
      for (var i = 0; i < items.length; i++) {
        final item = ObjectNode(path: 'DataRequirement.codeFilter[$i]');
        for (final e in items[i].entries) {
          item.children.add(
            PropertyNode(path: 'DataRequirement.codeFilter[$i].${e.key}')
              ..key = ValueNode(e.key, e.key)
              ..value = LiteralNode(
                e.value,
                e.value,
                path: 'DataRequirement.codeFilter[$i].${e.key}',
              ),
          );
        }
        array.children.add(item);
      }
      return PropertyNode(path: 'DataRequirement.codeFilter')
        ..key = ValueNode('codeFilter', 'codeFilter')
        ..value = array;
    }

    test('drq-1 holds for a codeFilter with a path, fails with both', () async {
      expect(
        await run(
          filters([
            {'path': 'category'},
            {'path': 'code', 'searchParam': 'code'},
          ]),
          codeFilter,
        ),
        ['DataRequirement.codeFilter[1] error'],
      );
    });

    test('a contained resource is read as the resource it names', () async {
      final contained = ArrayNode(path: 'List.contained');
      for (final (i, id) in [(0, 'a'), (1, null)]) {
        final item = ObjectNode(path: 'List.contained[$i]')
          ..children.add(
            PropertyNode(path: 'List.contained[$i].resourceType')
              ..key = ValueNode('resourceType', 'resourceType')
              ..value = LiteralNode(
                'Patient',
                'Patient',
                path: 'List.contained[$i].resourceType',
              ),
          );
        if (id != null) {
          item.children.add(
            PropertyNode(path: 'List.contained[$i].id')
              ..key = ValueNode('id', 'id')
              ..value = LiteralNode(id, id, path: 'List.contained[$i].id'),
          );
        }
        contained.children.add(item);
      }
      expect(
        await run(
          PropertyNode(path: 'List.contained')
            ..key = ValueNode('contained', 'contained')
            ..value = contained,
          {
            'path': 'List.contained',
            'type': [
              {'code': 'Resource'},
            ],
            'constraint': [
              {
                'key': 'x-id',
                'severity': 'error',
                'human': 'an id',
                'expression': 'id.exists()',
              },
            ],
          },
        ),
        ['List.contained[1] error'],
      );
    });
  });

  group('a narrative is checked by its constraints', () {
    test('a valid narrative reports nothing', () async {
      expect((await div('<div $ns><p>Jane Doe</p></div>')).results, isEmpty);
    });

    test('a javascript: link fails txt-1 as an error', () async {
      final r = await div('<div $ns><a href="javascript:alert(1)">x</a></div>');
      final diagnostics = [for (final d in r.results) d.diagnostics];
      expect(
        r.results.where(
          (d) =>
              d.severity == Severity.error && d.diagnostics.contains('txt-1'),
        ),
        hasLength(1),
        reason: '$diagnostics',
      );
      expect(diagnostics, isNot(contains(contains('Context is null'))));
      expect(
        r.results.where((d) => d.severity == Severity.information),
        isEmpty,
        reason: '$diagnostics',
      );
    });
  });

  group('a binding to a value set the cache does not hold', () {
    // InstanceValidator.validateBindingCodeableConcept (~1786): not found is
    // a warning, Terminology_TX_ValueSet_NotFound; a CodeSystem's url where
    // the value set belongs is an error, Terminology_TX_ValueSet_NotFound_CS.
    final elements = {
      'Patient.gender': typed(
        'Patient.gender',
        'code',
        binding: {
          'strength': 'required',
          'valueSet': 'http://example.org/ValueSet/missing',
        },
      ),
    };
    ObjectNode patient({String? gender}) {
      final node = ObjectNode(path: 'Patient');
      if (gender != null) {
        node.children.add(
          PropertyNode(path: 'Patient.gender')
            ..key = ValueNode('gender', 'gender')
            ..value = LiteralNode(gender, gender, path: 'Patient.gender'),
        );
      }
      return node;
    }

    test('is not looked up when the element is absent', () async {
      final r = await validateBindings(
        node: patient(),
        elements: elements,
        results: ValidationResults(),
        resourceCache: CanonicalResourceCache(),
      );
      expect(r.results, isEmpty);
    });

    test('is a warning when the element is present', () async {
      final r = await validateBindings(
        node: patient(gender: 'female'),
        elements: elements,
        results: ValidationResults(),
        resourceCache: CanonicalResourceCache(),
      );
      expect([for (final d in r.results) d.severity], [Severity.warning]);
      expect(
        r.results.single.diagnostics,
        contains("ValueSet 'http://example.org/ValueSet/missing' not found"),
      );
    });

    test("a CodeSystem's url in its place is an error", () async {
      final cache =
          CanonicalResourceCache()..see(
            JsonNode.resource({
              'resourceType': 'CodeSystem',
              'url': 'http://example.org/ValueSet/missing',
              'concept': [
                {'code': 'female'},
              ],
            }),
          );
      final r = await validateBindings(
        node: patient(gender: 'female'),
        elements: elements,
        results: ValidationResults(),
        resourceCache: cache,
      );
      expect([for (final d in r.results) d.severity], [Severity.error]);
      expect(
        r.results.single.diagnostics,
        contains(
          'Found a reference to a CodeSystem '
          "'http://example.org/ValueSet/missing' where a ValueSet belongs",
        ),
      );
    });

    test('in a structure check, is a warning, not a crash', () async {
      final r = await validateStructure(
        model: testModel,
        node: patient(gender: 'female'),
        elements: {
          'Patient': typed('Patient', 'Patient'),
          ...elements,
        },
        type: 'Patient',
        resourceCache: CanonicalResourceCache(),
      );
      expect(
        r.results.where(
          (d) =>
              d.severity == Severity.warning &&
              d.diagnostics.contains('not found'),
        ),
        hasLength(1),
        reason: '${[for (final d in r.results) d.diagnostics]}',
      );
    });
  });
}
