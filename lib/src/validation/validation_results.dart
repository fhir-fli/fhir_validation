import 'dart:convert';

import 'package:fhir_validation/fhir_validation.dart';

/// [ValidationResults]
class ValidationResults {
  /// List of results from validation process
  final List<ValidationDiagnostics> results = <ValidationDiagnostics>[];

  /// List of missing results from validation process
  final List<ValidationDiagnostics> missingResults = <ValidationDiagnostics>[];

  /// returns if the results have any errors
  bool get hasErrors =>
      results.any((element) => element.severity == Severity.error);

  /// Add a result to the list of results
  void addResult(Node? node, String newItem, Severity severity) {
    final existing = results.any(
      (element) => element.path == node?.path && element.diagnostics == newItem,
    );
    if (!existing) {
      results.add(ValidationDiagnostics.create(node, newItem, severity));
    }
  }

  /// Add a missing result to the list of missing results
  void addMissingResult(String path, String newItem, Severity severity) {
    final index = missingResults.indexWhere(
      (element) => path.startsWith(element.path),
    );
    if (index == -1) {
      missingResults.add(
        ValidationDiagnostics(path, newItem, severity, line: 1, column: 1),
      );
    }
  }

  /// Combine the results of two ValidationResults objects
  void combineResults(ValidationResults other) {
    for (final result in other.results) {
      final exists = results.any(
        (existing) =>
            existing.path == result.path &&
            existing.diagnostics == result.diagnostics,
      );
      if (!exists) {
        results.add(result);
      }
    }
    for (final missingResult in other.missingResults) {
      final exists = missingResults.any(
        (existing) =>
            existing.path == missingResult.path &&
            existing.diagnostics == missingResult.diagnostics,
      );
      if (!exists) {
        missingResults.add(missingResult);
      }
    }
  }

  void _joinResults() {
    final uniqueMissingResults = _cleanMissingResults();
    results.addAll(
      uniqueMissingResults.where(
        (result) =>
            !results.any(
              (existing) =>
                  existing.path == result.path &&
                  existing.diagnostics == result.diagnostics,
            ),
      ),
    );
  }

