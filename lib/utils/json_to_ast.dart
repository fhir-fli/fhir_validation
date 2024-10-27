import 'dart:math';
import 'package:grapheme_splitter/grapheme_splitter.dart' show GraphemeSplitter;

import 'dart:math';
import 'package:grapheme_splitter/grapheme_splitter.dart' show GraphemeSplitter;

/// Custom exception class for handling JSON AST parsing errors.
class JSONASTException implements Exception {
  /// Constructor for the [JSONASTException] class.
  ///
  /// * [rawMessage]: The raw error message describing the issue.
  /// * [input]: The input JSON string where the error occurred.
  /// * [source]: The source of the input, typically a file name or URL.
  /// * [line]: The line number where the error occurred.
  /// * [column]: The column number where the error occurred.
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

  final String rawMessage;
  final String? input;
  final String source;
  final int line;
  final int column;
  String? _message;

  /// Returns the error message associated with this exception.
  String? get message => _message;
}

/// Generates a fragment of code to display where an error occurred.
///
/// * [input]: The input string.
/// * [linePos]: The line number where the error occurred.
/// * [columnPos]: The column number where the error occurred.
/// * [settings]: Optional settings for adjusting the display.
String codeErrorFragment(
  String input,
  int linePos,
  int columnPos, [
  Settings? settings,
]) {
  final splitter = RegExp(r'\r\n?|\n|\f');
  final lines = input.split(splitter);
  settings ??= Settings();
  final startLinePos = max(1, linePos - settings.extraLines) - 1;
  final int endLinePos = min(linePos + settings.extraLines, lines.length);
  final maxNumLength = endLinePos.toString().length;
  final prevLines =
      printLines(lines, startLinePos, linePos, maxNumLength, settings);
  final targetLineBeforeCursor = printLine(
    lines[linePos - 1].substring(0, columnPos - 1),
    linePos,
    maxNumLength,
    settings,
  );
  final cursorLine = '${repeatString(' ', targetLineBeforeCursor.length)}^';
  final nextLines =
      printLines(lines, linePos, endLinePos, maxNumLength, settings);

  return <String>[prevLines, cursorLine, nextLines]
      .where((String c) => c != 0)
      .join('\n');
}

/// Represents a basic location (line and column).
class Loc {
  Loc({required this.line, required this.column});
  final int line;
  final int column;
}

/// Represents a location segment with line, column, and offset.
class Segment extends Loc {
  Segment(int line, int column, this.offset)
      : super(line: line, column: column);
  final int offset;

  @override
  bool operator ==(Object other) =>
      other is Segment &&
      line == other.line &&
      column == other.column &&
      offset == other.offset;

  @override
  String toString() {
    return 'Segment($line, $column, $offset)';
  }
}

/// Represents a location within the input source, spanning from a start segment to an end segment.
class Location {
  Location(this.start, this.end, [this.source = ""]);
  final Segment start;
  final Segment end;
  final String source;

  @override
  bool operator ==(Object other) =>
      other is Location &&
      start == other.start &&
      end == other.end &&
      source == other.source;

  static Location create(
    int startLine,
    int startColumn,
    int startOffset,
    int endLine,
    int endColumn,
    int endOffset, [
    String source = '',
  ]) {
    final startSegment = Segment(startLine, startColumn, startOffset);
    final endSegment = Segment(endLine, endColumn, endOffset);
    return Location(startSegment, endSegment, source);
  }

  @override
  String toString() {
    final src = source.isNotEmpty ? '($source)' : '';
    return 'Location($start, $end$src)';
  }
}

/// Represents various token types used in parsing JSON.
enum TokenType {
  LEFT_BRACE, // {
  RIGHT_BRACE, // }
  LEFT_BRACKET, // [
  RIGHT_BRACKET, // ]
  COLON, // :
  COMMA, // ,
  STRING,
  NUMBER,
  TRUE, // true
  FALSE, // false
  NULL // null
}

