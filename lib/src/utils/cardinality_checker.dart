import 'package:fhir_r4/fhir_r4.dart';

/// Checks the maximum cardinality of a given JSON element and updates the
/// returnMap with validation errors if the cardinality rules are violated.
Map<String, List<String>?> checkMaxCardinalityOfJson(
  ElementDefinition elementDefinition,
  String key,
  Map<String, List<String>?> returnMap,
  String startPath,
  Map<String, dynamic> fhirPaths,
  FhirValidationObject? fhirValidationObject,
) {
  // Check if the maximum cardinality is specified and greater than 1 or unlimited (*)
  // Also check if the minimum cardinality is greater than 1
  if ((elementDefinition.max != null &&
          (elementDefinition.max == '*' ||
              ((int.tryParse(elementDefinition.max!) ?? 0) > 1))) ||
      (elementDefinition.min != null &&
          (elementDefinition.min?.value ?? 0) > 1)) {
    // If the field is not a list, it indicates an error
    if (fhirPaths[key] is! List) {
      final maybeIndex = pathIndexIfAvailable(key);

      // If maybeIndex is null, it's not a list or indexed, so this is an error
      if (maybeIndex == null) {
        returnMap = addToMap(
            returnMap,
            startPath,
            key,
            'This path is not a list (or one of a list), although it should be. '
            'Minimum Cardinality: ${elementDefinition.min ?? "none defined"}. '
            'Maximum Cardinality: ${elementDefinition.max ?? "none defined"}');
      }
      // If it is indexed and exceeds the maximum cardinality, it's an error
      else if (elementDefinition.max != '*' &&
          maybeIndex >= int.parse(elementDefinition.max!)) {
        returnMap = addToMap(
            returnMap,
            startPath,
            key,
            'The value at this path does not match the Maximum Cardinality for this field. '
            'Minimum Cardinality: ${elementDefinition.min ?? "none defined"}. '
            'Number of items or index in this list: '
            '${fhirPaths[key] is List ? fhirPaths[key].length : maybeIndex}');
      }
    } else {
      // If it is a list, check if it exceeds the maximum cardinality allowed
      if (elementDefinition.max != null &&
          elementDefinition.max != '*' &&
          int.tryParse(elementDefinition.max!) != null) {
        if (fhirPaths[key].length > int.parse(elementDefinition.max!)) {
          returnMap = addToMap(
              returnMap,
              startPath,
              key,
              'The value at this path has more items than is allowed. '
              'Maximum Cardinality: ${elementDefinition.max ?? "none defined"}. '
              'Item number in this list: ${fhirPaths[key].length}');
        }
      }
    }
  }
  // If the maximum cardinality is 1, ensure the field is not a list
  else if (elementDefinition.max != null &&
      elementDefinition.max != '*' &&
      (int.tryParse(elementDefinition.max!) ?? 0) == 1) {
    if (fhirPaths[key] is List) {
      returnMap = addToMap(returnMap, startPath, key,
          notArrayMessage(fhirValidationObject, elementDefinition));
    } else {
      final maybeIndex = pathIndexIfAvailable(key);
      if (maybeIndex != null) {
        returnMap = addToMap(returnMap, startPath, key,
            notArrayMessage(fhirValidationObject, elementDefinition));
      }
    }
  }
  return returnMap;
}

/// Generates an error message indicating that the property should not be an array.
String notArrayMessage(FhirValidationObject? fhirValidationObject,
        ElementDefinition elementDefinition) =>
    'This property must be a ${fhirValidationObject?.type}, not an Array. '
    'Cardinality: ${elementDefinition.min ?? "none defined"}..${elementDefinition.max ?? "none defined"}';
