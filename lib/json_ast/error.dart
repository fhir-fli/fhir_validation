import 'dart:math';

import 'json_ast.dart';

class JSONASTException implements Exception {
  final String rawMessage;
  final String? input;
  final String source;
  final int line;
  final int column;
  String? _message;

  JSONASTException(
      this.rawMessage, this.input, this.source, this.line, this.column) {
    if (input != null) {
      _message = line != 0
          ? '$rawMessage\n${codeErrorFragment(input!, line, column)}'
          : rawMessage;
    } else {
      _message = rawMessage;
    }
  }

  String? get message => _message;
}

String codeErrorFragment(String input, int linePos, int columnPos,
    [Settings? settings]) {
  final splitter = RegExp(r"\r\n?|\n|\f");
  final lines = input.split(splitter);
  settings = settings ?? Settings();
  final startLinePos = max(1, linePos - settings.extraLines) - 1;
  final endLinePos = min(linePos + settings.extraLines, lines.length);
  final maxNumLength = endLinePos.toString().length;
  final prevLines =
      printLines(lines, startLinePos, linePos, maxNumLength, settings);
  final targetLineBeforeCursor = printLine(
      lines[linePos - 1].substring(0, columnPos - 1),
      linePos,
      maxNumLength,
      settings);
  final cursorLine = repeatString(' ', targetLineBeforeCursor.length) + '^';
  final nextLines =
      printLines(lines, linePos, endLinePos, maxNumLength, settings);

  return [prevLines, cursorLine, nextLines].where((c) => c != 0).join('\n');
}
