import 'dart:math';
import 'package:grapheme_splitter/grapheme_splitter.dart' show GraphemeSplitter;

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
  final RegExp splitter = RegExp(r"\r\n?|\n|\f");
  final List<String> lines = input.split(splitter);
  settings ??= Settings();
  final int startLinePos = max(1, linePos - settings.extraLines) - 1;
  final int endLinePos = min(linePos + settings.extraLines, lines.length);
  final int maxNumLength = endLinePos.toString().length;
  final String prevLines =
      printLines(lines, startLinePos, linePos, maxNumLength, settings);
  final String targetLineBeforeCursor = printLine(
      lines[linePos - 1].substring(0, columnPos - 1),
      linePos,
      maxNumLength,
      settings);
  final String cursorLine =
      repeatString(' ', targetLineBeforeCursor.length) + '^';
  final String nextLines =
      printLines(lines, linePos, endLinePos, maxNumLength, settings);

  return <String>[prevLines, cursorLine, nextLines]
      .where((String c) => c != 0)
      .join('\n');
}

class Loc {
  final int line;
  final int column;

  Loc({required this.line, required this.column});
}

class Segment extends Loc {
  final int offset;

  Segment(int line, int column, this.offset)
      : super(line: line, column: column);

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

class Location {
  final Segment start;
  final Segment end;
  final String source;

  Location(this.start, this.end, [this.source = ""]);

  @override
  bool operator ==(Object other) =>
      other is Location &&
      start == other.start &&
      end == other.end &&
      source == other.source;

  static Location create(int startLine, int startColumn, int startOffset,
      int endLine, int endColumn, int endOffset,
      [String source = ""]) {
    final Segment startSegment = Segment(startLine, startColumn, startOffset);
    final Segment endSegment = Segment(endLine, endColumn, endOffset);
    return Location(startSegment, endSegment, source);
  }

  @override
  String toString() {
    final String src = source.isNotEmpty ? '($source)' : '';
    return 'Location($start, $end$src)';
  }
}

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

final Map<String, TokenType> punctuatorTokensMap = <String, TokenType>{
  '{': TokenType.LEFT_BRACE,
  '}': TokenType.RIGHT_BRACE,
  '[': TokenType.LEFT_BRACKET,
  ']': TokenType.RIGHT_BRACKET,
  ':': TokenType.COLON,
  ',': TokenType.COMMA
};

final Map<String, TokenType> keywordTokensMap = <String, TokenType>{
  'true': TokenType.TRUE,
  'false': TokenType.FALSE,
  'null': TokenType.NULL
};

class Token {
  final TokenType? type;
  final int line;
  final int column;
  final int index;
  final String? value;
  Location? loc;

  Token(this.type, this.line, this.column, this.index, this.value);
}

class Node {
  final String type;
  Location? loc;
  Node? parent; // Add parent reference
  String path = '';

  Node(this.type, {this.loc, this.parent});

  Node? getPropertyNode(String propertyName) {
    if (this is ObjectNode) {
      for (PropertyNode property in (this as ObjectNode).children) {
        if (property.key?.value == propertyName) {
          return property.value;
        }
      }
    }
    return null;
  }

