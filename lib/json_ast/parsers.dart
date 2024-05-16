import 'token_types.dart';
import 'string_states.dart';
import 'number_states.dart';
import 'utils.dart';

Map<String, dynamic>? parseWhitespace(
    String input, int index, int line, int column) {
  final char = input[index];

  if (char == '\r') {
    // CR (Unix)
    index++;
    line++;
    column = 1;
    if (input.length > index && input[index] == '\n') {
      // CRLF (Windows)
      index++;
    }
  } else if (char == '\n') {
    // LF (MacOS)
    index++;
    line++;
    column = 1;
  } else if (char == '\t' || char == ' ') {
    index++;
    column++;
  } else {
    return null;
  }

  return {
    'index': index,
    'line': line,
    'column': column,
  };
}

Map<String, dynamic>? parseChar(String input, int index, int line, int column) {
  final char = input[index];

  if (punctuatorTokensMap.containsKey(char)) {
    return {
      'type': punctuatorTokensMap[char],
      'line': line,
      'column': column + 1,
      'index': index + 1,
      'value': null,
    };
  }

  return null;
}

Map<String, dynamic>? parseKeyword(
    String input, int index, int line, int column) {
  for (var name in keywordTokensMap.keys) {
    if (input.substring(index, index + name.length) == name) {
      return {
        'type': keywordTokensMap[name],
        'line': line,
        'column': column + name.length,
        'index': index + name.length,
        'value': name,
      };
    }
  }

  return null;
}

Map<String, dynamic>? parseString(
    String input, int index, int line, int column) {
  final startIndex = index;
  var buffer = '';
  var state = StringStates.START;

  while (index < input.length) {
    final char = input[index];

    switch (state) {
      case StringStates.START:
        if (char == '"') {
          index++;
          state = StringStates.START_QUOTE_OR_CHAR;
        } else {
          return null;
        }
        break;

      case StringStates.START_QUOTE_OR_CHAR:
        if (char == '\\') {
          buffer += char;
          index++;
          state = StringStates.ESCAPE;
        } else if (char == '"') {
          index++;
          return {
            'type': TokenTypes.STRING,
            'line': line,
            'column': column + index - startIndex,
            'index': index,
            'value': input.substring(startIndex, index),
          };
        } else {
          buffer += char;
          index++;
        }
        break;

      case StringStates.ESCAPE:
        if (escapes.containsKey(char)) {
          buffer += char;
          index++;
          if (char == 'u') {
            for (var i = 0; i < 4; i++) {
              final curChar = input[index];
              if (curChar != '' && isHex(curChar)) {
                buffer += curChar;
                index++;
              } else {
                return null;
              }
            }
          }
          state = StringStates.START_QUOTE_OR_CHAR;
        } else {
          return null;
        }
        break;
    }
  }

  return null;
}

Map<String, dynamic>? parseNumber(
    String input, int index, int line, int column) {
  final startIndex = index;
  var passedValueIndex = index;
  var state = NumberStates.START;

  while (index < input.length) {
    final char = input[index];

    switch (state) {
      case NumberStates.START:
        if (char == '-') {
          state = NumberStates.MINUS;
        } else if (char == '0') {
          passedValueIndex = index + 1;
          state = NumberStates.ZERO;
        } else if (isDigit1to9(char)) {
          passedValueIndex = index + 1;
          state = NumberStates.DIGIT;
        } else {
          return null;
        }
        break;

      case NumberStates.MINUS:
        if (char == '0') {
          passedValueIndex = index + 1;
          state = NumberStates.ZERO;
        } else if (isDigit1to9(char)) {
          passedValueIndex = index + 1;
          state = NumberStates.DIGIT;
        } else {
          return null;
        }
        break;

      case NumberStates.ZERO:
        if (char == '.') {
          state = NumberStates.POINT;
        } else if (isExp(char)) {
          state = NumberStates.EXP;
        } else {
          return {
            'type': TokenTypes.NUMBER,
            'line': line,
            'column': column + passedValueIndex - startIndex,
            'index': passedValueIndex,
            'value': input.substring(startIndex, passedValueIndex),
          };
        }
        break;

      case NumberStates.DIGIT:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else if (char == '.') {
          state = NumberStates.POINT;
        } else if (isExp(char)) {
          state = NumberStates.EXP;
        } else {
          return {
            'type': TokenTypes.NUMBER,
            'line': line,
            'column': column + passedValueIndex - startIndex,
            'index': passedValueIndex,
            'value': input.substring(startIndex, passedValueIndex),
          };
        }
        break;

      case NumberStates.POINT:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
          state = NumberStates.DIGIT_FRACTION;
        } else {
          return null;
        }
        break;

      case NumberStates.DIGIT_FRACTION:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else if (isExp(char)) {
          state = NumberStates.EXP;
        } else {
          return {
            'type': TokenTypes.NUMBER,
            'line': line,
            'column': column + passedValueIndex - startIndex,
            'index': passedValueIndex,
            'value': input.substring(startIndex, passedValueIndex),
          };
        }
        break;

      case NumberStates.EXP:
        if (char == '+' || char == '-') {
          state = NumberStates.EXP_DIGIT_OR_SIGN;
        } else if (isDigit(char)) {
          passedValueIndex = index + 1;
          state = NumberStates.EXP_DIGIT_OR_SIGN;
        } else {
          return null;
        }
        break;

      case NumberStates.EXP_DIGIT_OR_SIGN:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else {
          return {
            'type': TokenTypes.NUMBER,
            'line': line,
            'column': column + passedValueIndex - startIndex,
            'index': passedValueIndex,
            'value': input.substring(startIndex, passedValueIndex),
          };
        }
        break;
    }

    index++;
  }

  return null;
}
