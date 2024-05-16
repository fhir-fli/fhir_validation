class CustomSyntaxError extends Error {
  final String message;
  final String? source;
  final int? line;
  final int? column;

  CustomSyntaxError({
    required this.message,
    this.source,
    this.line,
    this.column,
  });

  @override
  String toString() {
    return 'SyntaxError: $message at ${source ?? ""}:${line ?? ""}:${column ?? ""}';
  }
}

void throwError(
    String message, String input, String source, int line, int column) {
  throw CustomSyntaxError(
    message: '$message\n$input',
    source: source,
    line: line,
    column: column,
  );
}
