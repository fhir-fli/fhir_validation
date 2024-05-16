class TokenTypes {
  static const int LEFT_BRACE = 0; // {
  static const int RIGHT_BRACE = 1; // }
  static const int LEFT_BRACKET = 2; // [
  static const int RIGHT_BRACKET = 3; // ]
  static const int COLON = 4; // :
  static const int COMMA = 5; // ,
  static const int STRING = 6; //
  static const int NUMBER = 7; //
  static const int TRUE = 8; // true
  static const int FALSE = 9; // false
  static const int NULL = 10; // null
}

final Map<String, int> punctuatorTokensMap = {
  '{': TokenTypes.LEFT_BRACE,
  '}': TokenTypes.RIGHT_BRACE,
  '[': TokenTypes.LEFT_BRACKET,
  ']': TokenTypes.RIGHT_BRACKET,
  ':': TokenTypes.COLON,
  ',': TokenTypes.COMMA,
};

final Map<String, int> keywordTokensMap = {
  'true': TokenTypes.TRUE,
  'false': TokenTypes.FALSE,
  'null': TokenTypes.NULL,
};
