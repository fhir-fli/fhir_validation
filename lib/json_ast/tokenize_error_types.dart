class TokenizeErrorTypes {
  static String unexpectedEnd() {
    return 'Unexpected end of input';
  }

  static String unexpectedToken(String token, List<String?> position) {
    return 'Unexpected token <$token> at ${position.where((element) => element != null).join(':')}';
  }

  static String unexpectedSymbol(String symbol, List<String?> position) {
    return 'Unexpected symbol <$symbol> at ${position.where((element) => element != null).join(':')}';
  }
}
