import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

Future<Map<String, dynamic>> evaluateFromPaths(
  Map<String, dynamic> fhirPaths,
  StructureDefinition structureDefinition,
  String type,
  String startPath,
  Map<String, dynamic> mapToValidate,
) async {
  var returnMap = <String, dynamic>{};

  // Remove resourceType as it's not in the StructureDefinition
  fhirPaths.removeWhere((key, value) => key.endsWith('.resourceType'));

  var fhirPathMatches = <String, FhirValidationObject>{};
  final elementDefinitions = structureDefinition.snapshot?.element;

  // Match FHIR paths to the element definitions in the structure definition
  fhirPathMatches = matchPaths(fhirPaths, elementDefinitions, fhirPathMatches);

  // Check the paths for compliance with the structure definition
  returnMap = await checkPaths(
      fhirPathMatches, startPath, fhirPaths, structureDefinition);

  // Build a map for partially matched paths
  final partialMatchMap =
      buildPartialMatchMap(fhirPathMatches, startPath, returnMap, fhirPaths);

  // Handle any partial matches found
  returnMap = await handlePartialMatches(
      partialMatchMap, elementDefinitions, returnMap, startPath, mapToValidate);

  // Check for required fields and their presence
  returnMap = checkRequiredFields(
      structureDefinition, fhirPaths, returnMap, startPath, type);

  return returnMap;
}
