import 'package:fhir_r4/fhir_r4.dart';

import '../firely.dart';

class ScopedNodeExtensions {
  static ScopedNode asScopedNode(ITypedElement node) =>
      TypedElementToIScopedNodeAdapter(node.toScopedNode());

  static ScopedNode toScopedNode(Map<String, dynamic> node,
      [ModelInspector? inspector]) {
    inspector ??= ModelInspector.forAssembly(node.runtimeType.toString());
    return ScopedNodeOnDictionary(inspector, node.runtimeType.toString(), node);
  }

  static Quantity parseQuantity(ScopedNode instance) {
    return instance.parseQuantityInternal();
  }

  static T parsePrimitive<T extends PrimitiveType>(ScopedNode instance) {
    return instance.parsePrimitiveInternal<T, ScopedNode>();
  }

  static Coding parseCoding(ScopedNode instance) {
    return instance.parseCodingInternal();
  }

  static ResourceReference parseResourceReference(ScopedNode instance) {
    return instance.parseResourceReferenceInternal();
  }

  static CodeableConcept parseCodeableConcept(ScopedNode instance) {
    return instance.parseCodeableConceptInternal();
  }

  static Element? parseBindable(ScopedNode instance) {
    return instance.parseBindableInternal();
  }
}

class ScopedNodeOnDictionary implements ScopedNode {
  final Map<String, dynamic> _wrapped;
  final ModelInspector _inspector;
  final ScopedNode? parent;

  ScopedNodeOnDictionary(this._inspector, this.name, this._wrapped,
      [this.parent]) {
    var myClassMapping =
        _inspector.findOrImportClassMapping(_wrapped.runtimeType);
    instanceType = (myClassMapping as IStructureDefinitionSummary?)?.typeName;
  }

  @override
  final String name;

  @override
  String? instanceType;

  @override
  dynamic get value =>
      _wrapped['value'] != null && _isNetPrimitiveType(_wrapped['value'])
          ? _wrapped['value']
          : null;

  @override
  Iterable<ScopedNode> children([String? name]) {
    Iterable<MapEntry<String, dynamic>> children;

    if (name != null) {
      children = _wrapped.entries
          .where((entry) => entry.key == name && entry.value != null);
    } else {
      children = _wrapped.entries;
    }

    return children.expand((child) {
      if (child.value is List) {
        return (child.value as List)
            .where((childValue) => childValue is Map<String, dynamic>)
            .map((childValue) => ScopedNodeOnDictionary(
                _inspector, child.key, childValue, this));
      } else if (child.value is Map<String, dynamic>) {
        return [
          ScopedNodeOnDictionary(_inspector, child.key, child.value, this)
        ];
      } else if (child.key != 'value' && _isNetPrimitiveType(child.value)) {
        return [
          ConstantElement(
              child.key, child.value.runtimeType.toString(), child.value, this)
        ];
      }
      return [];
    });
  }

  static bool _isNetPrimitiveType(dynamic a) =>
      a is String ||
      a is bool ||
      a is double ||
      a is DateTime ||
      a is int ||
      a is List<int>;

  @override
  String toString() =>
      'ScopedNodeOnDictionary(name: $name, instanceType: $instanceType, value: $value)';
}

class ConstantElement implements ScopedNode {
  @override
  final String name;
  @override
  final String instanceType;
  @override
  final dynamic value;
  @override
  final ScopedNode parent;

  ConstantElement(this.name, this.instanceType, this.value, this.parent);

  @override
  Iterable<ScopedNode> children([String? name]) => [];

  @override
  String toString() =>
      'ConstantElement(name: $name, instanceType: $instanceType, value: $value)';
}
