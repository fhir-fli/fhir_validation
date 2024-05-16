class Settings {
  final int extraLines;
  final int tabSize;
  final bool loc;
  final String? source;

  Settings(
      {this.extraLines = 2, this.tabSize = 4, this.loc = true, this.source});
}

String repeatString(String str, int n) {
  if (n == 0) {
    return '';
  } else if (n == 1) {
    return str;
  }
  final strBuf = StringBuffer();
  for (int i = 0; i < n; i++) {
    strBuf.write(str);
  }
  return strBuf.toString();
}

String printLine(
    String line, int position, int maxNumLength, Settings settings) {
  final n = position.toString();
  final formattedNum = n.padLeft(maxNumLength);
  final tabReplacement = repeatString(' ', settings.tabSize);
  return formattedNum + ' | ' + line.replaceAll('\t', tabReplacement);
}

String printLines(List<String> lines, int start, int end, int maxNumLength,
    Settings settings) {
  return lines
      .sublist(start, end)
      .asMap()
      .map((i, line) =>
          MapEntry(i, printLine(line, start + i + 1, maxNumLength, settings)))
      .values
      .join('\n');
}
