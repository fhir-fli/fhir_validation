import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import '../fhir_validation.dart';

Future<ValidationResults> validateStructure({
  required Node node,
  required List<ElementDefinition> elements,
  required String type,
  Client? client,
}) async {
  var results = ValidationResults();

  if (node is! ObjectNode) {
    throw Exception('Root node must be an ObjectNode');
  }

  results = await _objectNode(node, type, type, elements, results, client);

  return results;
}

Future<ValidationResults> _traverseAst(
  Node node,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  if (node is ObjectNode) {
    return await _objectNode(
        node, originalPath, replacePath, elements, results, client);
  } else if (node is ArrayNode) {
    return await _arrayNode(
        node, originalPath, replacePath, elements, results, client);
  } else if (node is PropertyNode) {
    return await _propertyNode(
        node, originalPath, replacePath, elements, results, client);
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
  Client? client,
) async {
  for (var property in node.children) {
    results = await _propertyNode(
        property, originalPath, replacePath, elements, results, client);
  }
  return results;
}

Future<ValidationResults> _arrayNode(
  ArrayNode node,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  for (final child in node.children) {
    if (child is LiteralNode) {
      final cleanPath = cleanLocalPath(originalPath, replacePath, node.path);
      final element =
          elements.firstWhereOrNull((element) => element.path == cleanPath);
      if (element != null) {
        results = await _literalNode(child, element, results, client);
      } else {
        results.addResult(
          child,
          'Element not found in StructureDefinition - ${child.raw}',
          Severity.error,
        );
      }
    } else {
      results = await _traverseAst(
          child, originalPath, replacePath, elements, results, client);
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
  Client? client,
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
        node, element, originalPath, replacePath, elements, results, client);
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
    Client? client) async {
  final String? code = findCode(element, node.path);
  if (code != null) {
    return await _withCode(code, node, element, originalPath, replacePath,
        elements, results, client);
  } else {
    return await _withoutCode(
        node, element, originalPath, replacePath, results, client);
  }
}

Future<ValidationResults> _withoutCode(
  PropertyNode node,
  ElementDefinition element,
  String originalPath,
  String replacePath,
  ValidationResults results,
  Client? client,
) async {
  for (final ext in element.extension_ ?? <FhirExtension>[]) {
    final url = ext.url?.toString();
    if (url != null) {
      final structureDefinition = await getStructureDefinition(url, client);
      if (structureDefinition != null) {
        final newElements =
            extractElements(StructureDefinition.fromJson(structureDefinition));
        return await _traverseAst(
            node, originalPath, replacePath, newElements, results, client);
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
  Client? client,
) async {
  if (isPrimitiveType(code)) {
    return await _codeIsPrimitiveType(
        node, element, originalPath, replacePath, elements, results, client);
  } else {
    return await _codeIsComplexType(code, node, element, originalPath,
        replacePath, elements, results, client);
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
  Client? client,
) async {
  final structureDefinitionMap = await getStructureDefinition(code, client);
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
          node.value!, node.path, code, newElements, results, client);
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
  Client? client,
) async {
  if (node.value is LiteralNode) {
    return await _literalNode(
        node.value as LiteralNode, element, results, client);
  } else if (node.value is ArrayNode) {
    return await _arrayNode(node.value as ArrayNode, originalPath, replacePath,
        elements, results, client);
  } else {
    throw Exception(
        'Primitive element is not a Primitive or a List: ${node.value.runtimeType}');
  }
}

Future<ValidationResults> _literalNode(
  LiteralNode node,
  ElementDefinition element,
  ValidationResults results,
  Client? client,
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

  // Add additional value domain checks here
  results = await _checkEnumerations(element, value, results, node, client);
  results = _checkStringPatterns(element, value, results, node);
  results =
      _checkRangeConstraints(primitiveClass, element, value, results, node);
  results = _checkDateTimeFormats(primitiveClass, value, results, node);

  return results;
}

Future<ValidationResults> _checkEnumerations(
  ElementDefinition element,
  dynamic value,
  ValidationResults results,
  Node node,
  Client? client,
) async {
  if (element.binding != null &&
      element.binding!.strength == ElementDefinitionBindingStrength.required_ &&
      element.binding?.valueSet != null) {
    // Get the allowed codes from the value set
    final allowedCodes =
        await getValueSetCodes(element.binding!.valueSet.toString(), client);
    if (!allowedCodes.contains(value)) {
      results.addResult(
        node,
        'Value "$value" is not a valid code in the required value set.',
        Severity.error,
      );
    }
  }
  return results;
}

ValidationResults _checkStringPatterns(
  ElementDefinition element,
  dynamic value,
  ValidationResults results,
  Node node,
) {
  if (element.patternString != null && value is String) {
    final regex = RegExp(element.patternString!);
    if (!regex.hasMatch(value)) {
      results.addResult(
        node,
        'Value "$value" does not match the required pattern: ${element.patternString}',
        Severity.error,
      );
    }
  }
  return results;
}

ValidationResults _checkRangeConstraints(
  String? primitiveClass,
  ElementDefinition element,
  dynamic value,
  ValidationResults results,
  Node node,
) {
  if (primitiveClass == null || !isComparablePrimitive(primitiveClass)) {
    return results;
  }
  final minValue = _minimumValueConstraint(element);
  if (minValue != null && _compareValues(value, minValue) < 0) {
    results.addResult(
      node,
      'Value "$value" is less than the minimum allowed value: $minValue',
      Severity.error,
    );
  }

  final maxValue = _maximumValueConstraint(element);
  if (maxValue != null) {
    if (maxValue != null && _compareValues(value, maxValue) > 0) {
      results.addResult(
        node,
        'Value "$value" is greater than the maximum allowed value: $maxValue',
        Severity.error,
      );
    }
  }

  return results;
}

dynamic _minimumValueConstraint(ElementDefinition element) {
  if (element.minValueDate != null) return element.minValueDate;
  if (element.minValueDateTime != null) return element.minValueDateTime;
  if (element.minValueInstant != null) return element.minValueInstant;
  if (element.minValueTime != null) return element.minValueTime;
  if (element.minValueDecimal != null) return element.minValueDecimal;
  if (element.minValueInteger != null) return element.minValueInteger;
  if (element.minValuePositiveInt != null) return element.minValuePositiveInt;
  if (element.minValueUnsignedInt != null) return element.minValueUnsignedInt;
  if (element.minValueQuantity != null) return element.minValueQuantity;
  return null;
}

dynamic _maximumValueConstraint(ElementDefinition element) {
  if (element.maxValueDate != null) return element.maxValueDate;
  if (element.maxValueDateTime != null) return element.maxValueDateTime;
  if (element.maxValueInstant != null) return element.maxValueInstant;
  if (element.maxValueTime != null) return element.maxValueTime;
  if (element.maxValueDecimal != null) return element.maxValueDecimal;
  if (element.maxValueInteger != null) return element.maxValueInteger;
  if (element.maxValuePositiveInt != null) return element.maxValuePositiveInt;
  if (element.maxValueUnsignedInt != null) return element.maxValueUnsignedInt;
  if (element.maxValueQuantity != null) return element.maxValueQuantity;
  return null;
}

int _compareValues(dynamic value1, dynamic value2) {
  if (value1 is Comparable && value2 is Comparable) {
    return value1.compareTo(value2);
  }
  // Add more comparison logic as needed
  throw Exception('Unsupported value types for comparison');
}

ValidationResults _checkDateTimeFormats(
  String? primitiveClass,
  dynamic value,
  ValidationResults results,
  Node node,
) {
  if (primitiveClass != null &&
      (primitiveClass == 'date' ||
          primitiveClass == 'dateTime' ||
          primitiveClass == 'instant')) {
    try {
      // Attempt to parse the date/time value
      DateTime.parse(value);
    } catch (e) {
      results.addResult(
        node,
        'Value "$value" is not a valid $primitiveClass format.',
        Severity.error,
      );
    }
  }
  return results;
}
