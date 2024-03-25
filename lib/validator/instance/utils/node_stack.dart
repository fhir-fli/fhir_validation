import 'dart:collection';

import 'package:fhir/r5.dart';

class NodeStack {
  late IWorkerContext context;
  late ElementDefinition? definition;
  late Element element;
  late ElementDefinition? extension;
  late String literalPath; // xpath format
  late Set<String> logicalPaths; // dotted format, various entry points
  late NodeStack? parent;
  late ElementDefinition? type;
  late String workingLang;
  late Map<String, Element> ids;
  bool resetPoint = false;
  bool contained = false;

  NodeStack(this.context);

  NodeStack.withElement(this.context, String? initialPath, Element element,
      String validationLanguage) {
    ids = HashMap();
    this.element = element;
    literalPath = (initialPath == null ? '' : '$initialPath.') + element.path;
    workingLang = validationLanguage;
    if (element.name != element.fhirType()) {
      logicalPaths = {element.fhirType()};
    }
  }

  NodeStack.withRefPath(this.context, Element element, String refPath,
      String validationLanguage) {
    ids = HashMap();
    this.element = element;
    literalPath = '$refPath->${element.name}';
    workingLang = validationLanguage;
  }

  String addToLiteralPath(List<String> path) {
    var b = StringBuffer();
    b.write(literalPath);
    for (var p in path) {
      if (p.startsWith(':')) {
        b.write('[');
        b.write(p.substring(1));
        b.write(']');
      } else {
        b.write('.');
        b.write(p);
      }
    }
    return b.toString();
  }

  ElementDefinition? getDefinition() {
    return definition;
  }

  Element getElement() {
    return element;
  }

  String getLiteralPath() {
    return literalPath.isEmpty ? '' : literalPath;
  }

  Set<String> getLogicalPaths() {
    return logicalPaths.isEmpty ? HashSet() : logicalPaths;
  }

  ElementDefinition? getType() {
    return type;
  }

  NodeStack pushTarget(Element element, int count, ElementDefinition definition,
      ElementDefinition type) {
    return pushInternal(element, count, definition, type, '->');
  }

  NodeStack push(Element element, int count, ElementDefinition definition,
      ElementDefinition type) {
    return pushInternal(element, count, definition, type, '.');
  }

  NodeStack pushInternal(Element element, int count,
      ElementDefinition definition, ElementDefinition type, String sep) {
    definition = element.property.definition!;
    var res = NodeStack(context);
    res.ids = ids;
    res.parent = this;
    res.workingLang = workingLang;
    res.element = element;
    res.definition = definition;
    res.contained = contained;
    res.literalPath = '$literalPath$sep${element.name}';
    if (count > -1) {
      res.literalPath = '${res.literalPath}[$count]';
    } else if (element.special == null && element.property.isList) {
      res.literalPath = '${res.literalPath}[0]';
    } else if (element.property.isChoice) {
      var n = res.literalPath.substring(res.literalPath.lastIndexOf('.') + 1);
      var en = element.property.name;
      if (en.endsWith('[x]')) {
        en = en.substring(0, en.length - 3);
        var t = n.substring(en.length);
        if (context.isPrimitiveType(Utilities.uncapitalize(t)!)) {
          t = Utilities.uncapitalize(t)!;
        }
        res.literalPath =
            '${res.literalPath.substring(0, res.literalPath.lastIndexOf('.'))}.$en.ofType($t)';
      } else {
        res.literalPath =
            '${res.literalPath.substring(0, res.literalPath.lastIndexOf('.'))}.$en';
      }
    }
    res.logicalPaths = HashSet();
    res.type = type;
    var tn = res.type!.path;
    var t = tail(definition.path);
    if ('Resource' == tn) {
      tn = element.fhirType();
    }
    for (var lp in getLogicalPaths()) {
      if (isRealPath(lp, t)) {
        res.logicalPaths.add('$lp.$t');
        if (t.endsWith('[x]')) {
          res.logicalPaths
              .add('$lp.${t.substring(0, t.length - 3)}.ofType(${type.path})');
          res.logicalPaths
              .add('$lp.${t.substring(0, t.length - 3)}${type.path}');
        }
      }
    }
    res.logicalPaths.add(tn);
    return res;
  }

  bool isRealPath(String lp, String t) {
    if (Utilities.existsInList(lp, ['Element'])) {
      return Utilities.existsInList(t, ['id', 'extension']);
    }
    if (Utilities.existsInList(lp, ['BackboneElement', 'BackboneType'])) {
      return Utilities.existsInList(t, ['modifierExtension']);
    }
    if (Utilities.existsInList(lp, ['Resource'])) {
      return Utilities.existsInList(
          t, ['id', 'meta', 'implicitRules', 'language']);
    }
    if (Utilities.existsInList(lp, ['DomainResource'])) {
      return Utilities.existsInList(
          t, ['text', 'contained', 'extension', 'modifierExtension']);
    }
    return true;
  }

  void setType(ElementDefinition type) {
    this.type = type;
  }

  NodeStack resetIds() {
    ids = HashMap();
    resetPoint = true;
    return this;
  }

  Map<String, Element> getIds() {
    return ids;
  }

  String tail(String path) {
    return path.substring(path.lastIndexOf('.') + 1);
  }

  String getWorkingLang() {
    return workingLang;
  }

  void setWorkingLang(String workingLang) {
    this.workingLang = workingLang;
  }

  NodeStack? getParent() {
    return parent;
  }

  void pathComment(String comment) {
    literalPath = '$literalPath/*$comment*/';
  }

  bool isResetPoint() {
    return resetPoint;
  }

  @override
  String toString() {
    return literalPath;
  }

  int depth() {
    if (parent == null) {
      return 0;
    } else {
      return parent!.depth() + 1;
    }
  }

  bool isContained() {
    return contained;
  }

  void setContained(bool contained) {
    this.contained = contained;
  }

  int line() {
    return element.line();
  }

  int col() {
    return element.col();
  }
}
