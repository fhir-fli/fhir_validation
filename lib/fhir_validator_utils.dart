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

    return await _objectNode(node, type, type, elements, results);
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
      ValidationResults results) async {
    print('traverse: ${node.path}');
    if (node is ObjectNode) {
      return _objectNode(node, originalPath, replacePath, elements, results);
    } else if (node is ArrayNode) {
      return _arrayNode(node, originalPath, replacePath, elements, results);
    } else if (node is PropertyNode) {
      return _propertyNode(node, originalPath, replacePath, elements, results);
    } else {
      throw Exception('Invalid node type: ${node.runtimeType} at ${node.path}');
    }
  }

  Future<ValidationResults> _objectNode(
      ObjectNode node,
      String originalPath,
      String replacePath,
      List<ElementDefinition> elements,
      ValidationResults results) async {
    print('object: ${node.path}');
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
      ValidationResults results) async {
    print('array: ${node.path}');
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
            currentPath,
            'Element not found in StructureDefinition - ${child.raw}',
            Severity.error,
            line: child.loc?.start.line,
            column: child.loc?.start.column,
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
      ValidationResults results) async {
    print('property: ${node.path}');
    final currentPath = node.path;
    final cleanLocalPath =
        _cleanLocalPath(originalPath, replacePath, currentPath);
    ElementDefinition? element =
        elements.firstWhereOrNull((element) => element.path == cleanLocalPath);

    // If the element is null, but the key is "resourceType" and the value is
    // a valid resourceType, then this is a valid entry, although it's not
    // in the structure maps
    if (element == null) {
      if (node.value is LiteralNode &&
          node.key?.value == 'resourceType' &&
          R4ResourceType.typesAsStrings
              .contains((node.value as LiteralNode).value)) {
        return results;
      }
    }
    if (element == null) {
      element = elements.firstWhereOrNull((element) =>
          element.path != null &&
          cleanLocalPath.startsWith(element.path!.replaceFirst('[x]', '')));
    }

    if (element != null) {
      // We get the code from the StructureDefinition to determine if it's
      // a primitive type
      final code = element.type?.first.code?.toString();
      if (code != null && _isPrimitive(element)) {
        if (node.value is LiteralNode) {
          results =
              await _literalNode(node.value as LiteralNode, element, results);
        } else if (node.value is ArrayNode) {
          results = await _arrayNode(node.value as ArrayNode, originalPath,
              replacePath, elements, results);
        } else {
          throw Exception(
              'Primitive element is not a Primitive or a List: ${node.value.runtimeType} at $currentPath');
        }
      } else if (code != null) {
        // If not, then it's not a primitive structure, and we will need
        // to find a separate StructureDefinition or Profile to validate
        // the object.
        final structureDefinitionMap = await getStructureDefinition(code);
        final StructureDefinition? structureDefinition =
            structureDefinitionMap != null
                ? StructureDefinition.fromJson(structureDefinitionMap)
                : null;
        if (structureDefinition == null) {
          return results
            ..addResult(
              currentPath,
              'No StructureDefinition or Profile found for Element type $code',
              Severity.error,
              line: node.key?.loc?.start.line,
              column: node.key?.loc?.start.column,
            );
        }
        final newElements = extractElements(structureDefinition);
        // If we find the StructureDefinition, we should traverse the AST
        if (newElements.isNotEmpty) {
          if (node.value != null) {
            results = await _traverseAst(
                node.value!, currentPath, code, newElements, results);
          } else {
            throw Exception('node is ${node.runtimeType} with null node.value');
          }
        } else {
          results.addResult(
            currentPath,
            'No StructureDefinition or Profile found for Element type $code',
            Severity.error,
            line: node.key?.loc?.start.line,
            column: node.key?.loc?.start.column,
          );
        }
      }
    }
    // if we aren't able to find it in the elements, we should add it to the
    // ValidationResults as an error, and won't go looking for anything else
    else {
      return results
        ..addResult(
          currentPath,
          'Element not found in StructureDefinition',
          Severity.error,
          line: node.loc?.start.line,
          column: node.loc?.start.column,
        );
    }
    return results;
  }

  String _cleanLocalPath(
      String originalPath, String replacePath, String childPath) {
    childPath = childPath.replaceAll(originalPath, replacePath);
    return _stripIndexes(childPath);
  }

  String _stripIndexes(String path) {
    // Regular expression to match [index] patterns
    RegExp regex = RegExp(r'\[\d+\]');
    // Replace all matches with an empty string
    return path.replaceAll(regex, '');
  }

  bool _isPrimitive(ElementDefinition element) {
    if (element.type == null || element.type!.isEmpty) return false;
    final primitiveType = element.type!.first.code?.toString().toLowerCase();
    return primitiveType != null && isPrimitiveType(primitiveType);
  }

  Future<ValidationResults> _literalNode(LiteralNode node,
      ElementDefinition element, ValidationResults results) async {
    final primitiveClass = element.type!.first.code!;
    final value = node.value;
    if (!isValueAValidPrimitive(primitiveClass.toString(), value)) {
      results.addResult(
        node.path,
        'Invalid value for primitive type: $primitiveClass',
        Severity.error,
        line: node.loc?.start.line,
        column: node.loc?.start.column,
      );
    }
    return results;
  }
}
