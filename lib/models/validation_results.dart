import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';

class ValidationResults {
  final List<ValidationDiagnostics> results = [];

  void addResult(Node? node, String newItem, Severity severity) {
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
    results.add(ValidationDiagnostics(node?.path ?? '', newItem, severity,
        line: line, column: column));
  }

  void combineResults(ValidationResults other) {
    results.addAll(other.results);
  }

  Map<String, dynamic> toJson() {
    final error = results
        .where((element) => element.severity == Severity.error)
        .map((e) => e.toJson())
        .toList();
    final warning = results
        .where((element) => element.severity == Severity.warning)
        .map((e) => e.toJson())
        .toList();
    final information = results
        .where((element) => element.severity == Severity.information)
        .map((e) => e.toJson())
        .toList();
    return {
      'error': error,
      'warning': warning,
      'information': information,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  OperationOutcomeIssue _makeOperationOutcomeIssue(ValidationDiagnostics e) =>
      OperationOutcomeIssue(
          severity: FhirCode(e.severity.toString()),
          code: FhirCode('processing'),
          diagnostics: e.diagnostics,
          extension_: e.line == null && e.column == null
              ? null
              : [
                  if (e.line != null)
                    FhirExtension(
                      url: FhirUri(
                          'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line'),
                      valueInteger:
                          e.line == null ? null : FhirInteger(e.line!),
                    ),
                  if (e.column != null)
                    FhirExtension(
                      url: FhirUri(
                          'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col'),
                      valueInteger:
                          e.column == null ? null : FhirInteger(e.column!),
                    ),
                ],
          location: [
            e.path,
            if (e.line != null && e.column != null)
              'Line[${e.line}] Column[${e.column}]',
            if (e.line != null && e.column == null) 'Line[${e.line}]',
            if (e.line == null && e.column != null) 'Column[${e.column}]',
          ]);

  OperationOutcome toOperationOutcome() {
    final error =
        results.where((element) => element.severity == Severity.error).toList();
    final warning = results
        .where((element) => element.severity == Severity.warning)
        .toList();
    final information = results
        .where((element) => element.severity == Severity.information)
        .toList();
    final issues = <OperationOutcomeIssue>[];
    issues.addAll(error.map((e) => _makeOperationOutcomeIssue(e)).toList());
    issues.addAll(warning.map((e) => _makeOperationOutcomeIssue(e)).toList());
    issues
        .addAll(information.map((e) => _makeOperationOutcomeIssue(e)).toList());
    final outcome = OperationOutcome(issue: issues);
    return outcome;
  }

  String prettyPrint() {
    return jsonPrettyPrint(toOperationOutcome().toJson());
  }

  ValidationResults copyWith({
    List<ValidationDiagnostics>? results,
  }) {
    return ValidationResults()..results.addAll(results ?? this.results);
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
    return {
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

  static String toJson(Severity severity) {
    return severity.toString();
  }
}