/// Maps punctuators to their respective token types.
final Map<String, TokenType> punctuatorTokensMap = <String, TokenType>{
  '{': TokenType.LEFT_BRACE,
  '}': TokenType.RIGHT_BRACE,
  '[': TokenType.LEFT_BRACKET,
  ']': TokenType.RIGHT_BRACKET,
  ':': TokenType.COLON,
  ',': TokenType.COMMA,
};

/// Maps keywords to their respective token types.
final Map<String, TokenType> keywordTokensMap = <String, TokenType>{
  'true': TokenType.TRUE,
  'false': TokenType.FALSE,
  'null': TokenType.NULL,
};

/// Represents a single token with its type, line, column, and value.
class Token {
  Token(this.type, this.line, this.column, this.index, this.value);
  final TokenType? type;
  final int line;
  final int column;
  final int index;
  final String? value;
  Location? loc;
}

/// Base class representing a node in the abstract syntax tree (AST).
class Node {
  Node(this.type, {this.loc, this.parent});
  final String type;
  Location? loc;
  Node? parent; // Reference to the parent node, useful for traversing the AST.
  String path = '';

  /// Gets a child node associated with a given property name in an object.
  Node? getPropertyNode(String propertyName) {
    if (this is ObjectNode) {
      for (var property in (this as ObjectNode).children) {
        if (property.key?.value == propertyName) {
          return property.value;
        }
      }
    }
    return null;
  }

  /// Extracts "profile" nodes from the meta section of the AST.
  List<LiteralNode> extractProfileNodes() {
    var profileNodes = <LiteralNode>[];

    void traverse(Node node, String path) {
      if (node is ObjectNode) {
        for (var property in node.children) {
          final newPath = path.isEmpty
              ? property.key?.value
              : '$path.${property.key?.value}';
          if (newPath == 'meta.profile' && property.value is ArrayNode) {
            for (var item in (property.value! as ArrayNode).children) {
              if (item is LiteralNode) {
                profileNodes.add(item);
              }
            }
          } else if (newPath != null) {
            traverse(property.value!, newPath);
          }
        }
      } else if (node is ArrayNode) {
        for (var i = 0; i < node.children.length; i++) {
          final newPath = '$path[$i]';
          traverse(node.children[i], newPath);
        }
      }
    }

    traverse(this, '');
    return profileNodes;
  }

  @override
  String toString() {
    return '$type($loc)';
  }
}

/// Generates a path for the given node in the AST.
String getNodePath(Node node) {
  var segments = <String>[];
  Node? current = node;

  while (current != null) {
    if (current is PropertyNode && current.key != null) {
      segments.add(current.key!.value);
    } else if (current.parent is ArrayNode) {
      final arrayNode = current.parent! as ArrayNode;
      var index = arrayNode.children.indexOf(current);
      segments.add('[$index]');
    }
    current = current.parent;
  }

  segments = segments.reversed.toList();
  return segments.join('.');
}

/// Represents a value node in the AST.
class ValueNode extends Node {
  ValueNode(this.value, this.raw) : super('Identifier');
  final String value;
  final String? raw;

  @override
  bool operator ==(Object other) =>
      other is ValueNode &&
      type == other.type &&
      loc == other.loc &&
      value == other.value &&
      raw == other.raw;

  @override
  String toString() {
    return 'ValueNode($value, $raw)';
  }
}

/// Represents an object node in the AST.
class ObjectNode extends Node {
  ObjectNode({String path = ''}) : super('Object') {
    this.path = path;
  }
  final List<PropertyNode> children = <PropertyNode>[];

  @override
  bool operator ==(Object other) =>
      other is ObjectNode &&
      type == other.type &&
      loc == other.loc &&
      _compareDynamicList(children, other.children);
}

/// Helper function to compare lists of dynamic types.
bool _compareDynamicList(List<dynamic>? l, List<dynamic>? other) {
  if (l != null && other != null) {
    final len = l.length;
    if (len != other.length) {
      return false;
    }
    for (var i = 0; i < len; i++) {
      final dynamic el = l.elementAt(i);
      final dynamic otherEl = other.elementAt(i);
      if (el != otherEl) {
        return false;
      }
    }
  } else if (l == null && other != null || l != null && other == null) {
    return false;
  }
  return true;
}

