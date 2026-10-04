import 'package:fhir_node/fhir_node.dart';

/// An ElementDefinition read by element name: the parts the validator uses,
/// as plain Dart values, whatever version the definition comes from.
class ElementNode {
  /// Wraps an ElementDefinition [node].
  const ElementNode(this.node);

  /// The ElementDefinition itself.
  final FhirNode node;

  /// `ElementDefinition.path`, or the empty string.
  String get path => node.getChildByName('path')?.primitiveValue ?? '';

  /// `ElementDefinition.type`, each with its code and profiles.
  List<ElementType> get types => [
    for (final t in node.getChildrenByName('type')) ElementType(t),
  ];

  /// `ElementDefinition.min`, when given as an integer.
  int? get min =>
      int.tryParse(node.getChildByName('min')?.primitiveValue ?? '');

  /// `ElementDefinition.max` as written (`1`, `*`).
  String? get max => node.getChildByName('max')?.primitiveValue;

  /// `ElementDefinition.binding`, when present.
  ElementBinding? get binding {
    final b = node.getChildByName('binding');
    return b == null ? null : ElementBinding(b);
  }

  /// `ElementDefinition.pattern[x]` when it is a string: the regular
  /// expression a value must match.
  String? get patternString {
    final p = node.getChildByName('pattern');
    return p != null && p.isPrimitive && p.hasType(['string'])
        ? p.primitiveValue
        : null;
  }

  /// `ElementDefinition.minValue[x]` as text.
  String? get minValue => node.getChildByName('minValue')?.primitiveValue;

  /// `ElementDefinition.maxValue[x]` as text.
  String? get maxValue => node.getChildByName('maxValue')?.primitiveValue;

  /// `ElementDefinition.constraint`, each with its expression and text.
  List<ElementConstraint> get constraints => [
    for (final c in node.getChildrenByName('constraint')) ElementConstraint(c),
  ];

  /// The `url` of each extension on the ElementDefinition.
  List<String> get extensionUrls => [
    for (final e in node.getChildrenByName('extension'))
      if (e.getChildByName('url')?.primitiveValue case final String url) url,
  ];

  /// `ElementDefinition.contentReference`.
  String? get contentReference =>
      node.getChildByName('contentReference')?.primitiveValue;
}

/// One `ElementDefinition.type`.
class ElementType {
  /// Wraps an ElementDefinition.type [node].
  const ElementType(this.node);

  /// The type node itself.
  final FhirNode node;

  /// `type.code`, or the empty string.
  String get code => node.getChildByName('code')?.primitiveValue ?? '';

  /// `type.profile`, the canonical URLs.
  List<String> get profiles => [
    for (final p in node.getChildrenByName('profile'))
      if (p.primitiveValue case final String url) url,
  ];
}

/// An `ElementDefinition.binding`.
class ElementBinding {
  /// Wraps a binding [node].
  const ElementBinding(this.node);

  /// The binding node itself.
  final FhirNode node;

  /// `binding.strength` (`required`, `extensible`, `preferred`, `example`).
  String? get strength => node.getChildByName('strength')?.primitiveValue;

  /// `binding.valueSet`, the canonical URL.
  String? get valueSet => node.getChildByName('valueSet')?.primitiveValue;
}

/// An `ElementDefinition.constraint`.
class ElementConstraint {
  /// Wraps a constraint [node].
  const ElementConstraint(this.node);

  /// The constraint node itself.
  final FhirNode node;

  /// `constraint.expression`, the FHIRPath.
  String? get expression => node.getChildByName('expression')?.primitiveValue;

  /// `constraint.human`, the text.
  String? get human => node.getChildByName('human')?.primitiveValue;
}
