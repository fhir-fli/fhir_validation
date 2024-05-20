import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import '../fhir_validation.dart';

Future<ValidationResults> validateBindings({
  required Node node,
  required List<ElementDefinition> elements,
  required ValidationResults results,
  Client? client,
}) async {
  for (ElementDefinition element in elements) {
    if (element.binding != null && element.binding!.valueSet != null) {
      final String valueSetUrl = element.binding!.valueSet.toString();
      print('Validating $valueSetUrl');
      final Set<String> validCodes =
          await getValueSetCodes(valueSetUrl, client);
      print('Valid codes: $validCodes');

      final String? elementPath = element.path;
      print('Element path: $elementPath ${node.path}');
      (node as ObjectNode).getPropertyNode(element.path ?? '');
      if (elementPath != null) {
        final Node? targetNode = _findNodeByPath(node, elementPath);
        print('Target node: ${targetNode?.path}');
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
    for (PropertyNode child in node.children) {
      results = await _validateNodeAgainstValueSet(
        child,
        validCodes,
        results,
        strength,
        valueSetUrl,
      );
    }
  } else if (node is PropertyNode && node.value is LiteralNode) {
    final dynamic code = (node.value as LiteralNode).value;
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

Node? _findNodeByPath(Node rootNode, String path) {
  final List<String> pathSegments = path.split('.');
  Node? currentNode = rootNode;

  for (final String segment in pathSegments) {
    if (currentNode == null) {
      return null;
    }

    // Handle array indices
    final RegExpMatch? match = RegExp(r'(\w+)\[(\d+)\]').firstMatch(segment);
    if (match != null) {
      currentNode = _getNodeAtArrayIndex(currentNode, match);
      if (currentNode == null) {
        return null;
      }
    } else {
      currentNode = _getNodeAtProperty(currentNode, segment);
      if (currentNode == null) {
        return null;
      }
    }
  }

  return currentNode;
}

Node? _getNodeAtArrayIndex(Node currentNode, RegExpMatch match) {
  final String propertyName = match.group(1)!;
  final int index = int.parse(match.group(2)!);

  if (currentNode is ObjectNode) {
    final Node? propertyNode = currentNode.getPropertyNode(propertyName);
    if (propertyNode is ArrayNode && index < propertyNode.children.length) {
      return propertyNode.children[index];
    }
  }
  return null;
}

Node? _getNodeAtProperty(Node currentNode, String segment) {
  if (currentNode is ObjectNode) {
    return currentNode.getPropertyNode(segment);
  } else if (currentNode is ArrayNode) {
    final int? index = int.tryParse(segment.replaceAll(RegExp(r'\D'), ''));
    if (index != null && index < currentNode.children.length) {
      return currentNode.children[index];
    }
  }
  return null;
}