/// Represents an array node in the AST.
class ArrayNode extends Node {
  ArrayNode({String path = ''}) : super('Array') {
    this.path = path;
  }
  final List<Node> children = <Node>[];

  @override
  bool operator ==(Object other) =>
      other is ArrayNode &&
      type == other.type &&
      loc == other.loc &&
      _compareDynamicList(children, other.children);
}

class PropertyNode extends Node {
  PropertyNode({String path = ''}) : super('Property') {
    this.path = path;
  }
  final List<Node> children = <Node>[];
  int? index;
  ValueNode? key;
  Node? value;

  @override
  bool operator ==(Object other) =>
      other is PropertyNode &&
      type == other.type &&
      index == other.index &&
      loc == other.loc &&
      key == other.key &&
      value == other.value &&
      _compareDynamicList(children, other.children);
}

class LiteralNode extends Node {
  LiteralNode(this.value, this.raw, {String path = ''}) : super('Literal') {
    this.path = path;
  }
  final dynamic value;
  final String? raw;

  @override
  bool operator ==(Object other) =>
      other is LiteralNode &&
      type == other.type &&
      loc == other.loc &&
      value == other.value &&
      raw == other.raw;

  @override
  String toString() {
    return 'LiteralNode($value, $raw)';
  }
}

class ValueIndex<T> {
  ValueIndex(this.value, this.index);
  final T value;
  final int index;

  @override
  bool operator ==(Object other) =>
      other is ValueIndex<T> && value == other.value && index == other.index;
}

enum _ObjectState { _START_, OPEN_OBJECT, PROPERTY, COMMA }

enum _PropertyState { _START_, KEY, COLON }

enum _ArrayState { _START_, OPEN_ARRAY, VALUE, COMMA }

enum _StringState { _START_, START_QUOTE_OR_CHAR, ESCAPE }

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

class Settings {
  Settings(
      {this.extraLines = 2, this.tabSize = 4, this.loc = true, this.source});
  final int extraLines;
  final int tabSize;
  final bool loc;
  final String? source;
}

String repeatString(String str, int n) {
  if (n == 0) {
    return '';
  } else if (n == 1) {
    return str;
  }
  final strBuf = StringBuffer();
  for (var i = 0; i < n; i++) {
    strBuf.write(str);
  }
  return strBuf.toString();
}

String printLine(
  String line,
  int position,
  int maxNumLength,
  Settings settings,
) {
  final n = position.toString();
  final formattedNum = n.padLeft(maxNumLength);
  final tabReplacement = repeatString(' ', settings.tabSize);
  return '$formattedNum | ${line.replaceAll('\t', tabReplacement)}';
}

String printLines(
  List<String> lines,
  int start,
  int end,
  int maxNumLength,
  Settings settings,
) {
  return lines
      .sublist(start, end)
      .asMap()
      .map(
        (int i, String line) => MapEntry<int, String>(
          i,
          printLine(line, start + i + 1, maxNumLength, settings),
        ),
      )
      .values
      .join('\n');
}

String substring(String str, int start, [int? end]) {
  end ??= start + 1;
  final splitter = GraphemeSplitter();
  final iterator = splitter.iterateGraphemes(str.substring(start));
  final strBuffer = StringBuffer();
  for (var i = 0; i < end - start; i++) {
    strBuffer.write(iterator.elementAt(i));
  }
  return strBuffer.toString();
}

String safeSubstring(String str, int start, int end) {
  final len = str.length;
  if (len > start) {
    final int lastIndex = min(len, end);
    return str.substring(start, lastIndex);
  }
  return '';
}

String unexpectedSymbol(String symbol, String source, int line, int column) {
  final sourceOrEmpty = source != '' ? '$source:' : '';
  final positionStr = '$sourceOrEmpty$line:$column';
  return 'Unexpected symbol <$symbol> at $positionStr';
}