  List<LiteralNode> extractProfileNodes() {
    List<LiteralNode> profileNodes = <LiteralNode>[];

    void traverse(Node node, String path) {
      if (node is ObjectNode) {
        for (PropertyNode property in node.children) {
          final String? newPath = path.isEmpty
              ? property.key?.value
              : '$path.${property.key?.value}';
          if (newPath == 'meta.profile' && property.value is ArrayNode) {
            for (Node item in (property.value as ArrayNode).children) {
              if (item is LiteralNode) {
                profileNodes.add(item);
              }
            }
          } else if (newPath != null) {
            traverse(property.value!, newPath);
          }
        }
      } else if (node is ArrayNode) {
        for (int i = 0; i < node.children.length; i++) {
          final String newPath = '$path[$i]';
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

String getNodePath(Node node) {
  List<String> segments = <String>[];
  Node? current = node;

  while (current != null) {
    if (current is PropertyNode && current.key != null) {
      segments.add(current.key!.value);
    } else if (current.parent is ArrayNode) {
      ArrayNode arrayNode = current.parent as ArrayNode;
      int index = arrayNode.children.indexOf(current);
      segments.add('[$index]');
    }
    current = current.parent;
  }

  segments = segments.reversed.toList();
  return segments.join('.');
}

class ValueNode extends Node {
  final String value;
  final String? raw;

  ValueNode(this.value, this.raw) : super('Identifier');

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

class ObjectNode extends Node {
  final List<PropertyNode> children = <PropertyNode>[];

  ObjectNode({String path = ''}) : super('Object') {
    this.path = path;
  }

  @override
  bool operator ==(Object other) =>
      other is ObjectNode &&
      type == other.type &&
      loc == other.loc &&
      _compareDynamicList(children, other.children);
}

bool _compareDynamicList(List<dynamic>? l, List<dynamic>? other) {
  if (l != null && other != null) {
    final int len = l.length;
    if (len != other.length) {
      return false;
    }
    for (int i = 0; i < len; i++) {
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

class ArrayNode extends Node {
  final List<Node> children = <Node>[];

  ArrayNode({String path = ''}) : super('Array') {
    this.path = path;
  }

  @override
  bool operator ==(Object other) =>
      other is ArrayNode &&
      type == other.type &&
      loc == other.loc &&
      _compareDynamicList(children, other.children);
}

class PropertyNode extends Node {
  final List<Node> children = <Node>[];
  int? index;
  ValueNode? key;
  Node? value;

  PropertyNode({String path = ''}) : super('Property') {
    this.path = path;
  }

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
  final dynamic value;
  final String? raw;

  LiteralNode(this.value, this.raw, {String path = ''}) : super('Literal') {
    this.path = path;
  }

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
  final T value;
  final int index;

  ValueIndex(this.value, this.index);

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
  final StringBuffer strBuf = StringBuffer();
  for (int i = 0; i < n; i++) {
    strBuf.write(str);
  }
  return strBuf.toString();
}

String printLine(
    String line, int position, int maxNumLength, Settings settings) {
  final String n = position.toString();
  final String formattedNum = n.padLeft(maxNumLength);
  final String tabReplacement = repeatString(' ', settings.tabSize);
  return formattedNum + ' | ' + line.replaceAll('\t', tabReplacement);
}

String printLines(List<String> lines, int start, int end, int maxNumLength,
    Settings settings) {
  return lines
      .sublist(start, end)
      .asMap()
      .map((int i, String line) => MapEntry<int, String>(
          i, printLine(line, start + i + 1, maxNumLength, settings)))
      .values
      .join('\n');
}

String substring(String str, int start, [int? end]) {
  if (end == null) {
    end = start + 1;
  }
  final GraphemeSplitter splitter = GraphemeSplitter();
  final Iterable<String> iterator =
      splitter.iterateGraphemes(str.substring(start));
  final StringBuffer strBuffer = StringBuffer();
  for (int i = 0; i < end - start; i++) {
    strBuffer.write(iterator.elementAt(i));
  }
  return strBuffer.toString();
}

String safeSubstring(String str, int start, int end) {
  final int len = str.length;
  if (len > start) {
    final int lastIndex = min(len, end);
    return str.substring(start, lastIndex);
  }
  return '';
}

String unexpectedSymbol(String symbol, String source, int line, int column) {
  final String sourceOrEmpty = source != "" ? '$source:' : '';
  final String positionStr = '$sourceOrEmpty${line}:$column';
  return 'Unexpected symbol <$symbol> at $positionStr';
}

String unexpectedEnd() => 'Unexpected end of input';

String unexpectedToken(String token, String source, int line, int column) {
  final String sourceOrEmpty = source != "" ? '$source:' : '';
  final String positionStr = '$sourceOrEmpty${line}:$column';
  return 'Unexpected token <$token> at $positionStr';
}

ValueIndex<ObjectNode>? parseObject(String input, List<Token> tokenList,
    int index, Settings settings, String path) {
  late Token startToken;
  final ObjectNode object = ObjectNode(path: path);
  _ObjectState state = _ObjectState._START_;

  while (index < tokenList.length) {
    final Token token = tokenList[index];

    switch (state) {
      case _ObjectState._START_:
        if (token.type == TokenType.LEFT_BRACE) {
          startToken = token;
          state = _ObjectState.OPEN_OBJECT;
          index++;
        } else {
          return null;
        }
        break;

      case _ObjectState.OPEN_OBJECT:
        if (token.type == TokenType.RIGHT_BRACE) {
          if (settings.loc) {
            final String src = settings.source ?? "";
            object.loc = Location.create(
                startToken.loc!.start.line,
                startToken.loc!.start.column,
                startToken.loc!.start.offset,
                token.loc!.end.line,
                token.loc!.end.column,
                token.loc!.end.offset,
                src);
          }
          return ValueIndex<ObjectNode>(object, index + 1);
        } else {
          final ValueIndex<PropertyNode>? property =
              parseProperty(input, tokenList, index, settings, '$path.');
          if (property != null) {
            object.children.add(property.value);
            state = _ObjectState.PROPERTY;
            index = property.index;
          } else {
            final String src = settings.source ?? "";
            final String msg = unexpectedToken(
                substring(
                    input, token.loc!.start.offset, token.loc!.end.offset),
                src,
                token.loc!.start.line,
                token.loc!.start.column);
            throw JSONASTException(msg, input, src, token.loc!.start.line,
                token.loc!.start.column);
          }
        }
        break;

      case _ObjectState.PROPERTY:
        if (token.type == TokenType.RIGHT_BRACE) {
          final String src = settings.source ?? "";
          object.loc = Location.create(
              startToken.loc!.start.line,
              startToken.loc!.start.column,
              startToken.loc!.start.offset,
              token.loc!.end.line,
              token.loc!.end.column,
              token.loc!.end.offset,
              src);
          return ValueIndex<ObjectNode>(object, index + 1);
        } else if (token.type == TokenType.COMMA) {
          state = _ObjectState.COMMA;
          index++;
        } else {
          final String src = settings.source ?? "";
          final String msg = unexpectedToken(
              substring(input, token.loc!.start.offset, token.loc!.end.offset),
              src,
              token.loc!.start.line,
              token.loc!.start.column);
          throw JSONASTException(
              msg, input, src, token.loc!.start.line, token.loc!.start.column);
        }
        break;

      case _ObjectState.COMMA:
        final ValueIndex<PropertyNode>? property =
            parseProperty(input, tokenList, index, settings, '$path.');
        if (property != null) {
          property.value.parent = object; // Set parent reference
          index = property.index;
          object.children.add(property.value);
          state = _ObjectState.PROPERTY;
        } else {
          final String src = settings.source ?? "";
          final String msg = unexpectedToken(
              substring(input, token.loc!.start.offset, token.loc!.end.offset),
              src,
              token.loc!.start.line,
              token.loc!.start.column);
          throw JSONASTException(
              msg, input, src, token.loc!.start.line, token.loc!.start.column);
        }
        break;
    }
  }
  throw errorEof(input, tokenList, settings);
}

ValueIndex<PropertyNode>? parseProperty(String input, List<Token> tokenList,
    int index, Settings settings, String path) {
  late Token startToken;
  final PropertyNode property = PropertyNode(path: path);
  _PropertyState state = _PropertyState._START_;

  while (index < tokenList.length) {
    final Token token = tokenList[index];

    switch (state) {
      case _PropertyState._START_:
        if (token.type == TokenType.STRING) {
          final String? value = token.value; // Use token.value directly
          if (value == null) {
            return null;
          }
          final ValueNode key = ValueNode(value, token.value);
          key.loc = token.loc;
          key.parent = property; // Set parent reference
          startToken = token;
          property.key = key;
          property.path = '$path${value}'; // Update path
          state = _PropertyState.KEY;
          index++;
        } else {
          return null;
        }
        break;

      case _PropertyState.KEY:
        if (token.type == TokenType.COLON) {
          state = _PropertyState.COLON;
          index++;
        } else {
          final String src = settings.source ?? "";
          final String msg = unexpectedToken(
              substring(input, token.loc!.start.offset, token.loc!.end.offset),
              src,
              token.loc!.start.line,
              token.loc!.start.column);
          throw JSONASTException(
              msg, input, src, token.loc!.start.line, token.loc!.start.column);
        }
        break;

      case _PropertyState.COLON:
        final ValueIndex<dynamic> value =
            _parseValue(input, tokenList, index, settings, property.path);
        value.value.parent = property; // Set parent reference
        property.value = value.value as Node?;
        final String src = settings.source ?? "";
        property.loc = Location.create(
            startToken.loc!.start.line,
            startToken.loc!.start.column,
            startToken.loc!.start.offset,
            value.value.loc.end.line as int,
            value.value.loc.end.column as int,
            value.value.loc.end.offset as int,
            src);
        return ValueIndex<PropertyNode>(property, value.index);
    }
  }
  return null;
}

ValueIndex<ArrayNode>? parseArray(String input, List<Token> tokenList,
    int index, Settings settings, String path) {
  late Token startToken;
  final ArrayNode array = ArrayNode(path: path);
  _ArrayState state = _ArrayState._START_;
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
        break;

      case _ArrayState.OPEN_ARRAY:
        if (token.type == TokenType.RIGHT_BRACKET) {
          final String src = settings.source ?? "";
          array.loc = Location.create(
              startToken.loc!.start.line,
              startToken.loc!.start.column,
              startToken.loc!.start.offset,
              token.loc!.end.line,
              token.loc!.end.column,
              token.loc!.end.offset,
              src);
          return ValueIndex<ArrayNode>(array, index + 1);
        } else {
          final ValueIndex<dynamic> value = _parseValue(input, tokenList, index,
              settings, '$path[${array.children.length}]');
          value.value.parent = array; // Set parent reference
          index = value.index;
          array.children.add(value.value as Node);
          state = _ArrayState.VALUE;
        }
        break;

      case _ArrayState.VALUE:
        if (token.type == TokenType.RIGHT_BRACKET) {
          final String src = settings.source ?? "";
          array.loc = Location.create(
              startToken.loc!.start.line,
              startToken.loc!.start.column,
              startToken.loc!.start.offset,
              token.loc!.end.line,
              token.loc!.end.column,
              token.loc!.end.offset,
              src);
          return ValueIndex<ArrayNode>(array, index + 1);
        } else if (token.type == TokenType.COMMA) {
          state = _ArrayState.COMMA;
          index++;
        } else {
          final String src = settings.source ?? "";
          final String msg = unexpectedToken(
              substring(input, token.loc!.start.offset, token.loc!.end.offset),
              src,
              token.loc!.start.line,
              token.loc!.start.column);
          throw JSONASTException(
              msg, input, src, token.loc!.start.line, token.loc!.start.column);
        }
        break;

      case _ArrayState.COMMA:
        final ValueIndex<dynamic> value = _parseValue(input, tokenList, index,
            settings, '$path[${array.children.length}]');
        value.value.parent = array; // Set parent reference
        index = value.index;
        array.children.add(value.value as Node);
        state = _ArrayState.VALUE;
        break;
    }
  }
  throw errorEof(input, tokenList, settings);
}

ValueIndex<LiteralNode>? parseLiteral(String input, List<Token> tokenList,
    int index, Settings settings, String path) {
  final Token token = tokenList[index];
  Object? value;

  switch (token.type) {
    case TokenType.STRING:
      value = token.value; // Use token.value directly
      if (value == null) {
        return null;
      }
      break;
    case TokenType.NUMBER:
      if (token.value != null) {
        value = int.tryParse(token.value!) ?? null;
        if (value == null) {
          value = double.tryParse(token.value!) ?? null;
        }
      }
      break;
    case TokenType.TRUE:
      value = true;
      break;
    case TokenType.FALSE:
      value = false;
      break;
    case TokenType.NULL:
      value = null;
      break;
    default:
      return null;
  }

  final LiteralNode literal = LiteralNode(value, token.value, path: path);
  literal.loc = token.loc;
  return ValueIndex<LiteralNode>(literal, index + 1);
}

typedef ValueIndex<dynamic>? _parserFun(String input, List<Token> tokenList,
    int index, Settings settings, String path);

List<_parserFun> _parsersList = <_parserFun>[
  parseLiteral,
  parseObject,
  parseArray
];

ValueIndex<dynamic>? _findValueIndex(String input, List<Token> tokenList,
    int index, Settings settings, String path) {
  for (final _parserFun parser in _parsersList) {
    final ValueIndex<dynamic>? valueIndex =
        parser(input, tokenList, index, settings, path);
    if (valueIndex != null) {
      return valueIndex;
    }
  }
  return null;
}

ValueIndex<dynamic> _parseValue(String input, List<Token> tokenList, int index,
    Settings settings, String path) {
  final Token token = tokenList[index];
  final ValueIndex<dynamic>? value =
      _findValueIndex(input, tokenList, index, settings, path);

  if (value != null) {
    return value;
  } else {
    final String src = settings.source ?? "";
    final String msg = unexpectedToken(
        substring(input, token.loc!.start.offset, token.loc!.end.offset),
        src,
        token.loc!.start.line,
        token.loc!.start.column);
    throw JSONASTException(
        msg, input, src, token.loc!.start.line, token.loc!.start.column);
  }
}

Node parse(String input, Settings settings, String path) {
  final List<Token> tokenList = tokenize(input, settings);

  if (tokenList.isEmpty) {
    throw errorEof(input, tokenList, settings);
  }

  final ValueIndex<dynamic> value =
      _parseValue(input, tokenList, 0, settings, path);

  if (value.index == tokenList.length) {
    return value.value as Node;
  }

  final Token token = tokenList[value.index];
  final String src = settings.source ?? "";
  final String msg = unexpectedToken(
      substring(input, token.loc!.start.offset, token.loc!.end.offset),
      src,
      token.loc!.start.line,
      token.loc!.start.column);
  throw JSONASTException(
      msg, input, src, token.loc!.start.line, token.loc!.start.column);
}

JSONASTException errorEof(
    String input, List<dynamic> tokenList, Settings settings) {
  final Loc loc = tokenList.isNotEmpty
      ? tokenList.last.loc.end as Loc
      : Loc(line: 1, column: 1);
  final String src = settings.source ?? "";
  return JSONASTException(unexpectedEnd(), input, src, loc.line, loc.column);
}

typedef Token? _tokenParser(String input, int index, int line, int column);

List<_tokenParser> _parsers = <_tokenParser>[
  parseChar,
  parseKeyword,
  parseString,
  parseNumber
];

Token? _parseToken(String input, int index, int line, int column) {
  for (final _tokenParser parser in _parsers) {
    final Token? token = parser(input, index, line, column);
    if (token != null) {
      return token;
    }
  }
  return null;
}

class Position {
  final int index;
  final int line;
  final int column;

  Position(this.index, this.line, this.column);
}

Position? parseWhitespace(String input, int index, int line, int column) {
  final String char = input[index];

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
  final String char = input[index];
  if (punctuatorTokensMap.containsKey(char)) {
    final TokenType? tokenType = punctuatorTokensMap[char];
    return Token(tokenType, line, column + 1, index + 1, null);
  }

  return null;
}

Token? parseKeyword(String input, int index, int line, int column) {
  final Iterable<MapEntry<String, TokenType>> entries =
      keywordTokensMap.entries;
  for (final MapEntry<String, TokenType> entry in entries) {
    final int keyLen = entry.key.length;
    final int nextLen = index + keyLen;
    final int lastIndex = nextLen > input.length ? input.length : nextLen;
    if (safeSubstring(input, index, lastIndex) == entry.key) {
      return Token(entry.value, line, column + keyLen, lastIndex, entry.key);
    }
  }

  return null;
}

Token? parseString(String input, int index, int line, int column) {
  final int startIndex = index;
  _StringState state = _StringState._START_;
  final StringBuffer stringBuffer = StringBuffer();

  while (index < input.length) {
    final String char = input[index];

    switch (state) {
      case _StringState._START_:
        if (char == '"') {
          index++;
          state = _StringState.START_QUOTE_OR_CHAR;
        } else {
          return null;
        }
        break;

      case _StringState.START_QUOTE_OR_CHAR:
        if (char == '\\') {
          index++;
          state = _StringState.ESCAPE;
        } else if (char == '"') {
          index++;
          return Token(TokenType.STRING, line, column + (index - startIndex),
              index, stringBuffer.toString());
        } else {
          stringBuffer.write(char);
          index++;
        }
        break;

      case _StringState.ESCAPE:
        if (escapes.containsKey(char)) {
          index++;
          if (char == 'u') {
            for (int i = 0; i < 4; i++) {
              final String curChar = input[index];
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
        break;
    }
  }
  return null;
}

Token? parseNumber(String input, int index, int line, int column) {
  final int startIndex = index;
  int passedValueIndex = index;
  _NumberState state = _NumberState._START_;

  iterator:
  while (index < input.length) {
    final String char = input[index];

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
        break;

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
        break;

      case _NumberState.ZERO:
        if (char == '.') {
          state = _NumberState.POINT;
        } else if (isExp(char)) {
          state = _NumberState.EXP;
        } else {
          break iterator;
        }
        break;

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
        break;

      case _NumberState.POINT:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
          state = _NumberState.DIGIT_FRACTION;
        } else {
          break iterator;
        }
        break;

      case _NumberState.DIGIT_FRACTION:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else if (isExp(char)) {
          state = _NumberState.EXP;
        } else {
          break iterator;
        }
        break;

      case _NumberState.EXP:
        if (char == '+' || char == '-') {
          state = _NumberState.EXP_DIGIT_OR_SIGN;
        } else if (isDigit(char)) {
          passedValueIndex = index + 1;
          state = _NumberState.EXP_DIGIT_OR_SIGN;
        } else {
          break iterator;
        }
        break;

      case _NumberState.EXP_DIGIT_OR_SIGN:
        if (isDigit(char)) {
          passedValueIndex = index + 1;
        } else {
          break iterator;
        }
        break;
    }

    index++;
  }

  if (passedValueIndex > 0) {
    return Token(
        TokenType.NUMBER,
        line,
        column + (passedValueIndex - startIndex),
        passedValueIndex,
        safeSubstring(input, startIndex, passedValueIndex));
  }

  return null;
}

List<Token> tokenize(String input, Settings settings) {
  int line = 1;
  int column = 1;
  int index = 0;
  List<Token> tokens = <Token>[];

  while (index < input.length) {
    final Position? whitespace = parseWhitespace(input, index, line, column);
    if (whitespace != null) {
      index = whitespace.index;
      line = whitespace.line;
      column = whitespace.column;
      continue;
    }

    final Token? token = _parseToken(input, index, line, column);

    if (token != null) {
      final String src = settings.source ?? "";
      token.loc = Location.create(
          line, column, index, token.line, token.column, token.index, src);
      tokens.add(token);
      index = token.index;
      line = token.line;
      column = token.column;
    } else {
      final String src = settings.source ?? "";
      final String msg = unexpectedSymbol(
          substring(input, index, index + 1), src, line, column);
      throw JSONASTException(msg, input, src, line, column);
    }
  }
  return tokens;
}

// HELPERS

bool isDigit1to9(String char) {
  final int charCode = char.codeUnitAt(0);
  return charCode >= '1'.codeUnitAt(0) && charCode <= '9'.codeUnitAt(0);
}

bool isDigit(String char) {
  final int charCode = char.codeUnitAt(0);
  return charCode >= '0'.codeUnitAt(0) && charCode <= '9'.codeUnitAt(0);
}

bool isHex(String char) {
  final int charCode = char.codeUnitAt(0);
  return (isDigit(char) ||
      (charCode >= 'a'.codeUnitAt(0) && charCode <= 'f'.codeUnitAt(0)) ||
      (charCode >= 'A'.codeUnitAt(0) && charCode <= 'F'.codeUnitAt(0)));
}

bool isExp(String char) {
  return char == 'e' || char == 'E';
}

final Map<String, int> escapes = <String, int>{
  '"': 0, // Quotation mask
  '\\': 1, // Reverse solidus
  '/': 2, // Solidus
  'b': 3, // Backspace
  'f': 4, // Form feed
  'n': 5, // New line
  'r': 6, // Carriage return
  't': 7, // Horizontal tab
  'u': 8 // 4 hexadecimal digits
};
