import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

Future<Map<String, List<String>?>> evaluateFromPaths(
  Map<String, dynamic> fhirPaths,
  StructureDefinition structureDefinition,
  String type,
  String startPath,
  Map<String, dynamic> mapToValidate,
) async {
  var returnMap = <String, List<String>?>{};

  // Remove resourceType as it's not in the StructureDefinition
  fhirPaths.removeWhere((key, value) => key.endsWith('.resourceType'));

  var fhirPathMatches = <String, FhirValidationObject>{};
  final elementDefinitions = structureDefinition.snapshot?.element;

  fhirPathMatches = matchPaths(fhirPaths, elementDefinitions, fhirPathMatches);
  returnMap = await checkPaths(
      fhirPathMatches, startPath, fhirPaths, structureDefinition);

  final partialMatchMap =
      buildPartialMatchMap(fhirPathMatches, startPath, returnMap, fhirPaths);
  returnMap = await handlePartialMatches(
      partialMatchMap, elementDefinitions, returnMap, startPath, mapToValidate);

  returnMap = checkRequiredFields(
      structureDefinition, fhirPaths, returnMap, startPath, type);

  return returnMap;
}
