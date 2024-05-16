import 'json_ast.dart';

enum _ObjectState { _START_, OPEN_OBJECT, PROPERTY, COMMA }

enum _PropertyState { _START_, KEY, COLON }

enum _ArrayState { _START_, OPEN_ARRAY, VALUE, COMMA }

JSONASTException errorEof(
    String input, List<dynamic> tokenList, Settings settings) {
  final Loc loc = tokenList.length > 0
      ? tokenList[tokenList.length - 1].loc.end
      : Loc(line: 1, column: 1);

  final src = settings.source ?? "";
  return JSONASTException(unexpectedEnd(), input, src, loc.line, loc.column);
}

class Node {
  final String type;
  Location? loc;

  Node(this.type, {this.loc});

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

  List<LiteralNode> extractProfileNodes() {
    List<LiteralNode> profileNodes = [];

    void traverse(Node node, String path) {
      if (node is ObjectNode) {
        for (var property in node.children) {
          final newPath = path.isEmpty
              ? property.key?.value
              : '$path.${property.key?.value}';
          if (newPath == 'meta.profile' && property.value is ArrayNode) {
            for (var item in (property.value as ArrayNode).children) {
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
}

class ValueNode extends Node {
  final String value;
  final String? raw;

  ValueNode(this.value, this.raw) : super('Identifier');

  bool operator ==(Object other) =>
      other is ValueNode &&
      type == other.type &&
      loc == other.loc &&
      value == other.value &&
      raw == other.raw;
}

class ObjectNode extends Node {
  final List<PropertyNode> children = <PropertyNode>[];

  ObjectNode() : super('Object');

  bool operator ==(Object other) =>
      other is ObjectNode &&
      type == other.type &&
      loc == other.loc &&
      _compareDynamicList(children, other.children);
}

bool _compareDynamicList(List? l, List? other) {
  if (l != null && other != null) {
    final len = l.length;
    if (len != other.length) {
      return false;
    }
    for (int i = 0; i < len; i++) {
      final el = l.elementAt(i);
      final otherEl = other.elementAt(i);
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

  ArrayNode() : super('Array');

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

  PropertyNode() : super('Property');

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

  LiteralNode(this.value, this.raw) : super('Literal');

  bool operator ==(Object other) =>
      other is LiteralNode &&
      type == other.type &&
      loc == other.loc &&
      value == other.value &&
      raw == other.raw;
}

class ValueIndex<T> {
  final T value;
  final int index;

  ValueIndex(this.value, this.index);

  bool operator ==(Object other) =>
      other is ValueIndex<T> && value == other.value && index == other.index;
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

bool isHex(char) {
  final charCode = char.codeUnitAt(0);
  return (isDigit(char) ||
      (charCode >= 'a'.codeUnitAt(0) && charCode <= 'f'.codeUnitAt(0)) ||
      (charCode >= 'A'.codeUnitAt(0) && charCode <= 'F'.codeUnitAt(0)));
}

bool isExp(char) {
  return char == 'e' || char == 'E';
}

ValueIndex<ObjectNode>? parseObject(
    String input, List<Token> tokenList, int index, Settings settings) {
  // object: LEFT_BRACE (property (COMMA property)*)? RIGHT_BRACE
  late Token startToken;
  final object = ObjectNode();
  var state = _ObjectState._START_;

  while (index < tokenList.length) {
    final token = tokenList[index];

    switch (state) {
      case _ObjectState._START_:
        {
          if (token.type == TokenType.LEFT_BRACE) {
            startToken = token;
            state = _ObjectState.OPEN_OBJECT;
            index++;
          } else {
            return null;
          }
          break;
        }

      case _ObjectState.OPEN_OBJECT:
        {
          if (token.type == TokenType.RIGHT_BRACE) {
            if (settings.loc) {
              final src = settings.source ?? "";
              object.loc = Location.create(
                  startToken.loc!.start.line,
                  startToken.loc!.start.column,
                  startToken.loc!.start.offset,
                  token.loc!.end.line,
                  token.loc!.end.column,
                  token.loc!.end.offset,
                  src);
            }
            return ValueIndex(object, index + 1);
          } else {
            final property = parseProperty(input, tokenList, index, settings);
            if (property != null) {
              object.children.add(property.value);
              state = _ObjectState.PROPERTY;
              index = property.index;
            } else {
              final src = settings.source ?? "";
              final msg = unexpectedToken(
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
        }

      case _ObjectState.PROPERTY:
        {
          if (token.type == TokenType.RIGHT_BRACE) {
            final src = settings.source ?? "";
            object.loc = Location.create(
                startToken.loc!.start.line,
                startToken.loc!.start.column,
                startToken.loc!.start.offset,
                token.loc!.end.line,
                token.loc!.end.column,
                token.loc!.end.offset,
                src);
            return ValueIndex(object, index + 1);
          } else if (token.type == TokenType.COMMA) {
            state = _ObjectState.COMMA;
            index++;
          } else {
            final src = settings.source ?? "";
            final msg = unexpectedToken(
                substring(
                    input, token.loc!.start.offset, token.loc!.end.offset),
                src,
                token.loc!.start.line,
                token.loc!.start.column);
            throw JSONASTException(msg, input, src, token.loc!.start.line,
                token.loc!.start.column);
          }
          break;
        }

      case _ObjectState.COMMA:
        {
          final property = parseProperty(input, tokenList, index, settings);
          if (property != null) {
            index = property.index;
            object.children.add(property.value);
            state = _ObjectState.PROPERTY;
          } else {
            final src = settings.source ?? "";
            final msg = unexpectedToken(
                substring(
                    input, token.loc!.start.offset, token.loc!.end.offset),
                src,
                token.loc!.start.line,
                token.loc!.start.column);
            throw JSONASTException(msg, input, src, token.loc!.start.line,
                token.loc!.start.column);
          }
          break;
        }
    }
  }
  throw errorEof(input, tokenList, settings);
}

ValueIndex<PropertyNode>? parseProperty(
    String input, List<Token> tokenList, int index, Settings settings) {
  // property: STRING COLON value
  late Token startToken;
  final property = PropertyNode();
  var state = _PropertyState._START_;

  while (index < tokenList.length) {
    final token = tokenList[index];

    switch (state) {
      case _PropertyState._START_:
        {
          if (token.type == TokenType.STRING) {
            final value = token.value; // Use token.value directly

            if (value == null) {
              return null;
            }
            final key = ValueNode(value, token.value);
            key.loc = token.loc;
            startToken = token;
            property.key = key;
            state = _PropertyState.KEY;
            index++;
          } else {
            return null;
          }
          break;
        }

      case _PropertyState.KEY:
        {
          if (token.type == TokenType.COLON) {
            state = _PropertyState.COLON;
            index++;
          } else {
            final src = settings.source ?? "";
            final msg = unexpectedToken(
                substring(
                    input, token.loc!.start.offset, token.loc!.end.offset),
                src,
                token.loc!.start.line,
                token.loc!.start.column);
            throw JSONASTException(msg, input, src, token.loc!.start.line,
                token.loc!.start.column);
          }
          break;
        }

      case _PropertyState.COLON:
        {
          final value = _parseValue(input, tokenList, index, settings);
          property.value = value.value;
          final src = settings.source ?? "";
          property.loc = Location.create(
              startToken.loc!.start.line,
              startToken.loc!.start.column,
              startToken.loc!.start.offset,
              value.value.loc.end.line,
              value.value.loc.end.column,
              value.value.loc.end.offset,
              src);
          return ValueIndex(property, value.index);
        }
    }
  }
  return null;
}

ValueIndex<ArrayNode>? parseArray(
    String input, List<Token> tokenList, int index, Settings settings) {
  // array: LEFT_BRACKET (value (COMMA value)*)? RIGHT_BRACKET
  late Token startToken;
  final array = ArrayNode();
  var state = _ArrayState._START_;
  Token token;
  while (index < tokenList.length) {
    token = tokenList[index];
    switch (state) {
      case _ArrayState._START_:
        {
          if (token.type == TokenType.LEFT_BRACKET) {
            startToken = token;
            state = _ArrayState.OPEN_ARRAY;
            index++;
          } else {
            return null;
          }
          break;
        }

      case _ArrayState.OPEN_ARRAY:
        {
          if (token.type == TokenType.RIGHT_BRACKET) {
            final src = settings.source ?? "";
            array.loc = Location.create(
                startToken.loc!.start.line,
                startToken.loc!.start.column,
                startToken.loc!.start.offset,
                token.loc!.end.line,
                token.loc!.end.column,
                token.loc!.end.offset,
                src);
            return ValueIndex(array, index + 1);
          } else {
            final value = _parseValue(input, tokenList, index, settings);
            index = value.index;
            array.children.add(value.value);
            state = _ArrayState.VALUE;
          }
          break;
        }

      case _ArrayState.VALUE:
        {
          if (token.type == TokenType.RIGHT_BRACKET) {
            final src = settings.source ?? "";
            array.loc = Location.create(
                startToken.loc!.start.line,
                startToken.loc!.start.column,
                startToken.loc!.start.offset,
                token.loc!.end.line,
                token.loc!.end.column,
                token.loc!.end.offset,
                src);
            return ValueIndex(array, index + 1);
          } else if (token.type == TokenType.COMMA) {
            state = _ArrayState.COMMA;
            index++;
          } else {
            final src = settings.source ?? "";
            final msg = unexpectedToken(
                substring(
                    input, token.loc!.start.offset, token.loc!.end.offset),
                src,
                token.loc!.start.line,
                token.loc!.start.column);
            throw JSONASTException(msg, input, src, token.loc!.start.line,
                token.loc!.start.column);
          }
          break;
        }

      case _ArrayState.COMMA:
        {
          final value = _parseValue(input, tokenList, index, settings);
          index = value.index;
          array.children.add(value.value);
          state = _ArrayState.VALUE;
          break;
        }
    }
  }
  throw errorEof(input, tokenList, settings);
}

ValueIndex<LiteralNode>? parseLiteral(
    String input, List<Token> tokenList, int index, Settings settings) {
  // literal: STRING | NUMBER | TRUE | FALSE | NULL
  final token = tokenList[index];
  var value;

  switch (token.type) {
    case TokenType.STRING:
      {
        value = token.value; // Use token.value directly
        if (value == null) {
          return null;
        }
        break;
      }
    case TokenType.NUMBER:
      {
        if (token.value != null) {
          value = int.tryParse(token.value!) ?? null;
          if (value == null) {
            value = double.tryParse(token.value!) ?? null;
          }
        }
        break;
      }
    case TokenType.TRUE:
      {
        value = true;
        break;
      }
    case TokenType.FALSE:
      {
        value = false;
        break;
      }
    case TokenType.NULL:
      {
        value = null;
        break;
      }
    default:
      {
        return null;
      }
  }

  final literal = LiteralNode(value, token.value);
  literal.loc = token.loc;
  return ValueIndex(literal, index + 1);
}

typedef ValueIndex? _parserFun(
    String input, List<Token> tokenList, int index, Settings settings);

List<_parserFun> _parsersList = [parseLiteral, parseObject, parseArray];

ValueIndex? _findValueIndex(
    String input, List<Token> tokenList, int index, Settings settings) {
  for (int i = 0; i < _parsersList.length; i++) {
    final parser = _parsersList.elementAt(i);
    final valueIndex = parser(input, tokenList, index, settings);
    if (valueIndex != null) {
      return valueIndex;
    }
  }
  return null;
}

ValueIndex _parseValue(
    String input, List<Token> tokenList, int index, Settings settings) {
  // value: literal | object | array
  final token = tokenList[index];

  final value = _findValueIndex(input, tokenList, index, settings);

  if (value != null) {
    return value;
  } else {
    final src = settings.source ?? "";
    final msg = unexpectedToken(
        substring(input, token.loc!.start.offset, token.loc!.end.offset),
        src,
        token.loc!.start.line,
        token.loc!.start.column);
    throw JSONASTException(
        msg, input, src, token.loc!.start.line, token.loc!.start.column);
  }
}

Node parse(String input, Settings settings) {
  final tokenList = tokenize(input, settings);

  if (tokenList.isEmpty) {
    throw errorEof(input, tokenList, settings);
  }

  final value = _parseValue(input, tokenList, 0, settings);

  if (value.index == tokenList.length) {
    return value.value;
  }

  final token = tokenList[value.index];

  final src = settings.source ?? "";
  final msg = unexpectedToken(
      substring(input, token.loc!.start.offset, token.loc!.end.offset),
      src,
      token.loc!.start.line,
      token.loc!.start.column);
  throw JSONASTException(
      msg, input, src, token.loc!.start.line, token.loc!.start.column);
}
