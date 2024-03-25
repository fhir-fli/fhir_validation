enum ValidationLevel {
  hints,
  warnings,
  errors;
}

extension ValidationLevelExtension on ValidationLevel {
  static ValidationLevel fromCode(String? v) {
    if (v == null || v.isEmpty) {
      return ValidationLevel.hints;
    }
    final lowerCaseValue = v.toLowerCase();
    if (['h', 'i', 'hints', 'info'].contains(lowerCaseValue)) {
      return ValidationLevel.hints;
    } else if (['w', 'warning', 'warnings'].contains(lowerCaseValue)) {
      return ValidationLevel.warnings;
    } else if (['e', 'error', 'errors'].contains(lowerCaseValue)) {
      return ValidationLevel.errors;
    } else {
      return ValidationLevel.hints;
    }
  }
}
