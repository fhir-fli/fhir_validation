import 'package:fhir_validation/fhir_validation.dart';

/// Validates the bindings of nodes against the value sets defined in their
/// corresponding [ElementNode]s.
///
/// Ensures that the codes in the FHIR resource are valid according to the
/// bindings specified in the FHIR StructureDefinition.
Future<ValidationResults> validateBindings({
  required Node node,
  required Map<String, ElementNode> elements,
  required ValidationResults results,
  required ResourceCache resourceCache,
}) async {
  var newResults = results.copyWith();

  for (final element in elements.values) {
    // Check if the element has a binding with an associated ValueSet.
    final binding = element.binding;
    final valueSetUrl = binding?.valueSet;
    if (binding != null && valueSetUrl != null) {
      final validCodes = await getValueSetCodes(valueSetUrl, resourceCache);
      final elementPath = element.path;

      // Find the node corresponding to the element path.
      final targetNode = _findNodeByPath(node, elementPath);

      // Validate the target node against the valid codes from the ValueSet.
      if (targetNode != null) {
        newResults = _validateNodeAgainstValueSet(
          targetNode,
          validCodes,
          newResults,
          binding.strength,
          valueSetUrl,
        );
      }
    }
  }

  return newResults;
}

/// Validates a [Node] against a given ValueSet.
///
/// Checks if the [Node]'s value is part of the allowed codes in the ValueSet.
/// If not, adds a diagnostic to the [ValidationResults].
ValidationResults _validateNodeAgainstValueSet(
  Node node,
  Set<String> validCodes,
  ValidationResults results,
  String? strength,
  String valueSetUrl,
) {
  var newResults = results.copyWith();

  if (node is ObjectNode) {
    // Recursively validate all child nodes.
    for (final child in node.children) {
      newResults = _validateNodeAgainstValueSet(
        child,
        validCodes,
        newResults,
        strength,
        valueSetUrl,
      );
    }
  } else if (node is ArrayNode) {
    // A repeating coded element: every item.
    for (final child in node.children) {
      newResults = _validateNodeAgainstValueSet(
        child,
        validCodes,
        newResults,
        strength,
        valueSetUrl,
      );
    }
  } else if (node is LiteralNode ||
      (node is PropertyNode && node.value is LiteralNode)) {
    // Validate the literal value against the ValueSet. The node found by
    // path is the property's value, a LiteralNode; the typed validator
    // handled only a PropertyNode here, so a found value was never checked.
    final dynamic code =
        node is LiteralNode
            ? node.value
            : ((node as PropertyNode).value! as LiteralNode).value;
    if (code != null && !validCodes.contains(code)) {
      newResults.addResult(
        node,
        'Code "$code" is not valid according to ValueSet $valueSetUrl',
        strength == 'required' ? Severity.error : Severity.warning,
      );
    }
  }

  return newResults;
}

/// Finds a [Node] within the AST by its FHIR path.
///
/// Handles nested paths and array indexing (e.g., `patient.name[0].given`).
Node? _findNodeByPath(Node rootNode, String path) {
  final pathSegments = path.split('.');
  Node? currentNode = rootNode;

  // An element path starts with the resource type (`Observation.status`),
  // which is the root node itself, not a property of it. The typed
  // validator looked the type up as a property, found nothing, and so never
  // checked a single binding (measured 2026-10-04: a required binding with a
  // code outside its value set reported nothing).
  if (pathSegments.isNotEmpty && pathSegments.first == rootNode.path) {
    pathSegments.removeAt(0);
  }

  for (final segment in pathSegments) {
    if (currentNode == null) {
      return null;
    }

    // Handle array indexing within the path (e.g., `name[0]`).
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

/// Retrieves a [Node] at a specific array index based on a regex match.
///
/// Used for paths like `name[0]` to access the 0th element of the `name` array.
Node? _getNodeAtArrayIndex(Node currentNode, RegExpMatch match) {
  final propertyName = match.group(1)!; // The property name (e.g., `name`).
  final index = int.parse(match.group(2)!); // The array index (e.g., `0`).

  if (currentNode is ObjectNode) {
    // Get the property node and ensure it's an array.
    final propertyNode = currentNode.getPropertyNode(propertyName);
    if (propertyNode is ArrayNode && index < propertyNode.children.length) {
      return propertyNode.children[index];
    }
  }

  return null;
}

/// Retrieves a [Node] corresponding to a property name in an object or array.
///
/// Handles both [ObjectNode] and [ArrayNode] types for traversing the AST.
Node? _getNodeAtProperty(Node currentNode, String segment) {
  if (currentNode is ObjectNode) {
    // Retrieve a child property node by its name.
    return currentNode.getPropertyNode(segment);
  } else if (currentNode is ArrayNode) {
    // Attempt to parse the segment as an index to access an array element.
    final index = int.tryParse(segment.replaceAll(RegExp(r'\D'), ''));
    if (index != null && index < currentNode.children.length) {
      return currentNode.children[index];
    }
  }

  return null;
}
