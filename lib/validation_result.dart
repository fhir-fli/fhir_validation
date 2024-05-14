class ValidationResult {
  ValidationResult(
      {List<String>? errors, List<String>? warnings, List<String>? information})
      : errors = errors ?? [],
        warnings = warnings ?? [],
        information = information ?? [];
  final List<String> errors;
  final List<String> warnings;
  final List<String> information;
}