String unexpectedEnd() => 'Unexpected end of input';

String unexpectedToken(String token, String source, int line, int column) {
  final sourceOrEmpty = source != '' ? '$source:' : '';
  final positionStr = '$sourceOrEmpty$line:$column';
  return 'Unexpected token <$token> at $positionStr';
}

ValueIndex<ObjectNode>? parseObject(
  String input,
  List<Token> tokenList,
  int index,
  Settings settings,
  String path,
) {
  late Token startToken;
  final object = ObjectNode(path: path);
  var state = _ObjectState._START_;

  while (index < tokenList.length) {
    final token = tokenList[index];

    switch (state) {
      case _ObjectState._START_:
        if (token.type == TokenType.LEFT_BRACE) {
          startToken = token;
          state = _ObjectState.OPEN_OBJECT;
          index++;
        } else {
          return null;
        }

      case _ObjectState.OPEN_OBJECT:
        if (token.type == TokenType.RIGHT_BRACE) {
          if (settings.loc) {
            final src = settings.source ?? '';
            object.loc = Location.create(
              startToken.loc!.start.line,
              startToken.loc!.start.column,
              startToken.loc!.start.offset,
              token.loc!.end.line,
              token.loc!.end.column,
              token.loc!.end.offset,
              src,
            );
          }
          return ValueIndex<ObjectNode>(object, index + 1);
        } else {
          final property =
              parseProperty(input, tokenList, index, settings, '$path.');
          if (property != null) {
            object.children.add(property.value);
            state = _ObjectState.PROPERTY;
            index = property.index;
          } else {
            final src = settings.source ?? '';
            final msg = unexpectedToken(
              substring(
                input,
                token.loc!.start.offset,
                token.loc!.end.offset,
              ),
              src,
              token.loc!.start.line,
              token.loc!.start.column,
            );
            throw JSONASTException(
              msg,
              input,
              src,
              token.loc!.start.line,
              token.loc!.start.column,
            );
          }
        }

      case _ObjectState.PROPERTY:
        if (token.type == TokenType.RIGHT_BRACE) {
          final src = settings.source ?? '';
          object.loc = Location.create(
            startToken.loc!.start.line,
            startToken.loc!.start.column,
            startToken.loc!.start.offset,
            token.loc!.end.line,
            token.loc!.end.column,
            token.loc!.end.offset,
            src,
          );
          return ValueIndex<ObjectNode>(object, index + 1);
        } else if (token.type == TokenType.COMMA) {
          state = _ObjectState.COMMA;
          index++;
        } else {
          final src = settings.source ?? '';
          final msg = unexpectedToken(
            substring(input, token.loc!.start.offset, token.loc!.end.offset),
            src,
            token.loc!.start.line,
            token.loc!.start.column,
          );
          throw JSONASTException(
            msg,
            input,
            src,
            token.loc!.start.line,
            token.loc!.start.column,
          );
        }

      case _ObjectState.COMMA:
        final property =
            parseProperty(input, tokenList, index, settings, '$path.');
        if (property != null) {
          property.value.parent = object; // Set parent reference
          index = property.index;
          object.children.add(property.value);
          state = _ObjectState.PROPERTY;
        } else {
          final src = settings.source ?? '';
          final msg = unexpectedToken(
            substring(input, token.loc!.start.offset, token.loc!.end.offset),
            src,
            token.loc!.start.line,
            token.loc!.start.column,
          );
          throw JSONASTException(
            msg,
            input,
            src,
            token.loc!.start.line,
            token.loc!.start.column,
          );
        }
    }
  }
  throw errorEof(input, tokenList, settings);
}

