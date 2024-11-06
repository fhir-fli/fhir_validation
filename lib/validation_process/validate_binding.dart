import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:http/http.dart';


/// Validate the bindings of a node against the value sets defined in the
/// element definitions.
Future<ValidationResults> validateBindings({
  required Node node,
  required List<ElementDefinition> elements,
  required ValidationResults results,
  Client? client,
}) async {
  var newResults = results.copyWith();
  for (final element in elements) {
    if (element.binding != null && element.binding!.valueSet != null) {
      final valueSetUrl = element.binding!.valueSet.toString();
      final validCodes = await getValueSetCodes(valueSetUrl, client);
      final elementPath = element.path.value;
      (node as ObjectNode).getPropertyNode(element.path.value ?? '');
      if (elementPath != null) {
        final targetNode = _findNodeByPath(node, elementPath);
        if (targetNode != null) {
          newResults = await _validateNodeAgainstValueSet(
            targetNode,
            validCodes,
            newResults,
            element.binding!.strength,
            valueSetUrl,
          );
        }
      }
    }
  }
  return newResults;
}

Future<ValidationResults> _validateNodeAgainstValueSet(
  Node node,
  Set<String> validCodes,
  ValidationResults results,
  BindingStrength? strength,
  String valueSetUrl,
) async {
  var newResults = results.copyWith();
  if (node is ObjectNode) {
    for (final child in node.children) {
      newResults = await _validateNodeAgainstValueSet(
        child,
        validCodes,
        newResults,
        strength,
        valueSetUrl,
      );
    }
  } else if (node is PropertyNode && node.value is LiteralNode) {
    final dynamic code = (node.value! as LiteralNode).value;
    if (code != null && !validCodes.contains(code)) {
      newResults.addResult(
        node,
        'Code "$code" is not valid according to ValueSet $valueSetUrl',
        strength == BindingStrength.required_
            ? Severity.error
            : Severity.warning,
      );
    }
  }
  return newResults;
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
