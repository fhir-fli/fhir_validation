import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';

import '../fhir_validation.dart';

Future<ValidationResults> validateInvariants({
  required Node node,
  required List<ElementDefinition> elements,
  required ValidationResults results,
  String? url,
  Client? client,
}) async {
  for (final ElementDefinition element in elements) {
    if (element.constraint != null) {
      for (final ElementDefinitionConstraint constraint
          in element.constraint!) {
        if (!await evaluateConstraint(constraint, node)) {
          results.addResult(
            node,
            withUrlIfExists('Invariant violation: ${constraint.human}', url),
            Severity.information,
          );
        }
      }
    }
  }
  return results;
}

Future<bool> evaluateConstraint(
  ElementDefinitionConstraint constraint,
  Node node,
) async {
  // Extract FHIRPath expression
  final String? expression = constraint.expression;

  if (expression == null) {
    return false;
  }

  if (node is ObjectNode) {
    print(node.path);
  }

  // Convert Node to Map to use as context
  final dynamic context = nodeToMap(node);

  // Evaluate the FHIRPath expression using the context
  final List<dynamic> result = walkFhirPath(
    context: context,
    pathExpression: expression,
  );

  // Check if the result satisfies the constraint
  return result.length == 1 && result.first is bool && result.first as bool;
}

dynamic nodeToMap(Node node) {
  if (node is ObjectNode) {
    return _objectNodeToMap(node);
  } else if (node is ArrayNode) {
    return <String, dynamic>{'value': _arrayNodeToList(node)};
  } else if (node is PropertyNode) {
    if (node.key?.value == null) {
      throw Exception('PropertyNode key is null');
    }
    return <String, dynamic>{node.key!.value: nodeToMap(node.value!)};
  } else if (node is LiteralNode) {
    return <String, dynamic>{'value': node.value};
  }
  throw Exception('Unknown node type: ${node.runtimeType}');
}

Map<String, dynamic> _objectNodeToMap(ObjectNode node) {
  final Map<String, dynamic> map = <String, dynamic>{};
  for (final PropertyNode property in node.children) {
    if (property.key?.value == null) {
      throw Exception('PropertyNode key is null');
    }
    map[property.key!.value] = nodeToMap(property.value!);
  }
  return map;
}

List<dynamic> _arrayNodeToList(ArrayNode node) {
  return node.children.map((Node child) => nodeToMap(child)).toList();
}
