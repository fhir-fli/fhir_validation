import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import '../fhir_validation.dart';

Future<ValidationResults> validateStructure({
  required Node node,
  required List<ElementDefinition> elements,
  required String type,
}) async {
  var results = ValidationResults();

  if (node is! ObjectNode) {
    throw Exception('Root node must be an ObjectNode');
  }

  results = await _objectNode(node, type, type, elements, results);

  return results;
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
    return await _arrayNode(node, originalPath, replacePath, elements, results);
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
      final cleanPath = cleanLocalPath(originalPath, replacePath, node.path);
      final element =
          elements.firstWhereOrNull((element) => element.path == cleanPath);
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
  final cleanPath = cleanLocalPath(originalPath, replacePath, node.path);
  ElementDefinition? element =
      elements.firstWhereOrNull((element) => element.path == cleanPath);

  if (isAResourceType(node, element)) {
    return results;
  }

  element ??= polymorphicElement(cleanPath, elements);

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
  final String? code = findCode(element, node.path);
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
        final newElements =
            extractElements(StructureDefinition.fromJson(structureDefinition));
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
    return await _arrayNode(
        node.value as ArrayNode, originalPath, replacePath, elements, results);
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
  final primitiveClass = findCode(element, node.path);
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
