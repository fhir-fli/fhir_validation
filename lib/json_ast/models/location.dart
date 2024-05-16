class Position {
  final int line;
  final int column;
  final int offset;

  Position(this.line, this.column, this.offset);
}

class Location {
  final Position start;
  final Position end;
  final String? source;

  Location(this.start, this.end, [this.source]);

  static Location create(int startLine, int startColumn, int startOffset,
      int endLine, int endColumn, int endOffset,
      [String? source]) {
    final start = Position(startLine, startColumn, startOffset);
    final end = Position(endLine, endColumn, endOffset);
    return Location(start, end, source);
  }
}
