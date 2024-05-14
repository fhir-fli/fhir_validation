import 'package:fhir_r4/fhir_r4.dart';

import 'fhir_validation.dart';

Future<Map<String, List<String>?>> validateFhirMaps({
  required Map<String, dynamic> mapToValidate,
  required StructureDefinition structureDefinition,
  required String type,
  required String startPath,
  bool online = true,
}) async {
  /// Create a list of all paths in the [mapToValidate]
  final fhirPaths = fhirPathsFromMap(value: mapToValidate, path: type);
  final returnMap = await evaluateFromPaths(
      fhirPaths, structureDefinition, type, startPath, online, mapToValidate);

  return returnMap;
}
