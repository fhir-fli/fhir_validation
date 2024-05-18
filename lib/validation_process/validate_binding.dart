import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';

import '../fhir_validation.dart';

Future<ValidationResults> validateBindings({
  required Node node,
  required List<ElementDefinition> elements,
  required ValidationResults results,
  Client? client,
}) async {
  for (var element in elements) {
    if (element.binding != null && element.binding!.valueSet != null) {
      final valueSetUrl = element.binding!.valueSet.toString();
      final validCodes = await getValueSetCodes(valueSetUrl, client);

      final elementPath = element.path;
      if (elementPath != null) {
        final targetNode = findNodeByPath(node, elementPath);
        if (targetNode != null) {
          results = await _validateNodeAgainstValueSet(
            targetNode,
            validCodes,
            results,
            element.binding!.strength,
            valueSetUrl,
          );
        }
      }
    }
  }
  return results;
}

Future<ValidationResults> _validateNodeAgainstValueSet(
  Node node,
  Set<String> validCodes,
  ValidationResults results,
  ElementDefinitionBindingStrength? strength,
  String valueSetUrl,
) async {
  if (node is ObjectNode) {
    for (var child in node.children) {
      results = await _validateNodeAgainstValueSet(
          child, validCodes, results, strength, valueSetUrl);
    }
  } else if (node is PropertyNode && node.value is LiteralNode) {
    final code = (node.value as LiteralNode).value;
    if (code != null && !validCodes.contains(code)) {
      results.addResult(
        node,
        'Code "$code" is not valid according to ValueSet $valueSetUrl',
        strength == ElementDefinitionBindingStrength.required_
            ? Severity.error
            : Severity.warning,
      );
    }
  }
  return results;
}

Node? findNodeByPath(Node rootNode, String path) {
  final pathSegments = path.split('.');
  Node? currentNode = rootNode;

  for (final segment in pathSegments) {
    if (currentNode == null) {
      return null;
    }

    // Handle array indices
    final match = RegExp(r'(\w+)\[(\d+)\]').firstMatch(segment);
    if (match != null) {
      final propertyName = match.group(1)!;
      final index = int.parse(match.group(2)!);

      if (currentNode is ObjectNode) {
        currentNode = currentNode.getPropertyNode(propertyName);
        if (currentNode is ArrayNode) {
          currentNode = (currentNode as ArrayNode).children[index];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      if (currentNode is ObjectNode) {
        currentNode = currentNode.getPropertyNode(segment);
      } else if (currentNode is ArrayNode) {
        final index = int.parse(segment.replaceAll(RegExp(r'\D'), ''));
        currentNode = (currentNode as ArrayNode).children[index];
      } else {
        return null;
      }
    }
  }

  return currentNode;
}
