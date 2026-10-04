import 'package:collection/collection.dart';
import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_validation/fhir_validation.dart';

/// Validates the structure of a FHIR resource against a given
/// StructureDefinition.
///
/// Starts from the root node and traverses its structure recursively,
/// ensuring it matches the constraints defined in the provided [elements].
Future<ValidationResults> validateStructure({
  required ValidationModel<FhirNode> model,
  required ObjectNode node,
  required Map<String, ElementNode> elements,
  required String type,
  String? url,
  required ResourceCache resourceCache,
}) async {
  return _objectNode(
    _Run(model, resourceCache),
    url,
    node,
    type,
    type,
    elements,
    ValidationResults(),
  );
}

/// What every step of one validation run shares: the version's model and
/// the cache definitions are read from.
class _Run {
  const _Run(this.model, this.resourceCache);

  final ValidationModel<FhirNode> model;
  final ResourceCache resourceCache;
}

/// Recursively traverses the Abstract Syntax Tree (AST) of a FHIR resource.
///
/// Determines the type of [Node] (ObjectNode, ArrayNode, or PropertyNode) and
/// routes validation to the appropriate handler function.
///
/// Throws an exception for unsupported or invalid node types.
Future<ValidationResults> _traverseAst(
  _Run run,
  String? url,
  Node node,
  String originalPath,
  String replacePath,
  Map<String, ElementNode> elements,
  ValidationResults results,
) async {
  if (node is ObjectNode) {
    return _objectNode(
      run,
      url,
      node,
      originalPath,
      replacePath,
      elements,
      results,
    );
  } else if (node is ArrayNode) {
    return _arrayNode(
      run,
      url,
      node,
      originalPath,
      replacePath,
      elements,
      results,
    );
  } else if (node is PropertyNode) {
    return _propertyNode(
      run,
      url,
      node,
      originalPath,
      replacePath,
      elements,
      results,
    );
  } else {
    throw Exception('Invalid node type: ${node.runtimeType} at ${node.path}');
  }
}

/// Validates the structure of an ObjectNode.
///
/// Iterates through all child properties and validates each one using
/// `_propertyNode`. Additionally, validates invariants defined for the
/// current [ElementDefinition].
Future<ValidationResults> _objectNode(
  _Run run,
  String? url,
  ObjectNode node,
  String originalPath,
  String replacePath,
  Map<String, ElementNode> elements,
  ValidationResults results,
) async {
  var newResults = results.copyWith();

  // Process each child property of the ObjectNode.
  for (final property in node.children) {
    newResults = await _propertyNode(
      run,
      url,
      property,
      originalPath,
      replacePath,
      elements,
      newResults,
    );
  }

  // Validate invariants for the current node, if applicable.
  final element = _findElementDefinitionFromNode(
    originalPath,
    replacePath,
    node,
    elements,
  );
  if (element != null) {
    newResults = await validateInvariants(
      model: run.model,
      url: url,
      node: node,
      element: element,
      results: newResults,
      resourceCache: run.resourceCache,
    );
  }

  return newResults;
}

/// Validates the structure of an ArrayNode.
///
/// Iterates through all child nodes in the array, validating each one
/// either as a LiteralNode or by recursively traversing its structure.
Future<ValidationResults> _arrayNode(
  _Run run,
  String? url,
  ArrayNode node,
  String originalPath,
  String replacePath,
  Map<String, ElementNode> elements,
  ValidationResults results,
) async {
  var newResults = results.copyWith();

  for (final child in node.children) {
    if (child is LiteralNode) {
      // Handle literal values within the array.
      final element = _findElementDefinitionFromNode(
        originalPath,
        replacePath,
        child,
        elements,
      );
      if (element != null) {
        newResults = await _literalNode(run, url, child, element, newResults);
      } else {
        // Report an error if no matching element definition is found.
        newResults.addResult(
          child,
          withUrlIfExists(
            'Element not found in StructureDefinition - ${child.raw}',
            url,
          ),
          Severity.error,
        );
      }
    } else {
      // Recursively traverse the AST for non-literal child nodes.
      newResults = await _traverseAst(
        run,
        url,
        child,
        originalPath,
        replacePath,
        elements,
        newResults,
      );
    }
  }

  return newResults;
}

