import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import '../fhir_validation.dart';

Future<ValidationResults> validateStructure({
  required Node node,
  required List<ElementDefinition> elements,
  required String type,
  String? url,
  Client? client,
}) async {
  if (node is! ObjectNode) {
    throw Exception('Root node must be an ObjectNode');
  }
  return await _objectNode(
      url, node, type, type, elements, ValidationResults(), client);
}

Future<ValidationResults> _traverseAst(
  String? url,
  Node node,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  if (node is ObjectNode) {
    return await _objectNode(
        url, node, originalPath, replacePath, elements, results, client);
  } else if (node is ArrayNode) {
    return await _arrayNode(
        url, node, originalPath, replacePath, elements, results, client);
  } else if (node is PropertyNode) {
    return await _propertyNode(
        url, node, originalPath, replacePath, elements, results, client);
  } else {
    throw Exception('Invalid node type: ${node.runtimeType} at ${node.path}');
  }
}

Future<ValidationResults> _objectNode(
  String? url,
  ObjectNode node,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  for (PropertyNode property in node.children) {
    results = await _propertyNode(
        url, property, originalPath, replacePath, elements, results, client);
  }

  final ElementDefinition? element =
      _findElementDefinitionFromNode(originalPath, replacePath, node, elements);
  if (element != null) {
    results = await validateInvariants(
      url: url,
      node: node,
      element: element,
      results: results,
      client: client,
    );
  }

  return results;
}

Future<ValidationResults> _arrayNode(
  String? url,
  ArrayNode node,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  for (final Node child in node.children) {
    if (child is LiteralNode) {
      final ElementDefinition? element = _findElementDefinitionFromNode(
          originalPath, replacePath, child, elements);
      if (element != null) {
        results = await _literalNode(url, child, element, results, client);
      } else {
        results.addResult(
          child,
          withUrlIfExists(
              'Element not found in StructureDefinition - ${child.raw}', url),
          Severity.error,
        );
      }
    } else {
      results = await _traverseAst(
          url, child, originalPath, replacePath, elements, results, client);
    }
  }

  return results;
}

Future<ValidationResults> _propertyNode(
  String? url,
  PropertyNode node,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  ElementDefinition? element =
      _findElementDefinitionFromNode(originalPath, replacePath, node, elements);

  if (_isAResourceType(node, element)) {
    return results;
  }

  if (element != null) {
    results = await _withElement(url, node, element, originalPath, replacePath,
        elements, results, client);
    results = await validateInvariants(
      url: url,
      node: node,
      element: element,
      results: results,
      client: client,
    );
  } else {
    results.addResult(
      node,
      withUrlIfExists('Element not found in StructureDefinition', url),
      Severity.error,
    );
  }

  return results;
}

Future<ValidationResults> _withElement(
  String? url,
  PropertyNode node,
  ElementDefinition element,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  final String? code = findCode(element, node.path);
  if (code != null) {
    return await _withCode(url, code, node, element, originalPath, replacePath,
        elements, results, client);
  } else {
    return await _withoutCode(
        url, node, element, originalPath, replacePath, results, client);
  }
}

Future<ValidationResults> _withoutCode(
  String? url,
  PropertyNode node,
  ElementDefinition element,
  String originalPath,
  String replacePath,
  ValidationResults results,
  Client? client,
) async {
  for (final FhirExtension ext in element.extension_ ?? <FhirExtension>[]) {
    final String? url = ext.url?.toString();
    if (url != null) {
      final Map<String, dynamic>? structureDefinition =
          await getResource(url, client);
      if (structureDefinition != null &&
          structureDefinition['resourceType'] == 'StructureDefinition') {
        final List<ElementDefinition> newElements =
            extractElements(StructureDefinition.fromJson(structureDefinition));
        return await _traverseAst(structureDefinition['url'] as String?, node,
            originalPath, replacePath, newElements, results, client);
      }
    }
  }
  return results
    ..addResult(
        node,
        withUrlIfExists('Element not found in StructureDefinition', url),
        Severity.error);
}

Future<ValidationResults> _withCode(
  String? url,
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
    return await _codeIsPrimitiveType(url, node, element, originalPath,
        replacePath, elements, results, client);
  } else {
    return await _codeIsComplexType(url, code, node, element, originalPath,
        replacePath, elements, results, client);
  }
}

Future<ValidationResults> _codeIsComplexType(
  String? url,
  String code,
  PropertyNode node,
  ElementDefinition element,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  final Map<String, dynamic>? structureDefinitionMap =
      await getResource(code, client);
  final StructureDefinition? structureDefinition =
      structureDefinitionMap != null &&
              structureDefinitionMap['resourceType'] == 'StructureDefinition'
          ? StructureDefinition.fromJson(structureDefinitionMap)
          : null;
  if (structureDefinition == null) {
    return _noStructureDefinitionOrProfile(url, code, node, results);
  }
  final List<ElementDefinition> newElements =
      extractElements(structureDefinition);
  if (newElements.isNotEmpty) {
    if (node.value != null) {
      return await _traverseAst(
          url, node.value!, node.path, code, newElements, results, client);
    } else {
      throw Exception('node is ${node.runtimeType} with null node.value');
    }
  } else {
    return _noStructureDefinitionOrProfile(url, code, node, results);
  }
}

ValidationResults _noStructureDefinitionOrProfile(
  String? url,
  String code,
  PropertyNode node,
  ValidationResults results,
) =>
    results
      ..addResult(
        node,
        withUrlIfExists(
            'No StructureDefinition or Profile found for Element type $code',
            url),
        Severity.error,
      );