ValueIndex<PropertyNode>? parseProperty(
  String input,
  List<Token> tokenList,
  int index,
  Settings settings,
  String path,
) {
  late Token startToken;
  final property = PropertyNode(path: path);
  var state = _PropertyState._START_;

  while (index < tokenList.length) {
    final token = tokenList[index];

    switch (state) {
      case _PropertyState._START_:
        if (token.type == TokenType.STRING) {
          final value = token.value; // Use token.value directly
          if (value == null) {
            return null;
          }
          final key = ValueNode(value, token.value);
          key.loc = token.loc;
          key.parent = property; // Set parent reference
          startToken = token;
          property.key = key;
          property.path = '$path$value'; // Update path
          state = _PropertyState.KEY;
          index++;
        } else {
          return null;
        }

      case _PropertyState.KEY:
        if (token.type == TokenType.COLON) {
          state = _PropertyState.COLON;
          index++;
        } else {
          final src = settings.source ?? '';
          final msg = unexpectedToken(
            substring(input, token.loc!.start.offset, token.loc!.end.offset),
            src,
            token.loc!.start.line,
            token.loc!.start.column,
          );
          throw JSONASTException(
            msg,
            input,
            src,
            token.loc!.start.line,
            token.loc!.start.column,
          );
        }

      case _PropertyState.COLON:
        final value =
            _parseValue(input, tokenList, index, settings, property.path);
        value.value.parent = property; // Set parent reference
        property.value = value.value as Node?;
        final src = settings.source ?? '';
        property.loc = Location.create(
          startToken.loc!.start.line,
          startToken.loc!.start.column,
          startToken.loc!.start.offset,
          value.value.loc.end.line as int,
          value.value.loc.end.column as int,
          value.value.loc.end.offset as int,
          src,
        );
        return ValueIndex<PropertyNode>(property, value.index);
    }
  }
  return null;
}

ValueIndex<ArrayNode>? parseArray(
  String input,
  List<Token> tokenList,
  int index,
  Settings settings,
  String path,
) {
  late Token startToken;
  final array = ArrayNode(path: path);
  var state = _ArrayState._START_;
  Token token;
  while (index < tokenList.length) {
    token = tokenList[index];
    switch (state) {
      case _ArrayState._START_:
        if (token.type == TokenType.LEFT_BRACKET) {
          startToken = token;
          state = _ArrayState.OPEN_ARRAY;
          index++;
        } else {
          return null;
        }

      case _ArrayState.OPEN_ARRAY:
        if (token.type == TokenType.RIGHT_BRACKET) {
          final src = settings.source ?? '';
          array.loc = Location.create(
            startToken.loc!.start.line,
            startToken.loc!.start.column,
            startToken.loc!.start.offset,
            token.loc!.end.line,
            token.loc!.end.column,
            token.loc!.end.offset,
            src,
          );
          return ValueIndex<ArrayNode>(array, index + 1);
        } else {
          final value = _parseValue(
            input,
            tokenList,
            index,
            settings,
            '$path[${array.children.length}]',
          );
          value.value.parent = array; // Set parent reference
          index = value.index;
          array.children.add(value.value as Node);
          state = _ArrayState.VALUE;
        }

      case _ArrayState.VALUE:
        if (token.type == TokenType.RIGHT_BRACKET) {
          final src = settings.source ?? '';
          array.loc = Location.create(
            startToken.loc!.start.line,
            startToken.loc!.start.column,
            startToken.loc!.start.offset,
            token.loc!.end.line,
            token.loc!.end.column,
            token.loc!.end.offset,
            src,
          );
          return ValueIndex<ArrayNode>(array, index + 1);
        } else if (token.type == TokenType.COMMA) {
          state = _ArrayState.COMMA;
          index++;
        } else {
          final src = settings.source ?? '';
          final msg = unexpectedToken(
            substring(input, token.loc!.start.offset, token.loc!.end.offset),
            src,
            token.loc!.start.line,
            token.loc!.start.column,
          );
          throw JSONASTException(
            msg,
            input,
            src,
            token.loc!.start.line,
            token.loc!.start.column,
          );
        }

      case _ArrayState.COMMA:
        final value = _parseValue(
          input,
          tokenList,
          index,
          settings,
          '$path[${array.children.length}]',
        );
        value.value.parent = array; // Set parent reference
        index = value.index;
        array.children.add(value.value as Node);
        state = _ArrayState.VALUE;
    }
  }
  throw errorEof(input, tokenList, settings);
}

