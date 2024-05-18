import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import '../fhir_validation.dart';

Future<ValidationResults> validateCardinality(
  String? url,
  ObjectNode node,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  final currentPath = cleanLocalPath(originalPath, replacePath, node.path);
  final missingPaths = <String>[];

  for (final element in elements) {
    final path = element.path;
    if (path != null) {
      final index =
          missingPaths.indexWhere((element) => path.startsWith(element));
      if (index == -1) {
        Node? foundNode = _findNodeRecursively(node, originalPath, replacePath,
                cleanLocalPath(originalPath, replacePath, path)) ??
            checkForPolymorphism(
                node, element, currentPath, originalPath, replacePath);

        if (foundNode == null && path != originalPath) {
          missingPaths.add(path);
        }

        // Check for missing required elements
        if (element.min != null && element.min! > 0 && foundNode == null) {
          results.addMissingResult(
            path,
            '$path: minimum required = ${element.min}, but only found 0 '
            '${url == null ? '' : '(from $url)'}',
            Severity.error,
          );
        } else if (foundNode != null) {
          // Check for too many occurrences of an element
          if (element.max != null && element.max != '*') {
            final max = int.tryParse(element.max!);
            if (max != null &&
                foundNode is ArrayNode &&
                foundNode.children.length > max) {
              results.addResult(
                node,
                'Too many elements for: $path. Maximum allowed is $max.',
                Severity.error,
              );
            }
          }

          // Check if the required element is populated
          if (element.min != null && element.min! > 0) {
            if ((foundNode is LiteralNode && foundNode.value == null) ||
                (foundNode is ObjectNode && foundNode.children.isEmpty) ||
                (foundNode is PropertyNode && foundNode.value == null)) {
              results.addResult(
                node,
                'Required element is not populated: $path',
                Severity.error,
              );
            }
          } else {
            // Recursively check nested elements if not a primitive type
            if (element.type != null && element.type!.isNotEmpty) {
              final typeCode = findCode(element, foundNode.path);
              if (typeCode != null && !isPrimitiveType(typeCode)) {
                final structureDefinition =
                    await getStructureDefinition(typeCode, client);
                if (structureDefinition != null) {
                  final newElements = extractElements(
                      StructureDefinition.fromJson(structureDefinition));
                  if (foundNode is ObjectNode) {
                    results = await validateCardinality(
                        url,
                        foundNode,
                        originalPath,
                        replacePath,
                        newElements,
                        results,
                        client);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  return results;
}

Node? _findNodeRecursively(
    Node node, String originalPath, String replacePath, String targetPath) {
  final cleanedNodePath = cleanLocalPath(originalPath, replacePath, node.path);

  // Check if the current node matches the target path
  if (cleanedNodePath == targetPath) {
    return node;
  }

  // If the node has children, recursively search them
  if (node is ObjectNode) {
    for (var property in node.children) {
      final foundNode =
          _findNodeRecursively(property, originalPath, replacePath, targetPath);
      if (foundNode != null) {
        return foundNode;
      }
    }
  } else if (node is ArrayNode) {
    for (var child in node.children) {
      final foundNode =
          _findNodeRecursively(child, originalPath, replacePath, targetPath);
      if (foundNode != null) {
        return foundNode;
      }
    }
  } else if (node is PropertyNode) {
    if (node.value != null) {
      final foundNode = _findNodeRecursively(
          node.value!, originalPath, replacePath, targetPath);
      if (foundNode != null) {
        return foundNode;
      }
    }
  }

  // No matching node found
  return null;
}
