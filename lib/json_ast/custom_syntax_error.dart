import 'dart:core';

class CustomSyntaxError extends Error {
  final String message;
  final String? source;
  final int? line;
  final int? column;
  final String? stackTrace;

  CustomSyntaxError({
    required this.message,
    this.source,
    this.line,
    this.column,
    this.stackTrace,
  });

  @override
  String toString() {
    final errorInfo = StringBuffer()
      ..writeln('SyntaxError: $message')
      ..writeln('Source: $source')
      ..writeln('Line: $line, Column: $column');
    if (stackTrace != null) {
      errorInfo.writeln('Stack Trace: $stackTrace');
    }
    return errorInfo.toString();
  }
}

CustomSyntaxError createError({
  required String message,
  String? source,
  int? line,
  int? column,
}) {
  final stackTrace = StackTrace.current.toString();
  return CustomSyntaxError(
    message: message,
    source: source,
    line: line,
    column: column,
    stackTrace: stackTrace,
  );
}