ValueIndex<LiteralNode>? parseLiteral(
  String input,
  List<Token> tokenList,
  int index,
  Settings settings,
  String path,
) {
  final token = tokenList[index];
  Object? value;

  switch (token.type) {
    case TokenType.STRING:
      value = token.value; // Use token.value directly
      if (value == null) {
        return null;
      }
    case TokenType.NUMBER:
      if (token.value != null) {
        value = int.tryParse(token.value!);
        value ??= double.tryParse(token.value!) ?? null;
      }
    case TokenType.TRUE:
      value = true;
    case TokenType.FALSE:
      value = false;
    case TokenType.NULL:
      value = null;
    default:
      return null;
  }

  final literal = LiteralNode(value, token.value, path: path);
  literal.loc = token.loc;
  return ValueIndex<LiteralNode>(literal, index + 1);
}

typedef _parserFun = ValueIndex<dynamic>? Function(String input,
    List<Token> tokenList, int index, Settings settings, String path);

List<_parserFun> _parsersList = <_parserFun>[
  parseLiteral,
  parseObject,
  parseArray,
];

ValueIndex<dynamic>? _findValueIndex(
  String input,
  List<Token> tokenList,
  int index,
  Settings settings,
  String path,
) {
  for (final parser in _parsersList) {
    final valueIndex = parser(input, tokenList, index, settings, path);
    if (valueIndex != null) {
      return valueIndex;
    }
  }
  return null;
}

ValueIndex<dynamic> _parseValue(
  String input,
  List<Token> tokenList,
  int index,
  Settings settings,
  String path,
) {
  final token = tokenList[index];
  final value = _findValueIndex(input, tokenList, index, settings, path);

  if (value != null) {
    return value;
  } else {
    final src = settings.source ?? '';
    final msg = unexpectedToken(
      substring(input, token.loc!.start.offset, token.loc!.end.offset),
      src,
      token.loc!.start.line,
      token.loc!.start.column,
    );
    throw JSONASTException(
      msg,
      input,
      src,
      token.loc!.start.line,
      token.loc!.start.column,
    );
  }
}

Node parse(String input, Settings settings, String path) {
  final tokenList = tokenize(input, settings);

  if (tokenList.isEmpty) {
    throw errorEof(input, tokenList, settings);
  }

  final value = _parseValue(input, tokenList, 0, settings, path);

  if (value.index == tokenList.length) {
    return value.value as Node;
  }

  final token = tokenList[value.index];
  final src = settings.source ?? '';
  final msg = unexpectedToken(
    substring(input, token.loc!.start.offset, token.loc!.end.offset),
    src,
    token.loc!.start.line,
    token.loc!.start.column,
  );
  throw JSONASTException(
    msg,
    input,
    src,
    token.loc!.start.line,
    token.loc!.start.column,
  );
}

JSONASTException errorEof(
  String input,
  List<dynamic> tokenList,
  Settings settings,
) {
  final loc = tokenList.isNotEmpty
      ? tokenList.last.loc.end as Loc
      : Loc(line: 1, column: 1);
  final src = settings.source ?? '';
  return JSONASTException(unexpectedEnd(), input, src, loc.line, loc.column);
}

typedef _tokenParser = Token? Function(
    String input, int index, int line, int column);

List<_tokenParser> _parsers = <_tokenParser>[
  parseChar,
  parseKeyword,
  parseString,
  parseNumber,
];

Token? _parseToken(String input, int index, int line, int column) {
  for (final parser in _parsers) {
    final token = parser(input, index, line, column);
    if (token != null) {
      return token;
    }
  }
  return null;
}

