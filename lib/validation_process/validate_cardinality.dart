import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:http/http.dart';

/// Validates the cardinality of a [Node] against the corresponding
/// [ElementDefinition].
Future<ValidationResults> validateCardinality(
  String? url,
  ObjectNode node,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  var newResults = results.copyWith();
  final currentPath = cleanLocalPath(originalPath, replacePath, node.path);
  final missingPaths = <String>[];

  for (final element in elements) {
    final path = element.path.value;
    if (path != null) {
      if (!_isPathAlreadyChecked(missingPaths, path)) {
        final foundNode = _findNodeRecursively(
              node,
              originalPath,
              replacePath,
              cleanLocalPath(originalPath, replacePath, path),
            ) ??
            _checkForPolymorphism(
              node,
              element,
              currentPath,
              originalPath,
              replacePath,
            );

        if (foundNode == null && path != originalPath) {
          missingPaths.add(path);
        }

        newResults = await _validateElementCardinality(
          url: url,
          node: node,
          element: element,
          foundNode: foundNode,
          path: path,
          originalPath: originalPath,
          replacePath: replacePath,
          elements: elements,
          results: newResults,
          client: client,
        );
      }
    }
  }

  return newResults;
}

bool _isPathAlreadyChecked(List<String> missingPaths, String path) {
  return missingPaths
          .indexWhere((String element) => path.startsWith(element)) !=
      -1;
}

Future<ValidationResults> _validateElementCardinality({
  required String? url,
  required ObjectNode node,
  required ElementDefinition element,
  required Node? foundNode,
  required String path,
  required String originalPath,
  required String replacePath,
  required List<ElementDefinition> elements,
  required ValidationResults results,
  required Client? client,
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
    if (element.max != null && element.max!.value != '*') {
      final max = int.tryParse(element.max!.value!);
      if (max != null &&
          foundNode is ArrayNode &&
          foundNode.children.length > max) {
        newResults.addResult(
          node,
          withUrlIfExists(
            'Too many elements for: $path. Maximum allowed is $max.',
            url,
          ),
          Severity.error,
        );
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
        client: client,
      );
    }
  }
  return newResults;
}

bool _isNodePopulated(Node foundNode) {
  return !(foundNode is LiteralNode && foundNode.value == null) &&
      !(foundNode is ObjectNode && foundNode.children.isEmpty) &&
      !(foundNode is PropertyNode && foundNode.value == null);
}

Future<ValidationResults> _validateNestedElements({
  required ElementDefinition element,
  required Node foundNode,
  required String originalPath,
  required String replacePath,
  required ValidationResults results,
  required Client? client,
}) async {
  var newResults = results.copyWith();
  if (element.type != null && element.type!.isNotEmpty) {
    final typeCode = findCode(element, foundNode.path);
    if (typeCode != null && !isPrimitiveType(typeCode)) {
      final structureDefinitionMap = await getResource(typeCode, client);
      if (structureDefinitionMap != null &&
          structureDefinitionMap['resourceType'] == 'StructureDefinition') {
        final structureDefinition =
            StructureDefinition.fromJson(structureDefinitionMap);
        final newElements = extractElements(structureDefinition);
        if (foundNode is ObjectNode) {
          newResults = await validateCardinality(
            structureDefinition.getUrl(),
            foundNode,
            originalPath,
            replacePath,
            newElements,
            newResults,
            client,
          );
        }
      }
    }
  }
  return newResults;
}

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
      final foundNode =
          _findNodeRecursively(property, originalPath, replacePath, targetPath);
      if (foundNode != null) {
        return foundNode;
      }
    }
  } else if (node is ArrayNode) {
    for (final child in node.children) {
      final foundNode =
          _findNodeRecursively(child, originalPath, replacePath, targetPath);
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

Node? _checkForPolymorphism(
  ObjectNode node,
  ElementDefinition element,
  String currentPath,
  String originalPath,
  String replacePath,
) {
  if (_isAPolymorphicElement(element)) {
    return node.children.firstWhereOrNull(
      (PropertyNode child) =>
          cleanLocalPath(originalPath, replacePath, child.path)
              .replaceFirst('[x]', '') ==
          currentPath,
    );
  }
  return null;
}

bool _isAPolymorphicElement(ElementDefinition element) =>
    element.path.value?.endsWith('[x]') ?? false;
