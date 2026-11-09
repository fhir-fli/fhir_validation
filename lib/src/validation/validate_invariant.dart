import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:fhir_validation/fhir_validation.dart';

/// Validates the invariants of a [Node] against the corresponding
/// [ElementNode].
Future<ValidationResults> validateInvariants({
  required ValidationModel<FhirNode> model,
  required Node node,
  required ElementNode element,
  required ValidationResults results,
  String? url,
  required ResourceCache resourceCache,
}) async {
  final constraints = element.constraints;
  if (constraints.isEmpty) return results;

  if (element.types.isEmpty || element.path.isEmpty) {
    results.addResult(
      node,
      'Element type or path is missing for node: ${node.path}',
      Severity.error,
    );
    return results;
  }

  final value = _valueOf(node, element);
  // A repeating element is constrained item by item: a constraint's
  // context is one instance of the element (ElementDefinition.constraint;
  // HL7's InstanceValidator checks the invariants of each element it
  // walks).
  final items =
      value is List
          ? [
            for (var i = 0; i < value.length; i++)
              (_itemNode(node, i) ?? node, value[i]),
          ]
          : [(node, value)];

  for (final (itemNode, itemValue) in items) {
    final context = _contextFor(model, itemNode, element, itemValue, results);
    // A value that could not be built has had its problem reported; its
    // constraints cannot be evaluated, and saying so for each one only
    // repeats that problem.
    if (context == null) continue;
    for (final constraint in constraints) {
      final expression = constraint.expression;
      if (expression != null) {
        if (!_constraintsIDontWantToDo(itemNode, expression)) {
          if (!(await _evaluateConstraint(
            model,
            resourceCache,
            context,
            expression,
          ))) {
            results.addResult(
              itemNode,
              withUrlIfExists(_failed(constraint), url),
              _severity(constraint),
            );
          }
        }
      } else {
        results.addResult(
          itemNode,
          withUrlIfExists('Invariant violation: ${constraint.human}', url),
          Severity.information,
        );
      }
    }
  }
  return results;
}

/// A failed constraint's message: its text, and its key as HL7 names it
/// (`Constraint failed: <key>: '<human>'`, Messages.properties INV_FAILED).
String _failed(ElementConstraint constraint) {
  final key = constraint.key;
  return 'Invariant violation: ${constraint.human}'
      '${key == null ? '' : ' ($key)'}';
}

/// The level a failed constraint is reported at, as HL7's
/// InstanceValidator.checkInvariant (hapifhir/org.hl7.fhir.core master
/// f6d3c306): a best-practice constraint at the bpWarnings setting, whose
/// default (ValidatorSettings) is a warning; otherwise `error` is an error
/// and `warning` a warning. A constraint with neither keeps the old level.
Severity _severity(ElementConstraint constraint) {
  if (constraint.isBestPractice) return Severity.warning;
  return switch (constraint.severity) {
    'error' => Severity.error,
    'warning' => Severity.warning,
    _ => Severity.information,
  };
}

/// The JSON value [node] holds for [element]: a property's value, or the
/// node itself.
Object? _valueOf(Node node, ElementNode element) {
  final dynamic raw = _nodeToMap(node);
  final key = element.path.split('.').last;
  return raw is Map<String, dynamic> ? raw[key] ?? raw : raw;
}

/// The node of item [index] of a repeating [node], when it has one.
Node? _itemNode(Node node, int index) {
  final list = node is PropertyNode ? node.value : node;
  return list is ArrayNode && index < list.children.length
      ? list.children[index]
      : null;
}