class Position {
  Position(this.index, this.line, this.column);
  final int index;
  final int line;
  final int column;
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
  for (final entry in entries) {
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
  var state = _StringState._START_;
  final stringBuffer = StringBuffer();

  while (index < input.length) {
    final char = input[index];

    switch (state) {
      case _StringState._START_:
        if (char == '"') {
          index++;
          state = _StringState.START_QUOTE_OR_CHAR;
        } else {
          return null;
        }

      case _StringState.START_QUOTE_OR_CHAR:
        if (char == r'\') {
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

      case _StringState.ESCAPE:
        if (escapes.containsKey(char)) {
          index++;
          if (char == 'u') {
            for (var i = 0; i < 4; i++) {
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
    }
  }
  return null;
}

Token? parseNumber(String input, int index, int line, int column) {
  final startIndex = index;
  var passedValueIndex = index;
  var state = _NumberState._START_;

  iterator:
  while (index < input.length) {
    final char = input[index];

    switch (state) {
      case _NumberState._START_:
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

      case _NumberState.MINUS:
        if (char == '0') {
          passedValueIndex = index + 1;
          state = _NumberState.ZERO;
        } else if (isDigit1to9(char)) {
          passedValueIndex = index + 1;
          state = _NumberState.DIGIT;
        } else {
          return null;
        }

      case _NumberState.ZERO:
        if (char == '.') {
          state = _NumberState.POINT;
        } else if (isExp(char)) {
          state = _NumberState.EXP;
        } else {
          break iterator;
        }

      case _NumberState.DIGIT:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else if (char == '.') {
          state = _NumberState.POINT;
        } else if (isExp(char)) {
          state = _NumberState.EXP;
        } else {
          break iterator;
        }

      case _NumberState.POINT:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
          state = _NumberState.DIGIT_FRACTION;
        } else {
          break iterator;
        }

      case _NumberState.DIGIT_FRACTION:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else if (isExp(char)) {
          state = _NumberState.EXP;
        } else {
          break iterator;
        }

      case _NumberState.EXP:
        if (char == '+' || char == '-') {
          state = _NumberState.EXP_DIGIT_OR_SIGN;
        } else if (isDigit(char)) {
          passedValueIndex = index + 1;
          state = _NumberState.EXP_DIGIT_OR_SIGN;
        } else {
          break iterator;
        }

      case _NumberState.EXP_DIGIT_OR_SIGN:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else {
          break iterator;
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
      safeSubstring(input, startIndex, passedValueIndex),
    );
  }

  return null;
}

List<Token> tokenize(String input, Settings settings) {
  var line = 1;
  var column = 1;
  var index = 0;
  var tokens = <Token>[];

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
      final src = settings.source ?? '';
      token.loc = Location.create(
        line,
        column,
        index,
        token.line,
        token.column,
        token.index,
        src,
      );
      tokens.add(token);
      index = token.index;
      line = token.line;
      column = token.column;
    } else {
      final src = settings.source ?? '';
      final msg = unexpectedSymbol(
        substring(input, index, index + 1),
        src,
        line,
        column,
      );
      throw JSONASTException(msg, input, src, line, column);
    }
  }
  return tokens;
}

// HELPERS

bool isDigit1to9(String char) {
  final charCode = char.codeUnitAt(0);
  return charCode >= '1'.codeUnitAt(0) && charCode <= '9'.codeUnitAt(0);
}

bool isDigit(String char) {
  final charCode = char.codeUnitAt(0);
  return charCode >= '0'.codeUnitAt(0) && charCode <= '9'.codeUnitAt(0);
}

bool isHex(String char) {
  final charCode = char.codeUnitAt(0);
  return isDigit(char) ||
      (charCode >= 'a'.codeUnitAt(0) && charCode <= 'f'.codeUnitAt(0)) ||
      (charCode >= 'A'.codeUnitAt(0) && charCode <= 'F'.codeUnitAt(0));
}

bool isExp(String char) {
  return char == 'e' || char == 'E';
}

final Map<String, int> escapes = <String, int>{
  '"': 0, // Quotation mask
  r'\': 1, // Reverse solidus
  '/': 2, // Solidus
  'b': 3, // Backspace
  'f': 4, // Form feed
  'n': 5, // New line
  'r': 6, // Carriage return
  't': 7, // Horizontal tab
  'u': 8, // 4 hexadecimal digits
};
