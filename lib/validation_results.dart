import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';

class ValidationResults {
  final List<ValidationDiagnostics> results = <ValidationDiagnostics>[];
  final List<ValidationDiagnostics> missingResults = <ValidationDiagnostics>[];

  void addResult(Node? node, String newItem, Severity severity) {
    results.add(ValidationDiagnostics.create(node, newItem, severity));
  }

  void addMissingResult(String path, String newItem, Severity severity) {
    final int index = missingResults.indexWhere(
        (ValidationDiagnostics element) => path.startsWith(element.path));
    if (index == -1) {
      missingResults.add(ValidationDiagnostics(path, newItem, severity));
    }
  }

  void combineResults(ValidationResults other) {
    results.addAll(other.results);
    missingResults.addAll(other.missingResults);
  }

  void _joinResults() {
    results.addAll(_cleanMissingResults());
  }

  Map<String, dynamic> toJson() {
    _joinResults();
    final List<Map<String, dynamic>> error = results
        .where((ValidationDiagnostics element) =>
            element.severity == Severity.error)
        .map((ValidationDiagnostics e) => e.toJson())
        .toList();
    final List<Map<String, dynamic>> warning = results
        .where((ValidationDiagnostics element) =>
            element.severity == Severity.warning)
        .map((ValidationDiagnostics e) => e.toJson())
        .toList();
    final List<Map<String, dynamic>> information = results
        .where((ValidationDiagnostics element) =>
            element.severity == Severity.information)
        .map((ValidationDiagnostics e) => e.toJson())
        .toList();
    return <String, dynamic>{
      'error': error,
      'warning': warning,
      'information': information,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  List<ValidationDiagnostics> _cleanMissingResults() {
    missingResults.sort((ValidationDiagnostics a, ValidationDiagnostics b) =>
        a.path.length.compareTo(b.path.length));
    final List<ValidationDiagnostics> cleanedResults =
        <ValidationDiagnostics>[];
    for (final ValidationDiagnostics result in missingResults) {
      final int index = cleanedResults.indexWhere(
          (ValidationDiagnostics element) =>
              result.path.startsWith(element.path));
      if (index == -1) {
        cleanedResults.add(result);
      }
    }
    return cleanedResults;
  }

  OperationOutcomeIssue _makeOperationOutcomeIssue(ValidationDiagnostics e) =>
      OperationOutcomeIssue(
          severity: IssueSeverity.fromJson({'value': e.severity.toJson()}),
          code: IssueType.processing,
          diagnostics: e.diagnostics.toFhirString,
          extension_: e.line == null && e.column == null
              ? null
              : <FhirExtension>[
                  if (e.line != null)
                    FhirExtension(
                      url: FhirString(
                          'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line'),
                      valueInteger:
                          e.line == null ? null : FhirInteger(e.line!),
                    ),
                  if (e.column != null)
                    FhirExtension(
                      url: FhirString(
                          'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col'),
                      valueInteger:
                          e.column == null ? null : FhirInteger(e.column!),
                    ),
                ],
          location: <FhirString>[
            e.path.toFhirString,
            if (e.line != null && e.column != null)
              'Line[${e.line}] Column[${e.column}]'.toFhirString,
            if (e.line != null && e.column == null)
              'Line[${e.line}]'.toFhirString,
            if (e.line == null && e.column != null)
              'Column[${e.column}]'.toFhirString,
          ]);

  OperationOutcome toOperationOutcome() {
    _joinResults();
    final List<ValidationDiagnostics> error = results
        .where((ValidationDiagnostics element) =>
            element.severity == Severity.error)
        .toList();
    final List<ValidationDiagnostics> warning = results
        .where((ValidationDiagnostics element) =>
            element.severity == Severity.warning)
        .toList();
    final List<ValidationDiagnostics> information = results
        .where((ValidationDiagnostics element) =>
            element.severity == Severity.information)
        .toList();
    final List<OperationOutcomeIssue> issues = <OperationOutcomeIssue>[];
    issues.addAll(error
        .map((ValidationDiagnostics e) => _makeOperationOutcomeIssue(e))
        .toList());
    issues.addAll(warning
        .map((ValidationDiagnostics e) => _makeOperationOutcomeIssue(e))
        .toList());
    issues.addAll(information
        .map((ValidationDiagnostics e) => _makeOperationOutcomeIssue(e))
        .toList());
    final OperationOutcome outcome = OperationOutcome(issue: issues);
    return outcome;
  }

  String prettyPrint() {
    return jsonPrettyPrint(toOperationOutcome().toJson());
  }

  ValidationResults copyWith({
    List<ValidationDiagnostics>? results,
    List<ValidationDiagnostics>? missingResults,
  }) {
    return ValidationResults()
      ..results.addAll(results ?? this.results)
      ..missingResults.addAll(missingResults ?? this.missingResults);
  }
}

class ValidationDiagnostics {
  final String path;
  final String diagnostics;
  final Severity severity;
  final int? line;
  final int? column;

  ValidationDiagnostics(
    this.path,
    this.diagnostics,
    this.severity, {
    this.line,
    this.column,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'path': path,
      'diagnostics': diagnostics,
      'severity': severity.toString(),
      if (line != null) 'line': line,
      if (column != null) 'column': column,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  ValidationDiagnostics copyWith({
    String? path,
    String? diagnostics,
    Severity? severity,
    int? line,
    int? column,
  }) {
    return ValidationDiagnostics(
      path ?? this.path,
      diagnostics ?? this.diagnostics,
      severity ?? this.severity,
      line: line ?? this.line,
      column: column ?? this.column,
    );
  }

  factory ValidationDiagnostics.create(
    Node? node,
    String newItem,
    Severity severity,
  ) {
    int? line;
    int? column;
    switch (node) {
      case ObjectNode _:
        {
          line = node.loc?.start.line;
          column = node.loc?.start.column;
        }
        break;
      case ArrayNode _:
        {
          line = node.loc?.start.line;
          column = node.loc?.start.column;
        }
        break;
      case PropertyNode _:
        {
          line = node.key?.loc?.start.line ?? node.loc?.start.line;
          column = node.key?.loc?.start.column ?? node.loc?.start.column;
        }
        break;
      case LiteralNode _:
        {
          line = node.loc?.start.line;
          column = node.loc?.start.column;
        }
        break;
      case ValueNode _:
        {
          line = node.loc?.start.line;
          column = node.loc?.start.column;
        }
        break;
    }
    return ValidationDiagnostics(node?.path ?? '', newItem, severity,
        line: line, column: column);
  }
}

enum Severity {
  error,
  warning,
  information;

  @override
  String toString() {
    switch (this) {
      case Severity.error:
        return 'error';
      case Severity.warning:
        return 'warning';
      case Severity.information:
        return 'information';
    }
  }

  static Severity fromString(String severity) {
    switch (severity) {
      case 'error':
        return Severity.error;
      case 'warning':
        return Severity.warning;
      case 'information':
        return Severity.information;
      default:
        throw ArgumentError('Invalid severity: $severity');
    }
  }

  static Severity fromJson(dynamic json) {
    if (json is String) {
      return fromString(json);
    } else {
      throw ArgumentError('Invalid severity: $json');
    }
  }

  String toJson() => toString();
}
