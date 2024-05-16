import 'json_ast.dart';

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

enum _StringState { _START_, START_QUOTE_OR_CHAR, ESCAPE }

final Map<String, int> escapes = {
  '"': 0, // Quotation mask
  '\\': 1, // Reverse solidus
  '/': 2, // Solidus
  'b': 3, // Backspace
  'f': 4, // Form feed
  'n': 5, // New line
  'r': 6, // Carriage return
  't': 7, // Horizontal tab
  'u': 8 // 4 hexadecimal digits
};

enum _NumberState {
  _START_,
  MINUS,
  ZERO,
  DIGIT,
  POINT,
  DIGIT_FRACTION,
  EXP,
  EXP_DIGIT_OR_SIGN
}

class Token {
  final TokenType? type;
  final int line;
  final int column;
  final int index;
  final String? value;
  Location? loc;

  Token(this.type, this.line, this.column, this.index, this.value);
}

typedef Token? _tokenParser(String input, int index, int line, int column);

List<_tokenParser> _parsers = [
  parseChar,
  parseKeyword,
  parseString,
  parseNumber
];

Token? _parseToken(String input, int index, int line, int column) {
  for (int i = 0; i < _parsers.length; i++) {
    final token = _parsers[i](input, index, line, column);
    if (token != null) {
      return token;
    }
  }
  return null;
}

class Position {
  final int index;
  final int line;
  final int column;

  Position(this.index, this.line, this.column);
}

Position? parseWhitespace(String input, int index, int line, int column) {
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

  return Position(index, line, column);
}

Token? parseChar(String input, int index, int line, int column) {
  final char = input[index];
  if (punctuatorTokensMap.containsKey(char)) {
    final tokenType = punctuatorTokensMap[char];
    return Token(tokenType, line, column + 1, index + 1, null);
  }

  return null;
}

Token? parseKeyword(String input, int index, int line, int column) {
  final entries = keywordTokensMap.entries;
  for (int i = 0; i < entries.length; i++) {
    final entry = entries.elementAt(i);
    final keyLen = entry.key.length;
    final nextLen = index + keyLen;
    final lastIndex = nextLen > input.length ? input.length : nextLen;
    if (safeSubstring(input, index, lastIndex) == entry.key) {
      return Token(entry.value, line, column + keyLen, lastIndex, entry.key);
    }
  }

  return null;
}

Token? parseString(String input, int index, int line, int column) {
  final startIndex = index;
  _StringState state = _StringState._START_;
  final stringBuffer = StringBuffer();

  while (index < input.length) {
    final char = input[index];

    switch (state) {
      case _StringState._START_:
        {
          if (char == '"') {
            index++;
            state = _StringState.START_QUOTE_OR_CHAR;
          } else {
            return null;
          }
          break;
        }

      case _StringState.START_QUOTE_OR_CHAR:
        {
          if (char == '\\') {
            index++;
            state = _StringState.ESCAPE;
          } else if (char == '"') {
            index++;
            return Token(
              TokenType.STRING,
              line,
              column + (index - startIndex),
              index,
              stringBuffer.toString(),
            );
          } else {
            stringBuffer.write(char);
            index++;
          }
          break;
        }

      case _StringState.ESCAPE:
        {
          if (escapes.containsKey(char)) {
            index++;
            if (char == 'u') {
              for (int i = 0; i < 4; i++) {
                final curChar = input[index];
                if (curChar != '' && isHex(curChar)) {
                  stringBuffer.write(curChar);
                  index++;
                } else {
                  return null;
                }
              }
            } else {
              stringBuffer.write(char);
            }
            state = _StringState.START_QUOTE_OR_CHAR;
          } else {
            return null;
          }
          break;
        }
    }
  }
  return null;
}

Token? parseNumber(String input, int index, int line, int column) {
  final startIndex = index;
  int passedValueIndex = index;
  _NumberState state = _NumberState._START_;

  iterator:
  while (index < input.length) {
    final char = input[index];

    switch (state) {
      case _NumberState._START_:
        {
          if (char == '-') {
            state = _NumberState.MINUS;
          } else if (char == '0') {
            passedValueIndex = index + 1;
            state = _NumberState.ZERO;
          } else if (isDigit1to9(char)) {
            passedValueIndex = index + 1;
            state = _NumberState.DIGIT;
          } else {
            return null;
          }
          break;
        }

      case _NumberState.MINUS:
        {
          if (char == '0') {
            passedValueIndex = index + 1;
            state = _NumberState.ZERO;
          } else if (isDigit1to9(char)) {
            passedValueIndex = index + 1;
            state = _NumberState.DIGIT;
          } else {
            return null;
          }
          break;
        }

      case _NumberState.ZERO:
        {
          if (char == '.') {
            state = _NumberState.POINT;
          } else if (isExp(char)) {
            state = _NumberState.EXP;
          } else {
            break iterator;
          }
          break;
        }

      case _NumberState.DIGIT:
        {
          if (isDigit(char)) {
            passedValueIndex = index + 1;
          } else if (char == '.') {
            state = _NumberState.POINT;
          } else if (isExp(char)) {
            state = _NumberState.EXP;
          } else {
            break iterator;
          }
          break;
        }

      case _NumberState.POINT:
        {
          if (isDigit(char)) {
            passedValueIndex = index + 1;
            state = _NumberState.DIGIT_FRACTION;
          } else {
            break iterator;
          }
          break;
        }

      case _NumberState.DIGIT_FRACTION:
        {
          if (isDigit(char)) {
            passedValueIndex = index + 1;
          } else if (isExp(char)) {
            state = _NumberState.EXP;
          } else {
            break iterator;
          }
          break;
        }

      case _NumberState.EXP:
        {
          if (char == '+' || char == '-') {
            state = _NumberState.EXP_DIGIT_OR_SIGN;
          } else if (isDigit(char)) {
            passedValueIndex = index + 1;
            state = _NumberState.EXP_DIGIT_OR_SIGN;
          } else {
            break iterator;
          }
          break;
        }

      case _NumberState.EXP_DIGIT_OR_SIGN:
        {
          if (isDigit(char)) {
            passedValueIndex = index + 1;
          } else {
            break iterator;
          }
          break;
        }
    }

    index++;
  }

  if (passedValueIndex > 0) {
    return Token(
        TokenType.NUMBER,
        line,
        column + (passedValueIndex - startIndex),
        passedValueIndex,
        safeSubstring(input, startIndex, passedValueIndex));
  }

  return null;
}

List<Token> tokenize(String input, Settings settings) {
  int line = 1;
  int column = 1;
  int index = 0;
  List<Token> tokens = <Token>[];

  while (index < input.length) {
    final whitespace = parseWhitespace(input, index, line, column);
    if (whitespace != null) {
      index = whitespace.index;
      line = whitespace.line;
      column = whitespace.column;
      continue;
    }

    final token = _parseToken(input, index, line, column);

    if (token != null) {
      final src = settings.source ?? "";
      token.loc = Location.create(
          line, column, index, token.line, token.column, token.index, src);
      tokens.add(token);
      index = token.index;
      line = token.line;
      column = token.column;
    } else {
      final src = settings.source ?? "";
      final msg = unexpectedSymbol(
          substring(input, index, index + 1), src, line, column);
      throw JSONASTException(msg, input, src, line, column);
    }
  }
  return tokens;
}