/// Validates a PropertyNode by checking its corresponding element definition.
///
/// If the node represents a known resource type, it skips further validation.
/// Otherwise, it validates the node using the appropriate element definition.
Future<ValidationResults> _propertyNode(
  _Run run,
  String? url,
  PropertyNode node,
  String originalPath,
  String replacePath,
  Map<String, ElementNode> elements,
  ValidationResults results,
) async {
  var newResults = results.copyWith();

  // Attempt to find the matching element definition for this node.
  final element = _findElementDefinitionFromNode(
    originalPath,
    replacePath,
    node,
    elements,
  );

  // Skip validation if the node represents a resource type.
  if (_isAResourceType(run, node, element)) {
    return newResults;
  }

  // Validate the node if a matching element is found.
  if (element != null) {
    newResults = await _withElement(
      run,
      url,
      node,
      element,
      originalPath,
      replacePath,
      elements,
      newResults,
    );

    // Validate invariants defined for the element.
    newResults = await validateInvariants(
      model: run.model,
      url: url,
      node: node,
      element: element,
      results: newResults,
      resourceCache: run.resourceCache,
    );
  } else {
    // Add an error if no matching element is found.
    newResults.addResult(
      node,
      withUrlIfExists('Element not found in StructureDefinition', url),
      Severity.error,
    );
  }

  return newResults;
}

/// Handles a PropertyNode that has a corresponding element definition.
///
/// If the element definition includes a `code`, the function delegates
/// validation based on whether the code represents a primitive or complex type.
Future<ValidationResults> _withElement(
  _Run run,
  String? url,
  PropertyNode node,
  ElementNode element,
  String originalPath,
  String replacePath,
  Map<String, ElementNode> elements,
  ValidationResults results,
) async {
  final code = findCode(element, node.path);

  // If the element has a defined type code, validate accordingly.
  if (code != null) {
    return _withCode(
      run,
      url,
      code,
      node,
      element,
      originalPath,
      replacePath,
      elements,
      results,
    );
  } else {
    // Handle cases where the element has no specific type code.
    return _withoutCode(
      run,
      url,
      node,
      element,
      originalPath,
      replacePath,
      results,
    );
  }
}

/// Handles elements without a defined type code by checking for extensions.
///
/// If the element has extensions, it fetches the associated StructureDefinition
/// and validates the node recursively using the new element definitions.
Future<ValidationResults> _withoutCode(
  _Run run,
  String? url,
  PropertyNode node,
  ElementNode element,
  String originalPath,
  String replacePath,
  ValidationResults results,
) async {
  for (final url in element.extensionUrls) {
    final structureDefinition = await run.resourceCache.getStructureDefinition(
      url,
    );

    // If the extension references a StructureDefinition, extract elements
    //and validate.
    if (structureDefinition != null) {
      final newElements = extractElements(structureDefinition);

      return _traverseAst(
        run,
        structureDefinition.getChildByName('url')?.primitiveValue,
        node,
        originalPath,
        replacePath,
        newElements,
        results,
      );
    }
  }

  // Add an error if no valid structure is found for the element.
  return results..addResult(
    node,
    withUrlIfExists('Element not found in StructureDefinition', url),
    Severity.error,
  );
}

/// Handles elements with a defined type code.
///
/// If the code represents a primitive type, validates its value directly.
/// Otherwise, delegates validation to `_codeIsComplexType` for complex types.
Future<ValidationResults> _withCode(
  _Run run,
  String? url,
  String code,
  PropertyNode node,
  ElementNode element,
  String originalPath,
  String replacePath,
  Map<String, ElementNode> elements,
  ValidationResults results,
) async {
  if (isPrimitiveType(code)) {
    return _codeIsPrimitiveType(
      run,
      url,
      node,
      element,
      originalPath,
      replacePath,
      elements,
      results,
    );
  } else {
    return _codeIsComplexType(
      run,
      url,
      code,
      node,
      element,
      originalPath,
      replacePath,
      elements,
      results,
    );
  }
}

