class ParseErrorTypes {
  static String unexpectedEnd() {
    return 'Unexpected end of input';
  }

  static String unexpectedToken(String token, List<String?> position) {
    return 'Unexpected token <$token> at ${position.where((element) => element != null).join(':')}';
  }
}
