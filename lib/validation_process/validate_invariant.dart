import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:http/http.dart';

/// Validates the invariants of a [Node] against the corresponding
/// [ElementDefinition].
Future<ValidationResults> validateInvariants({
  required Node node,
  required ElementDefinition element,
  required ValidationResults results,
  String? url,
  Client? client,
}) async {
  if (element.constraint != null) {
    final dynamic context = _getContext(node);
    for (final constraint in element.constraint!) {
      if (constraint.expression != null) {
        if (!_constraintsIDontWantToDo(node, constraint.expression!.value!)) {
          if (!evaluateConstraint(
            context,
            constraint.expression!.value!,
          )) {
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

dynamic _getContext(Node node) {
  // Convert Node to Map to use as context
  dynamic context = nodeToMap(node);

  if (node is PropertyNode && context is Map) {
    final finalPath = node.path.split('.').last;
    context = context[finalPath];
  }

  return context;
}

/// Evaluates a FHIRPath expression against a context.
bool evaluateConstraint(
  dynamic context,
  String expression,
) {
  // Evaluate the FHIRPath expression using the context
  final result = walkFhirPath(
    context: context,
    pathExpression: expression,
  );

  // Check if the result satisfies the constraint
  return result.length == 1 &&
      ((result.first is bool && result.first as bool) ||
          (result.first is FhirBoolean &&
              ((result.first as FhirBoolean).value ?? false)));
}

/// Converts a [Node] to a [Map] for use as a FHIRPath context.
dynamic nodeToMap(Node node) {
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
    return <String, dynamic>{node.key!.value: nodeToMap(node.value!)};
  }
  throw Exception('Unknown node type: ${node.runtimeType}');
}

Map<String, dynamic> _objectNodeToMap(ObjectNode node) {
  final map = <String, dynamic>{};
  for (final property in node.children) {
    if (property.key?.value == null) {
      throw Exception('PropertyNode key is null');
    }
    map[property.key!.value] = nodeToMap(property.value!);
  }
  return map;
}

List<dynamic> _arrayNodeToList(ArrayNode node) {
  return node.children.map(nodeToMap).toList();
}

bool _constraintsIDontWantToDo(Node node, String expression) {
  if (node.path == 'Observation.subject' &&
      expression ==
          "reference.startsWith('#').not() or "
              "(reference.substring(1).trace('url') in "
              "%rootResource.contained.id.trace('ids')) or "
              "(reference='#' and %rootResource!=%resource)") {
    return true;
  } else if (node is PropertyNode &&
      node.value is ArrayNode &&
      expression == 'extension.exists() != value.exists()') {
    return true;
  } else {
    return false;
  }
}
