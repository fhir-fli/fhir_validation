import 'dart:math';
import 'package:grapheme_splitter/grapheme_splitter.dart' show GraphemeSplitter;
import 'custom_syntax_error.dart';
import 'error.dart';

void throwError(
    String message, String input, String source, int? line, int? column) {
  final errorMessage = line != null
      ? '$message\n${codeErrorFragment(input, line, column)}'
      : message;

  throw createError(
    message: errorMessage,
    source: source,
    line: line,
    column: column,
  );
}

String substring(String str, int start, int end) {
  final splitter = GraphemeSplitter();
  final iterator = splitter.splitGraphemes(str.substring(start)).iterator;
  final buffer = StringBuffer();

  for (var pos = 0; pos < end - start; pos++) {
    if (iterator.moveNext()) {
      buffer.write(iterator.current);
    } else {
      break;
    }
  }

  return buffer.toString();
}

String unexpectedEnd() => 'Unexpected end of input';

String unexpectedToken(String token, String source, int line, int column) {
  final sourceOrEmpty = source != "" ? '$source:' : '';
  final positionStr = '$sourceOrEmpty${line}:$column';
  return 'Unexpected token <$token> at $positionStr';
}

String unexpectedSymbol(String symbol, String source, int line, int column) {
  final sourceOrEmpty = source != "" ? '$source:' : '';
  final positionStr = '$sourceOrEmpty${line}:$column';
  return 'Unexpected symbol <$symbol> at $positionStr';
}

String safeSubstring(String str, int start, int end) {
  final len = str.length;
  if (len > start) {
    final lastIndex = min(len, end);
    return str.substring(start, lastIndex);
  }
  return '';
}

class Location {
  final Position start;
  final Position end;
  final String? source;

  Location(this.start, this.end, [this.source]);
}

class Position {
  final int line;
  final int column;
  final int offset;

  Position(this.line, this.column, this.offset);
}

Location createLocation(
  int startLine,
  int startColumn,
  int startOffset,
  int endLine,
  int endColumn,
  int endOffset, [
  String? source,
]) {
  return Location(
    Position(startLine, startColumn, startOffset),
    Position(endLine, endColumn, endOffset),
    source,
  );
}

class TokenizeErrorTypes {
  static String unexpectedEnd() {
    return 'Unexpected end of input';
  }

  static String unexpectedToken(String token, List<String?> position) {
    return 'Unexpected token <$token> at ${position.where((element) => element != null).join(':')}';
  }
}
