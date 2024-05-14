import 'fhir_validation.dart';

Map<String, dynamic> buildPartialMatchMap(
  Map<String, FhirValidationObject> fhirPathMatches,
  String startPath,
  Map<String, List<String>?> returnMap,
  Map<String, dynamic> fhirPaths,
) {
  final partialMatchMap = <String, dynamic>{};

  for (var key in fhirPathMatches.keys) {
    if ((fhirPathMatches[key]?.fullMatch ?? '') == '') {
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
        if (!returnMap.containsKey(key)) {
          returnMap[key] = <String>[];
        }
        returnMap[key]!.add(
            "Unrecognized property, '$key', not found in the StructureDefinition");
      } else {
        if (!partialMatchMap.containsKey(partialMatch)) {
          partialMatchMap[partialMatch] = <String, dynamic>{};
        }
        partialMatchMap[partialMatch][key] = fhirPaths[key];
      }
    }
  }

  return partialMatchMap;
}