/// Handles validation for complex types by fetching their StructureDefinition.
///
/// If the StructureDefinition is found, it extracts new element definitions
/// and validates the node recursively.
Future<ValidationResults> _codeIsComplexType(
  _Run run,
  String? url,
  String code,
  PropertyNode node,
  ElementNode element,
  String originalPath,
  String replacePath,
  Map<String, ElementNode> elements,
  ValidationResults results,
) async {
  final structureDefinition = await run.resourceCache.getStructureDefinition(
    code,
  );

  // Handle cases where the StructureDefinition is missing.
  if (structureDefinition == null) {
    return _noStructureDefinitionOrProfile(url, code, node, results);
  }

  // Extract elements from the StructureDefinition and validate recursively.
  final newElements = extractElements(structureDefinition);
  if (newElements.isNotEmpty) {
    if (node.value != null) {
      return _traverseAst(
        run,
        url,
        node.value!,
        node.path,
        code,
        newElements,
        results,
      );
    } else {
      throw Exception('node is ${node.runtimeType} with null node.value');
    }
  } else {
    return _noStructureDefinitionOrProfile(url, code, node, results);
  }
}

/// Adds an error for missing StructureDefinition or Profile for a complex type.
ValidationResults _noStructureDefinitionOrProfile(
  String? url,
  String code,
  PropertyNode node,
  ValidationResults results,
) =>
    results..addResult(
      node,
      withUrlIfExists(
        'No StructureDefinition or Profile found for Element type $code',
        url,
      ),
      Severity.error,
    );

/// Validates the value of a primitive type node.
///
/// Checks whether the value conforms to the constraints of the corresponding
/// primitive type and ensures that it matches required patterns or ranges.
Future<ValidationResults> _codeIsPrimitiveType(
  _Run run,
  String? url,
  PropertyNode node,
  ElementNode element,
  String originalPath,
  String replacePath,
  Map<String, ElementNode> elements,
  ValidationResults results,
) async {
  var newResults = results.copyWith();

  // If the node contains a literal value, validate it directly.
  if (node.value is LiteralNode) {
    newResults = await _literalNode(
      run,
      url,
      node.value! as LiteralNode,
      element,
      newResults,
    );
  } else if (node.value is ArrayNode) {
    // Handle cases where the node contains an array of values.
    newResults = await _arrayNode(
      run,
      url,
      node.value! as ArrayNode,
      originalPath,
      replacePath,
      elements,
      newResults,
    );
  } else {
    throw Exception(
      'Primitive element is not a Primitive or a List: '
      '${node.value.runtimeType}',
    );
  }

  return newResults;
}

/// Validates the value of a LiteralNode against its ElementDefinition.
///
/// Checks if the value matches the constraints defined for the corresponding
/// primitive type, such as valid enumerations, patterns, ranges, or date
/// formats.
Future<ValidationResults> _literalNode(
  _Run run,
  String? url,
  LiteralNode node,
  ElementNode element,
  ValidationResults results,
) async {
  final primitiveClass = findCode(element, node.path);
  final dynamic value = node.value;

  // Validate the value against the primitive type.
  if (!run.model.isValidPrimitive(primitiveClass.toString(), value)) {
    results.addResult(
      node,
      'Invalid value for primitive type: $primitiveClass',
      Severity.error,
    );
  }

  // Perform additional domain-specific checks.
  var newResults = await _checkEnumerations(run, element, value, results, node);
  newResults = _checkStringPatterns(url, element, value, newResults, node);
  newResults = _checkRangeConstraints(
    url,
    primitiveClass,
    element,
    value,
    newResults,
    node,
  );
  newResults = _checkDateTimeFormats(primitiveClass, value, newResults, node);

  return newResults;
}

/// Validates that a value matches the enumerations defined in the element's
/// binding.
///
/// Ensures the value is part of a required ValueSet if applicable.
Future<ValidationResults> _checkEnumerations(
  _Run run,
  ElementNode element,
  dynamic value,
  ValidationResults results,
  Node node,
) async {
  final binding = element.binding;
  final valueSet = binding?.valueSet;
  if (binding != null && binding.strength == 'required' && valueSet != null) {
    // Fetch the allowed codes from the specified ValueSet.
    final allowedCodes = await getValueSetCodes(valueSet, run.resourceCache);
    if (!allowedCodes.contains(value)) {
      results.addResult(
        node,
        withUrlIfExists(
          'Value "$value" is not a valid code in the required value set.',
          valueSet,
        ),
        Severity.error,
      );
    }
  }
  return results;
}

/// Validates that a string value matches the specified regular expression
/// pattern.
///
/// Checks if the value adheres to the pattern defined in the element's
/// `pattern[x]`.
ValidationResults _checkStringPatterns(
  String? url,
  ElementNode element,
  dynamic value,
  ValidationResults results,
  Node node,
) {
  final pattern = element.patternString;
  if (pattern != null && value is String) {
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      results.addResult(
        node,
        withUrlIfExists(
          'Value "$value" does not match the required pattern: $pattern',
          url,
        ),
        Severity.error,
      );
    }
  }
  return results;
}

