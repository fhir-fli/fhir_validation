enum TokenType {
  LEFT_BRACE, // {
  RIGHT_BRACE, // }
  LEFT_BRACKET, // [
  RIGHT_BRACKET, // ]
  COLON, // :
  COMMA, // ,
  STRING, //
  NUMBER, //
  TRUE, // true
  FALSE, // false
  NULL // null
}

final Map<String, TokenType> punctuatorTokensMap = {
  '{': TokenType.LEFT_BRACE,
  '}': TokenType.RIGHT_BRACE,
  '[': TokenType.LEFT_BRACKET,
  ']': TokenType.RIGHT_BRACKET,
  ':': TokenType.COLON,
  ',': TokenType.COMMA
};

final Map<String, TokenType> keywordTokensMap = {
  'true': TokenType.TRUE,
  'false': TokenType.FALSE,
  'null': TokenType.NULL
};

enum StringState { _START_, START_QUOTE_OR_CHAR, ESCAPE }

final Map<String, int> escapes = {
  '"': 0, // Quotation mark
  '\\': 1, // Reverse solidus
  '/': 2, // Solidus
  'b': 3, // Backspace
  'f': 4, // Form feed
  'n': 5, // New line
  'r': 6, // Carriage return
  't': 7, // Horizontal tab
  'u': 8 // 4 hexadecimal digits
};

enum NumberState {
  _START_,
  MINUS,
  ZERO,
  DIGIT,
  POINT,
  DIGIT_FRACTION,
  EXP,
  EXP_DIGIT_OR_SIGN
}

bool isDigit1to9(String char) =>
    char.compareTo('1') >= 0 && char.compareTo('9') <= 0;

bool isDigit(String char) =>
    char.compareTo('0') >= 0 && char.compareTo('9') <= 0;

bool isHex(String char) =>
    isDigit(char) ||
    (char.compareTo('a') >= 0 && char.compareTo('f') <= 0) ||
    (char.compareTo('A') >= 0 && char.compareTo('F') <= 0);

bool isExp(String char) => char == 'e' || char == 'E';

class Position {
  int index;
  int line;
  int column;

  Position(this.index, this.line, this.column);
}

class Token {
  TokenType type;
  String? value;
  Position position;
  Token(this.type, this.value, this.position);
}

