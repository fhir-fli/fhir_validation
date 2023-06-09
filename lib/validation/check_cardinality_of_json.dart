part of 'validate.dart';

Map<String, List<String>?> checkMaxCardinalityOfJson(
  ElementDefinition elementDefinition,
  String key,
  Map<String, List<String>?> returnMap,
  String startPath,
  Map<String, dynamic> fhirPaths,
  FhirValidationObject? fhirValidationObject,
) {
  /// Since we're looking to see if the Resource matches the
  /// StructureDefinition here, we check that max is NOT null, and that if
  /// it's either * (unlimited) or an integer > 1, then this field should be
  /// a list, this is also true if (on the future occasion, as I don't think
  /// there are any fields like this currently), the minimum cardinality
  /// is greater than 1
  if ((elementDefinition.max != null &&
          (elementDefinition.max == '*' ||
              ((int.tryParse(elementDefinition.max!) ?? 0) > 1))) ||
      (elementDefinition.min != null &&
          (elementDefinition.min?.value ?? 0) > 1)) {
    /// If the field is not a list - mostly just for safety, we really
    /// shouldn't have any lists at this point since we already parsed them
    /// all out using indexes
    if (fhirPaths[key] is! List) {
      final maybeIndex = pathIndexIfAvailable(key);

      /// if maybeIndex == null, it's not a list, or indexed, so this is
      /// an error
      if (maybeIndex == null) {
        returnMap = addToMap(
            returnMap,
            startPath,
            key,
            'This path is not a list (or one of a list), although it should be. '
            'Minimum Cardinality: ${elementDefinition.min ?? "none defined"}. '
            'Maximum Cardinality: ${elementDefinition.max ?? "none defined"}');

        /// If instead it is just indexed, and there's a maximum Cardinality
        /// and we've exceeded it, another error, make note
      } else if (elementDefinition.max != '*' &&
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
      /// Then, only if it's a List, we check and see that we are under the
      /// maximum Cardinality allowed
      if (elementDefinition.max != null &&
          elementDefinition.max != '*' &&
          int.tryParse(elementDefinition.max!) != null) {
        if (fhirPaths[key].length > int.parse(elementDefinition.max!)) {
          returnMap = addToMap(
              returnMap,
              startPath,
              key,
              'The value at this path has more items than is allowed. '
              'Maximum Cardinality: ${elementDefinition.max ?? "none defined"}'
              'Item number in this list: ${fhirPaths[key].length}');
        }
      }
    }
  }

  /// The other option is if this is a list (or indexed) but it's not allowed
  /// more than a single value
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

String notArrayMessage(FhirValidationObject? fhirValidationObject,
        ElementDefinition elementDefinition) =>
    'This property must be a ${fhirValidationObject?.type}, not an Array. '
    'Cardinality: ${elementDefinition.min ?? "none defined"}..${elementDefinition.max ?? "none defined"}';
