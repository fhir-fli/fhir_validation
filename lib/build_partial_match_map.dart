import 'fhir_validation.dart';

/// Function to build a partial match map for FHIR validation.
/// It identifies paths in the resource that partially match paths in the structure definition.
Map<String, dynamic> buildPartialMatchMap(
  Map<String, FhirValidationObject>
      fhirPathMatches, // Map of FHIR paths to validation objects
  String startPath, // Starting path for validation
  ValidationResults results, // Map to store validation results
  Map<String, dynamic>
      fhirPaths, // Map of FHIR paths to their corresponding values
) {
  final partialMatchMap = <String, dynamic>{}; // Map to store partial matches

  // Iterate through each FHIR path match
  for (var key in fhirPathMatches.keys) {
    // Check if there is no full match for the element path
    if ((fhirPathMatches[key]?.fullMatch ?? '') == '') {
      // Determine the partial match path
      var partialMatch = (fhirPathMatches[key]!.partialMatch?.endsWith('[x]') ??
              false)
          ? fhirPathMatches[key]!.partialMatch!
          : key
              .split('.')
              .sublist(0, fhirPathMatches[key]!.partialMatch?.split('.').length)
              .join('.');
      if (partialMatch.endsWith('.')) {
        partialMatch = partialMatch.substring(0, partialMatch.length - 1);
      }
      if (partialMatch == startPath) {
        results.addResult(
            startPath,
            '$key',
            "Unrecognized property, '$key', not found in the StructureDefinition",
            Severity.error);
      } else {
        if (!partialMatchMap.containsKey(partialMatch)) {
          partialMatchMap[partialMatch] = <String, dynamic>{};
        }
        partialMatchMap[partialMatch][key] = fhirPaths[key];
      }
    }
  }

  // Return the partial match map
  return partialMatchMap;
}