Position? parseWhitespace(String input, int index, int line, int column) {
  final char = input[index];

  if (char == '\r') {
    // CR (Unix)
    index++;
    line++;
    column = 1;
    if (index < input.length && input[index] == '\n') {
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

  return Position(index, line, column);
}

Token? parseChar(String input, int index, int line, int column) {
  final char = input[index];

  if (punctuatorTokensMap.containsKey(char)) {
    return Token(
      punctuatorTokensMap[char]!,
      null,
      Position(index + 1, line, column + 1),
    );
  }

  return null;
}

Token? parseKeyword(String input, int index, int line, int column) {
  for (var entry in keywordTokensMap.entries) {
    if (input.substring(index, index + entry.key.length) == entry.key) {
      return Token(
        entry.value,
        entry.key,
        Position(index + entry.key.length, line, column + entry.key.length),
      );
    }
  }

  return null;
}

Token? parseString(String input, int index, int line, int column) {
  final startIndex = index;
  var buffer = '';
  var state = StringState._START_;

  while (index < input.length) {
    final char = input[index];

    switch (state) {
      case StringState._START_:
        if (char == '"') {
          index++;
          state = StringState.START_QUOTE_OR_CHAR;
        } else {
          return null;
        }
        break;

      case StringState.START_QUOTE_OR_CHAR:
        if (char == '\\') {
          buffer += char;
          index++;
          state = StringState.ESCAPE;
        } else if (char == '"') {
          index++;
          return Token(
            TokenType.STRING,
            input.substring(startIndex, index),
            Position(index, line, column + (index - startIndex)),
          );
        } else {
          buffer += char;
          index++;
        }
        break;

      case StringState.ESCAPE:
        if (escapes.containsKey(char)) {
          buffer += char;
          index++;
          if (char == 'u') {
            for (var i = 0; i < 4; i++) {
              final curChar = input[index];
              if (curChar.isNotEmpty && isHex(curChar)) {
                buffer += curChar;
                index++;
              } else {
                return null;
              }
            }
          }
          state = StringState.START_QUOTE_OR_CHAR;
        } else {
          return null;
        }
        break;
    }
  }

  return null;
}

Token? parseNumber(String input, int index, int line, int column) {
  final startIndex = index;
  var passedValueIndex = index;
  var state = NumberState._START_;

  while (index < input.length) {
    final char = input[index];

    switch (state) {
      case NumberState._START_:
        if (char == '-') {
          state = NumberState.MINUS;
        } else if (char == '0') {
          passedValueIndex = index + 1;
          state = NumberState.ZERO;
        } else if (isDigit1to9(char)) {
          passedValueIndex = index + 1;
          state = NumberState.DIGIT;
        } else {
          return null;
        }
        break;

      case NumberState.MINUS:
        if (char == '0') {
          passedValueIndex = index + 1;
          state = NumberState.ZERO;
        } else if (isDigit1to9(char)) {
          passedValueIndex = index + 1;
          state = NumberState.DIGIT;
        } else {
          return null;
        }
        break;

      case NumberState.ZERO:
        if (char == '.') {
          state = NumberState.POINT;
        } else if (isExp(char)) {
          state = NumberState.EXP;
        } else {
          return Token(
            TokenType.NUMBER,
            input.substring(startIndex, passedValueIndex),
            Position(passedValueIndex, line,
                column + (passedValueIndex - startIndex)),
          );
        }
        break;

      case NumberState.DIGIT:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else if (char == '.') {
          state = NumberState.POINT;
        } else if (isExp(char)) {
          state = NumberState.EXP;
        } else {
          return Token(
            TokenType.NUMBER,
            input.substring(startIndex, passedValueIndex),
            Position(passedValueIndex, line,
                column + (passedValueIndex - startIndex)),
          );
        }
        break;

      case NumberState.POINT:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
          state = NumberState.DIGIT_FRACTION;
        } else {
          return Token(
            TokenType.NUMBER,
            input.substring(startIndex, passedValueIndex),
            Position(passedValueIndex, line,
                column + (passedValueIndex - startIndex)),
          );
        }
        break;

      case NumberState.DIGIT_FRACTION:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else if (isExp(char)) {
          state = NumberState.EXP;
        } else {
          return Token(
            TokenType.NUMBER,
            input.substring(startIndex, passedValueIndex),
            Position(passedValueIndex, line,
                column + (passedValueIndex - startIndex)),
          );
        }
        break;

      case NumberState.EXP:
        if (char == '+' || char == '-') {
          state = NumberState.EXP_DIGIT_OR_SIGN;
        } else if (isDigit(char)) {
          passedValueIndex = index + 1;
          state = NumberState.EXP_DIGIT_OR_SIGN;
        } else {
          return Token(
            TokenType.NUMBER,
            input.substring(startIndex, passedValueIndex),
            Position(passedValueIndex, line,
                column + (passedValueIndex - startIndex)),
          );
        }
        break;

      case NumberState.EXP_DIGIT_OR_SIGN:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else {
          return Token(
            TokenType.NUMBER,
            input.substring(startIndex, passedValueIndex),
            Position(passedValueIndex, line,
                column + (passedValueIndex - startIndex)),
          );
        }
        break;
    }

    index++;
  }

  return null;
}

List<Token> tokenize(String input, {String? source}) {
  var line = 1;
  var column = 1;
  var index = 0;
  final tokens = <Token>[];

  while (index < input.length) {
    final args = [input, index, line, column];
    final whitespace = parseWhitespace(input, index, line, column);

    if (whitespace != null) {
      index = whitespace.index;
      line = whitespace.line;
      column = whitespace.column;
      continue;
    }

    final matched = parseChar(input, index, line, column) ??
        parseKeyword(input, index, line, column) ??
        parseString(input, index, line, column) ??
        parseNumber(input, index, line, column);

    if (matched != null) {
      final token = Token(
        matched.type,
        matched.value,
        Position(matched.position.index, matched.position.line,
            matched.position.column),
      );

      tokens.add(token);
      index = matched.position.index;
      line = matched.position.line;
      column = matched.position.column;
    } else {
      throw Exception('Unexpected symbol at $line:$column');
    }
  }

  return tokens;
}
