import 'package:collection/collection.dart';
import 'package:fhir_validation/fhir_validation.dart';

/// Validates the cardinality of a [Node] against its corresponding
/// [ElementNode] in the FHIR StructureDefinition.
Future<ValidationResults> validateCardinality({
  required ObjectNode node,
  required Map<String, ElementNode> elements,
  String? url,
  required String originalPath,
  required String replacePath,
  required ValidationResults results,
  required ResourceCache resourceCache,
}) async {
  var newResults = results.copyWith();
  final currentPath = cleanLocalPath(originalPath, replacePath, node.path);
  final missingPaths = <String>[];

  for (final key in elements.keys) {
    if (!_isPathAlreadyChecked(missingPaths, key)) {
      final foundNode =
          _findNodeRecursively(
            node,
            originalPath,
            replacePath,
            cleanLocalPath(originalPath, replacePath, key),
          ) ??
          _checkForPolymorphism(
            node,
            elements[key]!,
            currentPath,
            originalPath,
            replacePath,
          );

      if (foundNode == null && key != originalPath) {
        missingPaths.add(key);
      }

      newResults = await _validateElementCardinality(
        url: url,
        node: node,
        element: elements[key]!,
        foundNode: foundNode,
        path: key,
        originalPath: originalPath,
        replacePath: replacePath,
        elements: elements,
        results: newResults,
        resourceCache: resourceCache,
      );
    }
  }

  return newResults;
}

/// Checks if the [path] is already present in the list of checked paths.
bool _isPathAlreadyChecked(List<String> missingPaths, String path) {
  return missingPaths.indexWhere((element) => path.startsWith(element)) != -1;
}

/// Validates the cardinality of a single element.
Future<ValidationResults> _validateElementCardinality({
  required String? url,
  required ObjectNode node,
  required ElementNode element,
  required Node? foundNode,
  required String path,
  required String originalPath,
  required String replacePath,
  required Map<String, ElementNode> elements,
  required ValidationResults results,
  required ResourceCache resourceCache,
}) async {
  var newResults = results.copyWith();

  // Check for missing required elements
  if (element.min != null && element.min! > 0 && foundNode == null) {
    newResults.addMissingResult(
      path,
      withUrlIfExists(
        '$path: minimum required = ${element.min}, but only found 0',
        url,
      ),
      Severity.error,
    );
  } else if (foundNode != null) {
    // Check for too many occurrences of an element
    if (element.max != null && element.max != '*') {
      final max = int.tryParse(element.max!);
      if (max != null) {
        if (foundNode is PropertyNode) {
          if (foundNode.value is ArrayNode) {}
        }
        // Handle ArrayNode directly
        if (foundNode is ArrayNode && foundNode.children.length > max) {
          newResults.addResult(
            node,
            withUrlIfExists(
              'Too many elements for: $path. maximum allowed is $max.',
              url,
            ),
            Severity.error,
          );
        }
        // Handle PropertyNode containing an ArrayNode
        if (foundNode is PropertyNode &&
            foundNode.value != null &&
            foundNode.value is ArrayNode) {
          final arrayNode = foundNode.value! as ArrayNode;
          if (arrayNode.children.length > max) {
            newResults.addResult(
              node,
              withUrlIfExists(
                'Too many elements for: $path. maximum allowed is $max.',
                url,
              ),
              Severity.error,
            );
          }
        }
      }
    }

    // Check if the required element is populated
    if (element.min != null && element.min! > 0) {
      if (!_isNodePopulated(foundNode)) {
        newResults.addResult(
          node,
          withUrlIfExists('Required element is not populated: $path', url),
          Severity.error,
        );
      }
    } else {
      // Recursively check nested elements if not a primitive type
      newResults = await _validateNestedElements(
        element: element,
        foundNode: foundNode,
        originalPath: originalPath,
        replacePath: replacePath,
        results: newResults,
        resourceCache: resourceCache,
      );
    }
  }

  return newResults;
}

/// Checks if a [Node] is populated or not: a literal with a value, an
/// object with children, an array with items, or a property whose value is
/// one of those. The typed validator took any property with a value as
/// populated, so `"name": {}` satisfied a required element (measured
/// 2026-10-04). R4B json.html, read 2026-10-04: "objects are never empty".
bool _isNodePopulated(Node foundNode) {
  if (foundNode is LiteralNode) return foundNode.value != null;
  if (foundNode is ObjectNode) return foundNode.children.isNotEmpty;
  if (foundNode is ArrayNode) return foundNode.children.isNotEmpty;
  if (foundNode is PropertyNode) {
    final value = foundNode.value;
    return value != null && _isNodePopulated(value);
  }
  return true;
}

/// Validates nested elements recursively if they are complex types.
Future<ValidationResults> _validateNestedElements({
  required ElementNode element,
  required Node foundNode,
  required String originalPath,
  required String replacePath,
  required ValidationResults results,
  required ResourceCache resourceCache,
}) async {
  var newResults = results.copyWith();

  if (element.types.isNotEmpty) {
    final typeCode = findCode(element, foundNode.path);
    if (typeCode != null && !isPrimitiveType(typeCode)) {
      final structureDefinition = await resourceCache.getStructureDefinition(
        typeCode,
      );
      if (structureDefinition != null) {
        final newElements = extractElements(structureDefinition);

        if (foundNode is ObjectNode) {
          newResults = await validateCardinality(
            node: foundNode,
            elements: newElements,
            url: structureDefinitionUrl(structureDefinition),
            originalPath: originalPath,
            replacePath: replacePath,
            results: newResults,
            resourceCache: resourceCache,
          );
        }
      }
    }
  }

  return newResults;
}

/// Recursively finds a [Node] in the AST based on the [targetPath].
Node? _findNodeRecursively(
  Node node,
  String originalPath,
  String replacePath,
  String targetPath,
) {
  final cleanedNodePath = cleanLocalPath(originalPath, replacePath, node.path);

  if (cleanedNodePath == targetPath) {
    return node;
  }

  if (node is ObjectNode) {
    for (final property in node.children) {
      final foundNode = _findNodeRecursively(
        property,
        originalPath,
        replacePath,
        targetPath,
      );
      if (foundNode != null) {
        return foundNode;
      }
    }
  } else if (node is ArrayNode) {
    for (final child in node.children) {
      final foundNode = _findNodeRecursively(
        child,
        originalPath,
        replacePath,
        targetPath,
      );
      if (foundNode != null) {
        return foundNode;
      }
    }
  } else if (node is PropertyNode && node.value != null) {
    final foundNode = _findNodeRecursively(
      node.value!,
      originalPath,
      replacePath,
      targetPath,
    );
    if (foundNode != null) {
      return foundNode;
    }
  }

  return null;
}

/// Checks for polymorphism in the given [ElementNode] and attempts to
/// find the correct node for polymorphic elements.
Node? _checkForPolymorphism(
  ObjectNode node,
  ElementNode element,
  String currentPath,
  String originalPath,
  String replacePath,
) {
  if (_isAPolymorphicElement(element)) {
    return node.children.firstWhereOrNull(
      (child) =>
          cleanLocalPath(
            originalPath,
            replacePath,
            child.path,
          ).replaceFirst('[x]', '') ==
          currentPath,
    );
  }
  return null;
}

/// Determines if an [ElementNode] is polymorphic (ends with `[x]`).
bool _isAPolymorphicElement(ElementNode element) =>
    element.path.endsWith('[x]');