/// Validates that a numeric or comparable value falls within a specified range.
///
/// Checks if the value satisfies the `minValue[x]` and `maxValue[x]`
/// constraints.
ValidationResults _checkRangeConstraints(
  String? url,
  String? primitiveClass,
  ElementNode element,
  dynamic value,
  ValidationResults results,
  Node node,
) {
  if (primitiveClass == null || !isComparablePrimitive(primitiveClass)) {
    return results;
  }

  // Check the minimum value constraint.
  final dynamic minValue = _minimumValueConstraint(element);
  if (minValue != null && _compareValues(value, minValue) < 0) {
    results.addResult(
      node,
      withUrlIfExists(
        'Value "$value" is less than the minimum allowed value: $minValue',
        url,
      ),
      Severity.error,
    );
  }

  // Check the maximum value constraint.
  final dynamic maxValue = _maximumValueConstraint(element);
  if (maxValue != null && _compareValues(value, maxValue) > 0) {
    results.addResult(
      node,
      withUrlIfExists(
        'Value "$value" is greater than the maximum allowed value: $maxValue',
        url,
      ),
      Severity.error,
    );
  }

  return results;
}

/// Retrieves the minimum value constraint from an ElementDefinition.
dynamic _minimumValueConstraint(ElementNode element) {
  return element.minValue;
}

/// Retrieves the maximum value constraint from an ElementDefinition.
dynamic _maximumValueConstraint(ElementNode element) {
  return element.maxValue;
}

/// Compares two values and determines their ordering.
///
/// A constraint arrives as the definition's text; the value as the JSON
/// scalar. Both are compared as numbers when both parse as one, else as
/// their text (dates and times sort as text in FHIR's formats).
///
/// Returns:
/// - A negative number if `value1` is less than `value2`.
/// - Zero if `value1` equals `value2`.
/// - A positive number if `value1` is greater than `value2`.
int _compareValues(dynamic value1, dynamic value2) {
  final n1 = value1 is num ? value1 : num.tryParse(value1.toString());
  final n2 = value2 is num ? value2 : num.tryParse(value2.toString());
  if (n1 != null && n2 != null) return n1.compareTo(n2);
  if (value1 is Comparable && value2 is Comparable) {
    return value1.toString().compareTo(value2.toString());
  }
  throw Exception('Unsupported value types for comparison');
}

/// Validates that a date or time value matches the expected format.
///
/// Ensures the value is correctly formatted for `date`, `dateTime`, or
/// `instant`.
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
      if (value is! String) {
        results.addResult(
          node,
          'Value "$value" is not a valid $primitiveClass format.',
          Severity.error,
        );
      } else {
        DateTime.parse(value);
      }
    } on FormatException catch (_) {
      results.addResult(
        node,
        'Value "$value" is not a valid $primitiveClass format.',
        Severity.error,
      );
    }
  }
  return results;
}

/// Determines if a node represents a resource type.
///
/// Checks if the node is a PropertyNode with a `resourceType` key matching
/// known types.
bool _isAResourceType(_Run run, PropertyNode node, ElementNode? element) =>
    element == null &&
    node.value is LiteralNode &&
    node.key?.value == 'resourceType' &&
    run.model.resourceTypeNames.contains((node.value! as LiteralNode).value);

/// Finds a polymorphic element definition that matches a given path.
///
/// Polymorphic elements end with `[x]` and can match multiple data types.
ElementNode? _polymorphicElement(
  String path,
  Map<String, ElementNode> elements,
) {
  return elements.values.firstWhereOrNull(
    (element) =>
        element.path.endsWith('[x]') &&
        path.startsWith(element.path.replaceFirst('[x]', '')),
  );
}

/// Finds the element definition corresponding to a node.
///
/// Cleans the node path and matches it with known element definitions,
/// including polymorphic elements if necessary.
ElementNode? _findElementDefinitionFromNode(
  String originalPath,
  String replacePath,
  Node node,
  Map<String, ElementNode> elements,
) {
  final cleanPath = cleanLocalPath(originalPath, replacePath, node.path);
  return elements[cleanPath] ?? _polymorphicElement(cleanPath, elements);
}
