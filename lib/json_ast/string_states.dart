class StringStates {
  static const int START = 0;
  static const int START_QUOTE_OR_CHAR = 1;
  static const int ESCAPE = 2;
}

final Map<String, int> escapes = {
  '"': 0, // Quotation mark
  '\\': 1, // Reverse solidus
  '/': 2, // Solidus
  'b': 3, // Backspace
  'f': 4, // Form feed
  'n': 5, // New line
  'r': 6, // Carriage return
  't': 7, // Horizontal tab
  'u': 8, // 4 hexadecimal digits
};
