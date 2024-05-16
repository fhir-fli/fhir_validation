import 'parsers.dart';
import 'location.dart';
import 'tokenize_error_types.dart';
import 'error.dart';

List<Map<String, dynamic>> tokenize(
    String input, Map<String, dynamic> settings) {
  int line = 1;
  int column = 1;
  int index = 0;
  List<Map<String, dynamic>> tokens = [];

  while (index < input.length) {
    final args = [input, index, line, column];
    final whitespace = parseWhitespace(input, index, line, column);

    if (whitespace != null) {
      index = whitespace['index'];
      line = whitespace['line'];
      column = whitespace['column'];
      continue;
    }

    final matched = parseChar(input, index, line, column) ??
        parseKeyword(input, index, line, column) ??
        parseString(input, index, line, column) ??
        parseNumber(input, index, line, column);

    if (matched != null) {
      final token = {
        'type': matched['type'],
        'value': matched['value'],
        'loc': Location.create(
          line,
          column,
          index,
          matched['line'],
          matched['column'],
          matched['index'],
          settings['source'],
        )
      };

      tokens.add(token);
      index = matched['index'];
      line = matched['line'];
      column = matched['column'];
    } else {
      throwError(
        TokenizeErrorTypes.unexpectedSymbol(
          substring(input, index, index + 1),
          [settings['source'], line.toString(), column.toString()],
        ),
        input,
        settings['source'],
        line,
        column,
      );
    }
  }

  return tokens;
}
