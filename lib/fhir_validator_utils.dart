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
    // print('traverse: ${node.path}');
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
    // print('object: ${node.path}');
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
    // print('array: ${node.path}');
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
      ValidationResults results) async {
    // print('property: ${node.path}');
    final cleanLocalPath =
        _cleanLocalPath(originalPath, replacePath, node.path);
    ElementDefinition? element =
        elements.firstWhereOrNull((element) => element.path == cleanLocalPath);

    // If the element is null, but the key is "resourceType" and the value is
    // a valid resourceType, then this is a valid entry, although it's not
    // in the structure maps
    if (_isAResourceType(node, element)) {
      return results;
    }

    element ??= _polymorphicElement(cleanLocalPath, elements);

    if (element != null) {
      return await _withElement(
          node, element, originalPath, replacePath, elements, results);
    }
    // if we aren't able to find it in the elements, we should add it to the
    // ValidationResults as an error, and won't go looking for anything else
    else {
      return results
        ..addResult(
          node,
          'Element not found in StructureDefinition',
          Severity.error,
        );
    }
  }

  Future<ValidationResults> _withElement(
      PropertyNode node,
      ElementDefinition element,
      String originalPath,
      String replacePath,
      List<ElementDefinition> elements,
      ValidationResults results) async {
    // We get the code from the StructureDefinition to determine if it's
    // a primitive type

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
      ValidationResults results) async {
    final extension = element.extension_;
    for (final ext in extension ?? <FhirExtension>[]) {
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
    return results
      ..addResult(
        node,
        element.toJson().toString(),
        Severity.error,
      );
  }

  Future<ValidationResults> _withCode(
      String code,
      PropertyNode node,
      ElementDefinition element,
      String originalPath,
      String replacePath,
      List<ElementDefinition> elements,
      ValidationResults results) async {
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
      ValidationResults results) async {
    // If not, then it's not a primitive structure, and we will need
    // to find a separate StructureDefinition or Profile to validate
    // the object.
    final structureDefinitionMap = await getStructureDefinition(code);
    final StructureDefinition? structureDefinition =
        structureDefinitionMap != null
            ? StructureDefinition.fromJson(structureDefinitionMap)
            : null;
    if (structureDefinition == null) {
      return _noStructureDefinitionOrProfile(code, node, results);
    }
    final newElements = extractElements(structureDefinition);
    // If we find the StructureDefinition, we should traverse the AST
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
          String code, PropertyNode node, ValidationResults results) =>
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
      ValidationResults results) async {
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

  Future<ValidationResults> _literalNode(LiteralNode node,
      ElementDefinition element, ValidationResults results) async {
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

  String? _findCode(ElementDefinition element, String path) {
    String? code;
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
        code = element.type!
            .firstWhereOrNull((t) => t.code?.toString().toLowerCase() == type)
            ?.code
            ?.toString();
        return code;
      }
    }
    return null;
  }
}
