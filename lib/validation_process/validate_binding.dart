import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import 'package:fhir_validation/fhir_validation.dart';

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
      final elementPath = element.path.value;
      (node as ObjectNode).getPropertyNode(element.path.value ?? '');
      if (elementPath != null) {
        final targetNode = _findNodeByPath(node, elementPath);
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
  BindingStrength? strength,
  String valueSetUrl,
) async {
  if (node is ObjectNode) {
    for (var child in node.children) {
      results = await _validateNodeAgainstValueSet(
        child,
        validCodes,
        results,
        strength,
        valueSetUrl,
      );
    }
  } else if (node is PropertyNode && node.value is LiteralNode) {
    final dynamic code = (node.value! as LiteralNode).value;
    if (code != null && !validCodes.contains(code)) {
      results.addResult(
        node,
        'Code "$code" is not valid according to ValueSet $valueSetUrl',
        strength == BindingStrength.required_
            ? Severity.error
            : Severity.warning,
      );
    }
  }
  return results;
}

Node? _findNodeByPath(Node rootNode, String path) {
  final pathSegments = path.split('.');
  Node? currentNode = rootNode;

  for (final segment in pathSegments) {
    if (currentNode == null) {
      return null;
    }

    // Handle array indices
    final match = RegExp(r'(\w+)\[(\d+)\]').firstMatch(segment);
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
  final propertyName = match.group(1)!;
  final index = int.parse(match.group(2)!);

  if (currentNode is ObjectNode) {
    final propertyNode = currentNode.getPropertyNode(propertyName);
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
    final index = int.tryParse(segment.replaceAll(RegExp(r'\D'), ''));
    if (index != null && index < currentNode.children.length) {
      return currentNode.children[index];
    }
  }
  return null;
}
