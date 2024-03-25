enum IssueSeverity {
  fatal,
  error,
  warning,
  information,
  none; // Equivalent to NULL in Java, but 'null' is a reserved word in Dart

  String toCode() {
    switch (this) {
      case IssueSeverity.fatal:
        return "fatal";
      case IssueSeverity.error:
        return "error";
      case IssueSeverity.warning:
        return "warning";
      case IssueSeverity.information:
        return "information";
      case IssueSeverity.none:
        return "none"; // Using 'none' as the representation for NULL
      default:
        return "?";
    }
  }

  String getSystem() {
    return "http://hl7.org/fhir/issue-severity";
  }

  String getDefinition() {
    switch (this) {
      case IssueSeverity.fatal:
        return "The issue caused the action to fail, and no further checking could be performed.";
      case IssueSeverity.error:
        return "The issue is sufficiently important to cause the action to fail.";
      case IssueSeverity.warning:
        return "The issue is not important enough to cause the action to fail, but may cause it to be performed suboptimally or in a way that is not as desired.";
      case IssueSeverity.information:
        return "The issue has no relation to the degree of success of the action.";
      case IssueSeverity.none:
        return "No issue severity.";
      default:
        return "?";
    }
  }

  String getDisplay() {
    switch (this) {
      case IssueSeverity.fatal:
        return "Fatal";
      case IssueSeverity.error:
        return "Error";
      case IssueSeverity.warning:
        return "Warning";
      case IssueSeverity.information:
        return "Information";
      case IssueSeverity.none:
        return "None";
      default:
        return "?";
    }
  }

  bool isError() => this == IssueSeverity.fatal || this == IssueSeverity.error;
  bool isHint() => this == IssueSeverity.information;
}

extension IssueSeverityExtension on IssueSeverity {
  static IssueSeverity fromCode(String code) {
    switch (code) {
      case "fatal":
        return IssueSeverity.fatal;
      case "error":
        return IssueSeverity.error;
      case "warning":
        return IssueSeverity.warning;
      case "information":
        return IssueSeverity.information;
      default:
        throw Exception("Unknown IssueSeverity code '$code'");
    }
  }

  static IssueSeverity max(IssueSeverity l1, IssueSeverity l2) {
    // Implementing logic to find max severity between two IssueSeverity instances
    // This is a simplified version, adjust based on your actual logic needs
    if (l1 == IssueSeverity.fatal || l2 == IssueSeverity.fatal)
      return IssueSeverity.fatal;
    if (l1 == IssueSeverity.error || l2 == IssueSeverity.error)
      return IssueSeverity.error;
    if (l1 == IssueSeverity.warning || l2 == IssueSeverity.warning)
      return IssueSeverity.warning;
    return IssueSeverity.information;
  }
}
