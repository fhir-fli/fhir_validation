import '../firely.dart';

/// Represents the outcome of a validating assertion, optionally listing the evidence
/// for the validation result.
class ResultReport {
  /// Represents a success assertion without evidence.
  static final ResultReport success = ResultReport(ValidationResult.success);

  /// Represents a failure assertion without evidence.
  static final ResultReport failure = ResultReport(ValidationResult.failure);

  /// Represents an undecided outcome without evidence.
  static final ResultReport undecided =
      ResultReport(ValidationResult.undecided);

  /// The result of the validation.
  final ValidationResult result;

  /// Evidence for the result.
  final List<IAssertion> evidence;

  /// Constructor for a ResultReport with given outcome and evidence.
  ResultReport(this.result, [List<IAssertion> this.evidence = const []]);

  /// Creates a new ResultReport where the result is derived from multiple other
  /// reports.
  static ResultReport combine(List<ResultReport> reports) {
    if (reports.isEmpty) return success;
    if (reports.length == 1) return reports.single;

    var usefulEvidence =
        reports.where((e) => !isSuccessWithoutDetails(e)).toList();

    if (usefulEvidence.length == 1) return usefulEvidence.single;

    var totalResult = usefulEvidence.fold(
        ValidationResult.success, (acc, elem) => acc.combine(elem.result));

    var flattenedEvidence = usefulEvidence.expand((ue) => ue.evidence).toList();

    return ResultReport(totalResult, flattenedEvidence);
  }

  /// Checks if a result report represents a success without detailed evidence.
  static bool isSuccessWithoutDetails(ResultReport evidence) =>
      evidence == success ||
      (evidence.isSuccessful && evidence.evidence.isEmpty);

  /// Whether the result indicates a success.
  bool get isSuccessful => result == ValidationResult.success;

  /// Returns any warnings that are part of the evidence for this result.
  List<IssueAssertion> get warnings =>
      getIssues(OperationOutcomeIssueSeverity.warning);

  /// Returns any errors that are part of the evidence for this result.
  List<IssueAssertion> get errors =>
      getIssues(OperationOutcomeIssueSeverity.error);

  /// Returns issues (optionally filtering on the given severity) that are part of the evidence for this result.
  List<IssueAssertion> getIssues(OperationOutcomeIssueSeverity? severity) =>
      evidence
          .whereType<IssueAssertion>()
          .where((ia) => severity == null || ia.severity == severity)
          .toList();
}

/// Represents validation results with different outcomes.
enum ValidationResult {
  success,
  failure,
  undecided;

  /// Combines two validation results into a weaker result.
  ValidationResult combine(ValidationResult other) =>
      (this == ValidationResult.success && other == ValidationResult.success)
          ? ValidationResult.success
          : (this == ValidationResult.undecided ||
                  other == ValidationResult.undecided)
              ? ValidationResult.undecided
              : ValidationResult.failure;
}

/// Enum for issue severities.
enum OperationOutcomeIssueSeverity { warning, error }
