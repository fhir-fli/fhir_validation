import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

Future<Map<String, dynamic>> validateFhirMaps({
  required Map<String, dynamic> mapToValidate,
  required StructureDefinition structureDefinition,
  required String type,
  required String startPath,
}) async {
  // Create a list of all paths in the mapToValidate
  final fhirPaths = fhirPathsFromMap(value: mapToValidate, path: type);
  // Evaluate the resource based on the generated paths and structure definition
  final returnMap = await evaluateFromPaths(
      fhirPaths, structureDefinition, type, startPath, mapToValidate);

  return returnMap;
}
