import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

class FhirValidatorUtils {
  Future<ValidationResults> evaluateFromPaths({
    required Map<String, dynamic> mapToValidate,
    required StructureDefinition structureDefinition,
    required String type,
    required String startPath,
    required Node node,
  }) async {
    var results = ValidationResults();

    // Extract elements from the main structure definition
    final elements = extractElements(structureDefinition);

    if (node is! ObjectNode) {
      throw Exception('Root node must be an ObjectNode');
    }

    results = await _objectNode(node, type, type, elements, results);

    // Check for missing required fields
    results = await _checkMissingOrExtraFields(
        _sdUrl(structureDefinition), node, type, type, elements, results);

    return results;
  }

  Future<ValidationResults> _checkMissingOrExtraFields(
    String? url,
    ObjectNode node,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    final currentPath = _cleanLocalPath(originalPath, replacePath, node.path);
    final missingPaths = <String>[];

    for (final element in elements) {
      final path = element.path;
      if (path != null) {
        final index =
            missingPaths.indexWhere((element) => path.startsWith(element));
        if (index == -1) {
          Node? foundNode = _findNodeRecursively(node, originalPath,
              replacePath, _cleanLocalPath(originalPath, replacePath, path));

          if (foundNode == null && _isAPolymorphicElement(element)) {
            foundNode = node.children.firstWhereOrNull(
              (child) =>
                  _cleanLocalPath(originalPath, replacePath, child.path)
                      .replaceFirst('[x]', '') ==
                  currentPath,
            );
          }

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
              if (foundNode is LiteralNode && foundNode.value == null) {
                results.addResult(
                  node,
                  'Required element is not populated: $path',
                  Severity.error,
                );
              } else if (foundNode is ArrayNode && foundNode.children.isEmpty) {
                results.addResult(
                  node,
                  'Required element is not populated: $path',
                  Severity.error,
                );
              } else if (foundNode is PropertyNode && foundNode.key == null) {
                results.addResult(
                  node,
                  'Required element is not populated: $path',
                  Severity.error,
                );
              }
            } else {
              // Recursively check nested elements if not a primitive type
              if (element.type != null && element.type!.isNotEmpty) {
                final typeCode = _findCode(element, foundNode.path);
                if (typeCode != null && !isPrimitiveType(typeCode)) {
                  final structureDefinition =
                      await getStructureDefinition(typeCode);
                  if (structureDefinition != null) {
                    final newElements = extractElements(
                        StructureDefinition.fromJson(structureDefinition));
                    if (foundNode is ObjectNode) {
                      results = await _checkMissingOrExtraFields(url, foundNode,
                          originalPath, replacePath, newElements, results);
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
    final cleanedNodePath =
        _cleanLocalPath(originalPath, replacePath, node.path);

    // Check if the current node matches the target path
    if (cleanedNodePath == targetPath) {
      return node;
    }

    // If the node has children, recursively search them
    if (node is ObjectNode) {
      for (var property in node.children) {
        final foundNode = _findNodeRecursively(
            property, originalPath, replacePath, targetPath);
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

  List<ElementDefinition> extractElements(
      StructureDefinition structureDefinition) {
    return structureDefinition.snapshot?.element ?? [];
  }

  Future<ValidationResults> _traverseAst(
    Node node,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    if (node is ObjectNode) {
      return await _objectNode(
          node, originalPath, replacePath, elements, results);
    } else if (node is ArrayNode) {
      return await _arrayNode(
          node, originalPath, replacePath, elements, results);
    } else if (node is PropertyNode) {
      return await _propertyNode(
          node, originalPath, replacePath, elements, results);
    } else {
      throw Exception('Invalid node type: ${node.runtimeType} at ${node.path}');
    }
  }

  Future<ValidationResults> _objectNode(
    ObjectNode node,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    for (var property in node.children) {
      results = await _propertyNode(
          property, originalPath, replacePath, elements, results);
    }
    return results;
  }

  Future<ValidationResults> _arrayNode(
    ArrayNode node,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    for (final child in node.children) {
      if (child is LiteralNode) {
        final currentPath =
            _cleanLocalPath(originalPath, replacePath, node.path);
        final element =
            elements.firstWhereOrNull((element) => element.path == currentPath);
        if (element != null) {
          results = await _literalNode(child, element, results);
        } else {
          results.addResult(
            child,
            'Element not found in StructureDefinition - ${child.raw}',
            Severity.error,
          );
        }
      } else {
        results = await _traverseAst(
            child, originalPath, replacePath, elements, results);
      }
    }
    return results;
  }

  Future<ValidationResults> _propertyNode(
    PropertyNode node,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    final cleanLocalPath =
        _cleanLocalPath(originalPath, replacePath, node.path);
    ElementDefinition? element =
        elements.firstWhereOrNull((element) => element.path == cleanLocalPath);

    if (_isAResourceType(node, element)) {
      return results;
    }

    element ??= _polymorphicElement(cleanLocalPath, elements);

    if (element != null) {
      return await _withElement(
          node, element, originalPath, replacePath, elements, results);
    } else {
      results.addResult(
        node,
        'Element not found in StructureDefinition',
        Severity.error,
      );
      return results;
    }
  }

  Future<ValidationResults> _withElement(
    PropertyNode node,
    ElementDefinition element,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    final String? code = _findCode(element, node.path);
    if (code != null) {
      return await _withCode(
          code, node, element, originalPath, replacePath, elements, results);
    } else {
      return await _withoutCode(
          node, element, originalPath, replacePath, results);
    }
  }

  Future<ValidationResults> _withoutCode(
    PropertyNode node,
    ElementDefinition element,
    String originalPath,
    String replacePath,
    ValidationResults results,
  ) async {
    for (final ext in element.extension_ ?? <FhirExtension>[]) {
      final url = ext.url?.toString();
      if (url != null) {
        final structureDefinition = await getStructureDefinition(url);
        if (structureDefinition != null) {
          final newElements = extractElements(
              StructureDefinition.fromJson(structureDefinition));
          return await _traverseAst(
              node, originalPath, replacePath, newElements, results);
        }
      }
    }
    results.addResult(
      node,
      element.toJson().toString(),
      Severity.error,
    );
    return results;
  }

  Future<ValidationResults> _withCode(
    String code,
    PropertyNode node,
    ElementDefinition element,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    if (isPrimitiveType(code)) {
      return await _codeIsPrimitiveType(
          node, element, originalPath, replacePath, elements, results);
    } else {
      return await _codeIsComplexType(
          code, node, element, originalPath, replacePath, elements, results);
    }
  }

  Future<ValidationResults> _codeIsComplexType(
    String code,
    PropertyNode node,
    ElementDefinition element,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    final structureDefinitionMap = await getStructureDefinition(code);
    final StructureDefinition? structureDefinition =
        structureDefinitionMap != null
            ? StructureDefinition.fromJson(structureDefinitionMap)
            : null;
    if (structureDefinition == null) {
      return _noStructureDefinitionOrProfile(code, node, results);
    }
    final newElements = extractElements(structureDefinition);
    if (newElements.isNotEmpty) {
      if (node.value != null) {
        return await _traverseAst(
            node.value!, node.path, code, newElements, results);
      } else {
        throw Exception('node is ${node.runtimeType} with null node.value');
      }
    } else {
      return _noStructureDefinitionOrProfile(code, node, results);
    }
  }

  ValidationResults _noStructureDefinitionOrProfile(
    String code,
    PropertyNode node,
    ValidationResults results,
  ) =>
      results
        ..addResult(
          node,
          'No StructureDefinition or Profile found for Element type $code',
          Severity.error,
        );

  Future<ValidationResults> _codeIsPrimitiveType(
    PropertyNode node,
    ElementDefinition element,
    String originalPath,
    String replacePath,
    List<ElementDefinition> elements,
    ValidationResults results,
  ) async {
    if (node.value is LiteralNode) {
      return await _literalNode(node.value as LiteralNode, element, results);
    } else if (node.value is ArrayNode) {
      return await _arrayNode(node.value as ArrayNode, originalPath,
          replacePath, elements, results);
    } else {
      throw Exception(
          'Primitive element is not a Primitive or a List: ${node.value.runtimeType}');
    }
  }

  Future<ValidationResults> _literalNode(
    LiteralNode node,
    ElementDefinition element,
    ValidationResults results,
  ) async {
    final primitiveClass = _findCode(element, node.path);
    final value = node.value;
    if (!isValueAValidPrimitive(primitiveClass.toString(), value)) {
      results.addResult(
        node,
        'Invalid value for primitive type: $primitiveClass',
        Severity.error,
      );
    }
    return results;
  }

  bool _isAResourceType(PropertyNode node, ElementDefinition? element) =>
      element == null &&
      node.value is LiteralNode &&
      node.key?.value == 'resourceType' &&
      R4ResourceType.typesAsStrings.contains((node.value as LiteralNode).value);

  ElementDefinition? _polymorphicElement(
      String path, List<ElementDefinition> elements) {
    return elements.firstWhereOrNull((element) =>
        element.path != null &&
        element.path!.endsWith('[x]') &&
        path.startsWith(element.path!.replaceFirst('[x]', '')));
  }

  bool _isAPolymorphicElement(ElementDefinition element) =>
      element.path != null && element.path!.endsWith('[x]');

  String? _findCode(ElementDefinition element, String path) {
    if (element.type?.length == 1) {
      return element.type?.first.code?.toString();
    } else if ((element.type?.length ?? 0) > 1) {
      if (element.path?.endsWith('[x]') ?? false) {
        final type = path
            .split('.')
            .last
            .replaceAll(
                element.path?.split('.').last.replaceAll('[x]', '') ?? '', '')
            .toLowerCase();
        return element.type!
            .firstWhereOrNull((t) => t.code?.toString().toLowerCase() == type)
            ?.code
            ?.toString();
      }
    }
    return null;
  }

  String _cleanLocalPath(
      String originalPath, String replacePath, String childPath) {
    childPath = childPath.replaceAll(originalPath, replacePath);
    return _stripIndexes(childPath);
  }

  String _stripIndexes(String path) {
    RegExp regex = RegExp(r'\[\d+\]');
    return path.replaceAll(regex, '');
  }

  String? _sdUrl(StructureDefinition structureDefinition) {
    String? sdUrl = structureDefinition.url?.toString();
    if (sdUrl != null && structureDefinition.version != null) {
      sdUrl += '|${structureDefinition.version}';
    }
    return sdUrl;
  }
}
