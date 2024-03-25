import 'package:fhir/r5.dart';

class ChildIterator {
  // Assuming `instanceValidator` provides similar functionalities in Dart
  final InstanceValidator instanceValidator;
  String basePath;
  Element parent;
  int cursor = -1;
  int lastCount = 0;

  ChildIterator(this.instanceValidator, this.basePath, this.parent);

  String get basePath => basePath;
  ChildIterator setBasePath(String basePath) {
    this.basePath = basePath;
    return this;
  }

  Element get parent => parent;
  ChildIterator setParent(Element parent) {
    this.parent = parent;
    return this;
  }

  int get cursor => cursor;
  ChildIterator setCursor(int cursor) {
    this.cursor = cursor;
    return this;
  }

  int get lastCount => lastCount;
  ChildIterator setLastCount(int lastCount) {
    this.lastCount = lastCount;
    return this;
  }

  Element element() {
    return parent.children[cursor];
  }

  String name() {
    return element().name;
  }

  int count() {
    var nb = cursor == 0 ? "--" : parent.children[cursor - 1].name;
    var na = cursor >= parent.children.length - 1
        ? "--"
        : parent.children[cursor + 1].name;
    if (name() == nb || name() == na) {
      return lastCount;
    } else if (element().isBaseList) {
      return 0;
    } else {
      return -1;
    }
  }

  bool next() {
    if (cursor == -1) {
      cursor++;
      lastCount = 0;
    } else {
      String lastName = name();
      cursor++;
      if (cursor < parent.children.length && name() == lastName) {
        lastCount++;
      } else {
        lastCount = 0;
      }
    }
    return cursor < parent.children.length;
  }

  String path() {
    var i = count();
    var sfx = "";
    var n = name();
    var fn = "";
    if (element().property.isChoice) {
      if (element().property.name.endsWith("[x]")) {
        var en = element()
            .property
            .name
            .substring(0, element().property.name.length - 3);
        var t = n.substring(en.length);
        if (instanceValidator.isPrimitiveType(t.toLowerCase())) {
          t = t.toLowerCase();
        }
        n = en;
        fn = ".ofType($t)";
      }
    }
    if (i > -1 || (element().special == null && element().isList)) {
      sfx = "[$lastCount]";
    }
    return "$basePath.$n$sfx$fn";
  }
}