  /// Convert the results to a JSON object
  Map<String, dynamic> toJson() {
    _joinResults();
    final uniqueResults = results.toSet().toList();
    return {
      'error':
          uniqueResults.where((e) => e.severity == Severity.error).toList(),
      'warning':
          uniqueResults.where((e) => e.severity == Severity.warning).toList(),
      'information':
          uniqueResults
              .where((e) => e.severity == Severity.information)
              .toList(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  List<ValidationDiagnostics> _cleanMissingResults() {
    missingResults.sort(
      (a, b) => a.path.length.compareTo(b.path.length),
    );
    final cleanedResults = <ValidationDiagnostics>[];
    for (final result in missingResults) {
      final index = cleanedResults.indexWhere(
        (element) => result.path.startsWith(element.path),
      );
      if (index == -1) {
        cleanedResults.add(result);
      }
    }
    return cleanedResults;
  }

  Map<String, dynamic> _makeOperationOutcomeIssue(ValidationDiagnostics e) => {
    'severity': e.severity.toJson(),
    'code': 'processing',
    'diagnostics': e.diagnostics,
    if (e.line != null || e.column != null)
      'extension': [
        if (e.line != null)
          {
            'url':
                'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line',
            'valueInteger': e.line,
          },
        if (e.column != null)
          {
            'url':
                'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col',
            'valueInteger': e.column,
          },
      ],
    'location': [
      e.path,
      if (e.line != null && e.column != null)
        'Line[${e.line}] Col[${e.column}]',
      if (e.line != null && e.column == null) 'Line[${e.line}]',
      if (e.line == null && e.column != null) 'Col[${e.column}]',
    ],
  };

  /// The results as an OperationOutcome, as JSON: one `processing` issue
  /// per diagnostic, errors first, then warnings, then information, each
  /// with its path (and line and column, when known) in `location` and the
  /// operationoutcome-issue-line / -col extensions. A binding parses it
  /// into its OperationOutcome type.
  Map<String, dynamic> toOperationOutcomeJson() {
    _joinResults();
    final error =
        results
            .where(
              (element) => element.severity == Severity.error,
            )
            .toList();
    final warning =
        results
            .where(
              (element) => element.severity == Severity.warning,
            )
            .toList();
    final information =
        results
            .where(
              (element) => element.severity == Severity.information,
            )
            .toList();
    return {
      'resourceType': 'OperationOutcome',
      'issue': [
        ...error.map(_makeOperationOutcomeIssue),
        ...warning.map(_makeOperationOutcomeIssue),
        ...information.map(_makeOperationOutcomeIssue),
      ],
    };
  }

  static const _jsonEncoder = JsonEncoder.withIndent('    ');

  String _jsonPrettyPrint(Map<String, dynamic> map) =>
      _jsonEncoder.convert(map);

  /// Returns a pretty printed JSON string.
  String prettyPrint() {
    return _jsonPrettyPrint(toOperationOutcomeJson());
  }

  /// Returns a pretty printed JSON string.
  ValidationResults copyWith({
    List<ValidationDiagnostics>? results,
    List<ValidationDiagnostics>? missingResults,
  }) {
    final newResults = List.of(results ?? this.results).toSet().toList();
    final newMissingResults =
        List.of(missingResults ?? this.missingResults).toSet().toList();
    return ValidationResults()
      ..results.addAll(newResults)
      ..missingResults.addAll(newMissingResults);
  }
}

/// [ValidationDiagnostics]
class ValidationDiagnostics {
  /// [ValidationDiagnostics] constructor
  ValidationDiagnostics(
    this.path,
    this.diagnostics,
    this.severity, {
    this.line,
    this.column,
  });

  /// Create a [ValidationDiagnostics] object
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
      case ArrayNode _:
        {
          line = node.loc?.start.line;
          column = node.loc?.start.column;
        }
      case PropertyNode _:
        {
          line = node.key?.loc?.start.line ?? node.loc?.start.line;
          column = node.key?.loc?.start.column ?? node.loc?.start.column;
        }
      case LiteralNode _:
        {
          line = node.loc?.start.line;
          column = node.loc?.start.column;
        }
      case ValueNode _:
        {
          line = node.loc?.start.line;
          column = node.loc?.start.column;
        }
    }
    return ValidationDiagnostics(
      node?.path ?? '',
      newItem,
      severity,
      line: line,
      column: column,
    );
  }

  /// [path] of the diagnostics
  final String path;

  /// [diagnostics] of the diagnostics
  final String diagnostics;

  /// [severity] of the diagnostics
  final Severity severity;

  /// [line] of the diagnostics
  final int? line;

  /// [column] of the diagnostics
  final int? column;

  /// Convert the diagnostics to a JSON object
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

  /// Returns a pretty printed JSON string.
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

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationDiagnostics &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          diagnostics == other.diagnostics &&
          severity == other.severity;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => path.hashCode ^ diagnostics.hashCode ^ severity.hashCode;
}

/// [Severity]
enum Severity {
  /// Error
  error,

  /// Warning
  warning,

  /// Information
  information;

  /// Converts a [Severity] to a string
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

  /// Converts a string to a [Severity]
  static Severity fromString(String severity) {
    switch (severity) {
      case 'error':
        return Severity.error;
      case 'warning':
        return Severity.warning;
      case 'information':
        return Severity.information;
      default:
        return Severity.error; // Default to error for invalid input
    }
  }

  /// Converts a JSON object to a [Severity]
  static Severity fromJson(dynamic json) {
    if (json is String) {
      return fromString(json);
    } else {
      throw ArgumentError('Invalid severity: $json');
    }
  }

  /// Converts a [Severity] to a JSON object
  String toJson() => toString();
}