Future<ValidationResults> _codeIsPrimitiveType(
  String? url,
  PropertyNode node,
  ElementDefinition element,
  String originalPath,
  String replacePath,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  if (node.value is LiteralNode) {
    results = await _literalNode(
        url, node.value as LiteralNode, element, results, client);
  } else if (node.value is ArrayNode) {
    results = await _arrayNode(url, node.value as ArrayNode, originalPath,
        replacePath, elements, results, client);
  } else {
    throw Exception(
        'Primitive element is not a Primitive or a List: ${node.value.runtimeType}');
  }
  return results;
}

Future<ValidationResults> _literalNode(
  String? url,
  LiteralNode node,
  ElementDefinition element,
  ValidationResults results,
  Client? client,
) async {
  final String? primitiveClass = findCode(element, node.path);
  final dynamic value = node.value;

  if (!isValueAValidPrimitive(primitiveClass.toString(), value)) {
    results.addResult(
      node,
      'Invalid value for primitive type: $primitiveClass',
      Severity.error,
    );
  }

  // Add additional value domain checks here
  results = await _checkEnumerations(element, value, results, node, client);
  results = _checkStringPatterns(url, element, value, results, node);
  results = _checkRangeConstraints(
      url, primitiveClass, element, value, results, node);
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
    final Set<String> allowedCodes =
        await getValueSetCodes(element.binding!.valueSet.toString(), client);
    if (!allowedCodes.contains(value)) {
      results.addResult(
        node,
        withUrlIfExists(
            'Value "$value" is not a valid code in the required value set.',
            element.binding!.valueSet.toString()),
        Severity.error,
      );
    }
  }
  return results;
}

ValidationResults _checkStringPatterns(
  String? url,
  ElementDefinition element,
  dynamic value,
  ValidationResults results,
  Node node,
) {
  if (element.patternString != null && value is String) {
    final RegExp regex = RegExp(element.patternString!);
    if (!regex.hasMatch(value)) {
      results.addResult(
        node,
        withUrlIfExists(
            'Value "$value" does not match the required pattern: ${element.patternString}',
            url),
        Severity.error,
      );
    }
  }
  return results;
}

ValidationResults _checkRangeConstraints(
  String? url,
  String? primitiveClass,
  ElementDefinition element,
  dynamic value,
  ValidationResults results,
  Node node,
) {
  if (primitiveClass == null || !isComparablePrimitive(primitiveClass)) {
    return results;
  }
  final dynamic minValue = _minimumValueConstraint(element);
  if (minValue != null && _compareValues(value, minValue) < 0) {
    results.addResult(
      node,
      withUrlIfExists(
          'Value "$value" is less than the minimum allowed value: $minValue',
          url),
      Severity.error,
    );
  }

  final dynamic maxValue = _maximumValueConstraint(element);
  if (maxValue != null && _compareValues(value, maxValue) > 0) {
    results.addResult(
      node,
      withUrlIfExists(
          'Value "$value" is greater than the maximum allowed value: $maxValue',
          url),
      Severity.error,
    );
  }

  return results;
}

dynamic _minimumValueConstraint(ElementDefinition element) {
  if (element.minValueDate != null) {
    return element.minValueDate;
  }
  if (element.minValueDateTime != null) {
    return element.minValueDateTime;
  }
  if (element.minValueInstant != null) {
    return element.minValueInstant;
  }
  if (element.minValueTime != null) {
    return element.minValueTime;
  }
  if (element.minValueDecimal != null) {
    return element.minValueDecimal;
  }
  if (element.minValueInteger != null) {
    return element.minValueInteger;
  }
  if (element.minValuePositiveInt != null) {
    return element.minValuePositiveInt;
  }
  if (element.minValueUnsignedInt != null) {
    return element.minValueUnsignedInt;
  }
  if (element.minValueQuantity != null) {
    return element.minValueQuantity;
  }
  return null;
}

dynamic _maximumValueConstraint(ElementDefinition element) {
  if (element.maxValueDate != null) {
    return element.maxValueDate;
  }
  if (element.maxValueDateTime != null) {
    return element.maxValueDateTime;
  }
  if (element.maxValueInstant != null) {
    return element.maxValueInstant;
  }
  if (element.maxValueTime != null) {
    return element.maxValueTime;
  }
  if (element.maxValueDecimal != null) {
    return element.maxValueDecimal;
  }
  if (element.maxValueInteger != null) {
    return element.maxValueInteger;
  }
  if (element.maxValuePositiveInt != null) {
    return element.maxValuePositiveInt;
  }
  if (element.maxValueUnsignedInt != null) {
    return element.maxValueUnsignedInt;
  }
  if (element.maxValueQuantity != null) {
    return element.maxValueQuantity;
  }
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
      if (value is! String) {
        results.addResult(
          node,
          'Value "$value" is not a valid $primitiveClass format.',
          Severity.error,
        );
      } else {
        DateTime.parse(value);
      }
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

bool _isAResourceType(PropertyNode node, ElementDefinition? element) =>
    element == null &&
    node.value is LiteralNode &&
    node.key?.value == 'resourceType' &&
    R4ResourceType.typesAsStrings.contains((node.value as LiteralNode).value);

ElementDefinition? _polymorphicElement(
    String path, List<ElementDefinition> elements) {
  return elements.firstWhereOrNull((ElementDefinition element) =>
      element.path != null &&
      element.path!.endsWith('[x]') &&
      path.startsWith(element.path!.replaceFirst('[x]', '')));
}

ElementDefinition? _findElementDefinitionFromNode(String originalPath,
    String replacePath, Node node, List<ElementDefinition> elements) {
  final String cleanPath = cleanLocalPath(originalPath, replacePath, node.path);
  return elements.firstWhereOrNull(
          (ElementDefinition element) => element.path == cleanPath) ??
      _polymorphicElement(cleanPath, elements);
}
