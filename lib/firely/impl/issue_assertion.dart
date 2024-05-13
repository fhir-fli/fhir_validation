import 'dart:convert';

import '../firely.dart';

/// Asserts a coded result for the validation that can be used to construct an
/// `OperationOutcome`.
class IssueAssertion
    implements IFixedResult, IValidatable, IEquatable<IssueAssertion> {
  final int issueNumber;
  final String message;
  final IssueSeverity severity;
  final IssueType? type;
  String? location;
  DefinitionPath? definitionPath;

  IssueAssertion({
    required this.issueNumber,
    required this.message,
    required this.severity,
    this.type,
    this.location,
    this.definitionPath,
  });

  /// Interprets the [IssueSeverity] of the assertion as a [ValidationResult]
  /// to be used by the validator for deriving the result of the validation.
  ValidationResult get result => severity.toValidationResult();

  @override
  Map<String, dynamic> toJson() {
    var props = <String, dynamic>{
      'issueNumber': issueNumber,
      'severity': severity.toString(),
      'message': message,
      if (location != null) 'location': location,
      if (definitionPath != null) 'definitionPath': definitionPath.toJson(),
      if (type != null) 'type': type.toString(),
    };
    return {'issue': props};
  }

  @override
  ResultReport validate(
      IScopedNode input, ValidationSettings settings, ValidationState state) {
    // Validation logic here.
    var updatedMessage = message
        .replaceAll('%INSTANCETYPE%', input.instanceType)
        .replaceAll('%RESOURCEURL%', state.instance.resourceUrl ?? '');
    return IssueAssertion(
      issueNumber: issueNumber,
      message: updatedMessage,
      severity: severity,
      type: type,
      location: location,
      definitionPath: definitionPath,
    ).asResult(state);
  }

  ResultReport asResult(ValidationState state) {
    return asResultInternal(state.location.instanceLocation.toString(),
        state.location.definitionPath);
  }

  ResultReport asResultInternal(
      String location, DefinitionPath? definitionPath) {
    return ResultReport(
      validationResult: result,
      issueAssertions: [this],
    );
  }

  bool equals(IssueAssertion? other) {
    if (identical(this, other)) return true;
    if (other == null) return false;
    return issueNumber == other.issueNumber &&
        location == other.location &&
        message == other.message &&
        severity == other.severity &&
        type == other.type;
  }

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;

  @override
  bool operator ==(Object other) => other is IssueAssertion && equals(other);
}

enum IssueSeverity {
  fatal,
  error,
  warning,
  information,
}

extension IssueSeverityExtension on IssueSeverity {
  ValidationResult toValidationResult() {
    switch (this) {
      case IssueSeverity.fatal:
      case IssueSeverity.error:
        return ValidationResult.failure;
      case IssueSeverity.warning:
      case IssueSeverity.information:
        return ValidationResult.success;
      default:
        throw Exception('Unsupported IssueSeverity');
    }
  }
}

enum IssueType { notSupported, tooCostly }
