class Loc {
  final int line;
  final int column;

  Loc({required this.line, required this.column});
}

class Segment extends Loc {
  final int offset;

  Segment(int line, int column, this.offset)
      : super(line: line, column: column);

  bool operator ==(Object other) =>
      other is Segment &&
      line == other.line &&
      column == other.column &&
      offset == other.offset;
}

class Location {
  final Segment start;
  final Segment end;
  final String source;

  Location(this.start, this.end, [this.source = ""]);

  bool operator ==(Object other) =>
      other is Location &&
      start == other.start &&
      end == other.end &&
      source == other.source;

  static Location create(int startLine, int startColumn, int startOffset,
      int endLine, int endColumn, int endOffset,
      [String source = ""]) {
    final startSegment = Segment(startLine, startColumn, startOffset);
    final endSegment = Segment(endLine, endColumn, endOffset);
    return Location(startSegment, endSegment, source);
  }
}
