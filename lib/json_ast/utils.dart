bool isDigit1to9(String char) {
  return char.compareTo('1') >= 0 && char.compareTo('9') <= 0;
}

bool isDigit(String char) {
  return char.compareTo('0') >= 0 && char.compareTo('9') <= 0;
}

bool isHex(String char) {
  return isDigit(char) ||
      (char.compareTo('a') >= 0 && char.compareTo('f') <= 0) ||
      (char.compareTo('A') >= 0 && char.compareTo('F') <= 0);
}

bool isExp(String char) {
  return char == 'e' || char == 'E';
}

String substring(String str, int start, int end) {
  return str.substring(start, end);
}
