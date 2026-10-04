import 'package:fhir_validation/fhir_validation.dart';
import 'package:test/test.dart';

void main() {
  group('ValidationResults', () {
    test('initializes with empty results', () {
      final results = ValidationResults();

      expect(results.results, isEmpty);
      expect(results.missingResults, isEmpty);
      expect(results.hasErrors, isFalse);
    });

    test('addResult adds a new result', () {
      final results = ValidationResults();
      final node = LiteralNode('test', 'test', path: 'Patient.id');

      results.addResult(node, 'Test error message', Severity.error);

      expect(results.results, hasLength(1));
      expect(results.results.first.path, 'Patient.id');
      expect(results.results.first.diagnostics, 'Test error message');
      expect(results.results.first.severity, Severity.error);
      expect(results.hasErrors, isTrue);
    });

    test('addResult does not add duplicate results', () {
      final results = ValidationResults();
      final node = LiteralNode('test', 'test', path: 'Patient.id');

      results
        ..addResult(node, 'Test error message', Severity.error)
        ..addResult(node, 'Test error message', Severity.error);

      expect(results.results, hasLength(1));
    });

    test('addMissingResult adds a missing result', () {
      final results =
          ValidationResults()..addMissingResult(
            'Patient.name',
            'Name is required',
            Severity.error,
          );

      expect(results.missingResults, hasLength(1));
      expect(results.missingResults.first.path, 'Patient.name');
      expect(results.missingResults.first.diagnostics, 'Name is required');
      expect(results.missingResults.first.severity, Severity.error);
    });

    test('combineResults merges two ValidationResults', () {
      final results1 = ValidationResults();
      final results2 = ValidationResults();
      final node1 = LiteralNode('test1', 'test1', path: 'Patient.id');
      final node2 = LiteralNode('test2', 'test2', path: 'Patient.name');

      results1.addResult(node1, 'Error 1', Severity.error);
      results2
        ..addResult(node2, 'Error 2', Severity.warning)
        ..addMissingResult(
          'Patient.birthDate',
          'Birth date required',
          Severity.error,
        );

      results1.combineResults(results2);

      expect(results1.results, hasLength(2));
      expect(results1.missingResults, hasLength(1));
      expect(results1.hasErrors, isTrue);
    });

    test('hasErrors returns true when errors exist', () {
      final results = ValidationResults();
      final node = LiteralNode('test', 'test', path: 'Patient.id');

      results.addResult(node, 'Error message', Severity.error);

      expect(results.hasErrors, isTrue);
    });

    test('hasErrors returns false when only warnings exist', () {
      final results = ValidationResults();
      final node = LiteralNode('test', 'test', path: 'Patient.id');

      results.addResult(node, 'Warning message', Severity.warning);

      expect(results.hasErrors, isFalse);
    });

    test('toJson returns properly formatted JSON', () {
      final results = ValidationResults();
      final node1 = LiteralNode('test1', 'test1', path: 'Patient.id');
      final node2 = LiteralNode('test2', 'test2', path: 'Patient.name');
      final node3 = LiteralNode('test3', 'test3', path: 'Patient.birthDate');

      results
        ..addResult(node1, 'Error message', Severity.error)
        ..addResult(node2, 'Warning message', Severity.warning)
        ..addResult(node3, 'Info message', Severity.information);

      final json = results.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['error'], isA<List<dynamic>>());
      expect(json['warning'], isA<List<dynamic>>());
      expect(json['information'], isA<List<dynamic>>());
      expect(json['error'], hasLength(1));
      expect(json['warning'], hasLength(1));
      expect(json['information'], hasLength(1));
    });

    test('toOperationOutcomeJson converts results to an OperationOutcome', () {
      final results = ValidationResults();
      final node = LiteralNode('test', 'test', path: 'Patient.id');

      results.addResult(node, 'Error message', Severity.error);

      final outcome = results.toOperationOutcomeJson();

      expect(outcome['resourceType'], 'OperationOutcome');
      final issues = outcome['issue'] as List<dynamic>;
      expect(issues, hasLength(1));
      final issue = issues.single as Map<String, dynamic>;
      expect(issue['severity'], 'error');
      expect(issue['code'], 'processing');
      expect(issue['diagnostics'], 'Error message');
      expect(issue['location'], ['Patient.id']);
      expect(issue.containsKey('extension'), isFalse);
    });

    test('toOperationOutcomeJson orders errors, warnings, information', () {
      final results =
          ValidationResults()
            ..addResult(
              LiteralNode('i', 'i', path: 'a'),
              'Info',
              Severity.information,
            )
            ..addResult(
              LiteralNode('w', 'w', path: 'b'),
              'Warn',
              Severity.warning,
            )
            ..addResult(LiteralNode('e', 'e', path: 'c'), 'Err', Severity.error)
            ..addMissingResult('d', 'Missing', Severity.error);

      final issues =
          (results.toOperationOutcomeJson()['issue'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
      expect(
        issues.map((i) => i['severity']),
        ['error', 'error', 'warning', 'information'],
      );
      expect(issues.map((i) => i['diagnostics']), [
        'Err',
        'Missing',
        'Warn',
        'Info',
      ]);
    });

    test('toOperationOutcomeJson includes line and column information', () {
      final results = ValidationResults();
      final node = LiteralNode('test', 'test', path: 'Patient.id')
        ..loc = ValidationLocation(
          const Segment(5, 10, 0),
          const Segment(5, 10, 0),
        );

      results.addResult(node, 'Error message', Severity.error);

      final issue =
          (results.toOperationOutcomeJson()['issue'] as List<dynamic>).single
              as Map<String, dynamic>;
      expect(issue['location'], ['Patient.id', 'Line[5] Col[10]']);
      expect(issue['extension'], [
        {
          'url':
              'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line',
          'valueInteger': 5,
        },
        {
          'url':
              'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col',
          'valueInteger': 10,
        },
      ]);
    });

    test('prettyPrint returns formatted JSON string', () {
      final results = ValidationResults();
      final node = LiteralNode('test', 'test', path: 'Patient.id');

      results.addResult(node, 'Error message', Severity.error);

      final pretty = results.prettyPrint();

      expect(pretty, isA<String>());
      expect(pretty, contains('OperationOutcome'));
    });

    test('copyWith creates a new instance with copied results', () {
      final original = ValidationResults();
      final node = LiteralNode('test', 'test', path: 'Patient.id');

      original
        ..addResult(node, 'Error message', Severity.error)
        ..addMissingResult('Patient.name', 'Name required', Severity.error);

      final copied = original.copyWith();

      expect(copied.results, hasLength(1));
      expect(copied.missingResults, hasLength(1));
    });
  });

  group('ValidationDiagnostics', () {
    test('creates diagnostics with all fields', () {
      final diagnostics = ValidationDiagnostics(
        'Patient.id',
        'Error message',
        Severity.error,
        line: 5,
        column: 10,
      );

      expect(diagnostics.path, 'Patient.id');
      expect(diagnostics.diagnostics, 'Error message');
      expect(diagnostics.severity, Severity.error);
      expect(diagnostics.line, 5);
      expect(diagnostics.column, 10);
    });

    test('create factory method extracts location from node', () {
      final node = LiteralNode('test', 'test', path: 'Patient.id')
        ..loc = ValidationLocation(
          const Segment(3, 7, 0),
          const Segment(3, 7, 0),
        );

      final diagnostics = ValidationDiagnostics.create(
        node,
        'Error message',
        Severity.error,
      );

      expect(diagnostics.path, 'Patient.id');
      expect(diagnostics.line, 3);
      expect(diagnostics.column, 7);
    });

    test('toJson returns properly formatted JSON', () {
      final diagnostics = ValidationDiagnostics(
        'Patient.id',
        'Error message',
        Severity.error,
        line: 5,
        column: 10,
      );

      final json = diagnostics.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['path'], 'Patient.id');
      expect(json['diagnostics'], 'Error message');
      expect(json['severity'], 'error');
      expect(json['line'], 5);
      expect(json['column'], 10);
    });

    test('equality works correctly', () {
      final diagnostics1 = ValidationDiagnostics(
        'Patient.id',
        'Error message',
        Severity.error,
      );
      final diagnostics2 = ValidationDiagnostics(
        'Patient.id',
        'Error message',
        Severity.error,
      );
      final diagnostics3 = ValidationDiagnostics(
        'Patient.name',
        'Error message',
        Severity.error,
      );

      expect(diagnostics1 == diagnostics2, isTrue);
      expect(diagnostics1 == diagnostics3, isFalse);
    });
  });

  group('Severity', () {
    test('toString returns correct string representation', () {
      expect(Severity.error.toString(), 'error');
      expect(Severity.warning.toString(), 'warning');
      expect(Severity.information.toString(), 'information');
    });

    test('fromString parses string correctly', () {
      expect(Severity.fromString('error'), Severity.error);
      expect(Severity.fromString('warning'), Severity.warning);
      expect(Severity.fromString('information'), Severity.information);
    });

    test('fromJson parses JSON correctly', () {
      expect(Severity.fromJson('error'), Severity.error);
      expect(Severity.fromJson('warning'), Severity.warning);
      expect(Severity.fromJson('information'), Severity.information);
    });

    test('toJson returns correct JSON representation', () {
      expect(Severity.error.toJson(), 'error');
      expect(Severity.warning.toJson(), 'warning');
      expect(Severity.information.toJson(), 'information');
    });
  });
}
