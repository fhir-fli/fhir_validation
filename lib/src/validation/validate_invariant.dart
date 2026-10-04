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
  if (constraints.isNotEmpty) {
    final context = _getContext(model, node, element, results);
    for (final constraint in constraints) {
      final expression = constraint.expression;
      if (expression != null) {
        if (!_constraintsIDontWantToDo(node, expression)) {
          if (!(await _evaluateConstraint(
            model,
            resourceCache,
            node,
            context,
            expression,
            results,
          ))) {
            results.addResult(
              node,
              withUrlIfExists('Invariant violation: ${constraint.human}', url),
              Severity.information,
            );
          }
        }
      } else {
        results.addResult(
          node,
          withUrlIfExists('Invariant violation: ${constraint.human}', url),
          Severity.information,
        );
      }
    }
  }
  return results;
}

FhirNode? _getContext(
  ValidationModel<FhirNode> model,
  Node node,
  ElementNode element,
  ValidationResults results,
) {
  final dynamic rawContext = _nodeToMap(node);

  if (element.types.isEmpty || element.path.isEmpty) {
    results.addResult(
      node,
      'Element type or path is missing for node: ${node.path}',
      Severity.error,
    );
    return null;
  }

  final key = element.path.split('.').last;
  final extractedContext =
      rawContext is Map<String, dynamic>
          ? rawContext[key] ?? rawContext
          : rawContext;

  for (final type in element.types) {
    try {
      final context = model.fromType(extractedContext, type.code);
      if (context != null) {
        return context;
      }
    } on Object catch (e) {
      // Whatever the model throws for a value it cannot build.
      results.addResult(
        node,
        'Type conversion failed: Unable to convert '
        '${extractedContext.runtimeType} '
        'to FHIR type "${type.code}". Error: $e',
        Severity.error,
      );
    }
  }

  results.addResult(
    node,
    withUrlIfExists(
      'Unable to determine context type for node: ${node.path}',
      element.contentReference,
    ),
    Severity.warning,
  );
  return null;
}

/// Evaluates a FHIRPath expression against a [FhirNode] context.
Future<bool> _evaluateConstraint(
  ValidationModel<FhirNode> model,
  ResourceCache resourceCache,
  Node node,
  FhirNode? context,
  String expression,
  ValidationResults results,
) async {
  if (context == null) {
    results.addResult(
      node,
      'Context is null for $expression',
      Severity.error,
    );
    return false;
  }

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