/// [extractedContext] as a FHIRPath context of [element]'s type, or null
/// after reporting why it cannot be one.
FhirNode? _contextFor(
  ValidationModel<FhirNode> model,
  Node node,
  ElementNode element,
  Object? extractedContext,
  ValidationResults results,
) {
  var reported = false;
  for (final type in element.types) {
    try {
      final context = model.fromType(extractedContext, type.code);
      if (context != null) {
        return context;
      }
    } on Object catch (e) {
      // A complex value the model refuses because one of its parts is
      // invalid: that part was validated first and its problem reported.
      if (_aPartWasReported(node, results)) return null;
      // Whatever the model throws for a value it cannot build.
      results.addResult(
        node,
        'Type conversion failed: Unable to convert '
        '${extractedContext.runtimeType} '
        'to FHIR type "${type.code}". Error: $e',
        Severity.error,
      );
      reported = true;
    }
  }

  // A primitive the model will not build (a narrative it refuses, a date it
  // cannot parse) is still its JSON value and its type, so its constraints
  // are evaluated over the value as written, as HL7's validator evaluates
  // them over its own element tree whatever a model makes of the value
  // (txt-1 on a narrative with a javascript: link). Whether the value
  // itself is valid is the primitive checks' question.
  for (final type in element.types) {
    if (_isPrimitiveType(type.code) && _isJsonScalar(extractedContext)) {
      return JsonNode(extractedContext, type.code);
    }
  }

  if (!reported) {
    results.addResult(
      node,
      withUrlIfExists(
        'Unable to determine context type for node: ${node.path}',
        element.contentReference,
      ),
      Severity.warning,
    );
  }
  return null;
}

/// FHIR names its primitive types in lower case (`string`, `xhtml`) and
/// its complex types and resources with a capital (`Narrative`).
bool _isPrimitiveType(String code) =>
    code.isNotEmpty &&
    code[0] == code[0].toLowerCase() &&
    code[0] != code[0].toUpperCase();

bool _isJsonScalar(Object? value) =>
    value is String || value is num || value is bool;

/// Whether a result is already recorded inside [node].
bool _aPartWasReported(Node node, ValidationResults results) {
  final prefix = '${node.path}.';
  return results.results.any((r) => r.path.startsWith(prefix));
}

Future<bool> _evaluateConstraint(
  ValidationModel<FhirNode> model,
  ResourceCache resourceCache,
  FhirNode context,
  String expression,
) async {
  // Evaluate the FHIRPath expression using the context, over the version's
  // binding and the same cache the rest of the validation reads.
  final engine = await FHIRPathEngine.create(
    FhirWorkerContext(binding: model.pathBinding, resourceCache: resourceCache),
  );
  final result = await engine.evaluate(context, engine.parse(expression));

  // Check if the result satisfies the constraint: one boolean true.
  return result.length == 1 &&
      result.first.isPrimitive &&
      result.first.primitiveValue == 'true';
}

/// Converts a [Node] to a [Map] for use as a FHIRPath context.
dynamic _nodeToMap(Node node) {
  if (node is LiteralNode) {
    return node.value;
  } else if (node is ObjectNode) {
    return _objectNodeToMap(node);
  } else if (node is ArrayNode) {
    return _arrayNodeToList(node);
  } else if (node is PropertyNode) {
    if (node.key?.value == null) {
      throw Exception('PropertyNode key is null');
    }
    return <String, dynamic>{node.key!.value: _nodeToMap(node.value!)};
  }
  throw Exception('Unknown node type: ${node.runtimeType}');
}

Map<String, dynamic> _objectNodeToMap(ObjectNode node) {
  final map = <String, dynamic>{};
  for (final property in node.children) {
    if (property.key?.value == null) {
      throw Exception('PropertyNode key is null');
    }
    map[property.key!.value] = _nodeToMap(property.value!);
  }
  return map;
}

List<dynamic> _arrayNodeToList(ArrayNode node) {
  return node.children.map(_nodeToMap).toList();
}

bool _constraintsIDontWantToDo(Node node, String expression) {
  const skippedConstraints = {
    'Observation.subject': [
      // ignore: no_adjacent_strings_in_list
      "reference.startsWith('#').not() or "
          "(reference.substring(1).trace('url') in "
          "%rootResource.contained.id.trace('ids')) or "
          "(reference='#' and %rootResource!=%resource)",
    ],
    'extension.exists() != value.exists()': <String>[],
  };

  for (final entry in skippedConstraints.entries) {
    if (node.path.startsWith(entry.key) && entry.value.contains(expression)) {
      return true;
    }
  }
  return false;
}
