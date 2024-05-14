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

  print('After removing resourceType: $fhirPaths');

  var fhirPathMatches = <String, FhirValidationObject>{};
  final elementDefinitions = structureDefinition.snapshot?.element;

  fhirPathMatches = matchPaths(fhirPaths, elementDefinitions, fhirPathMatches);
  print('After matchPaths: $fhirPathMatches');

  returnMap = await checkPaths(
      fhirPathMatches, startPath, fhirPaths, structureDefinition);
  print('After checkPaths: $returnMap');

  final partialMatchMap =
      buildPartialMatchMap(fhirPathMatches, startPath, returnMap, fhirPaths);
  print('After buildPartialMatchMap: $partialMatchMap');

  returnMap = await handlePartialMatches(
      partialMatchMap, elementDefinitions, returnMap, startPath, mapToValidate);
  print('After handlePartialMatches: $returnMap');

  returnMap = checkRequiredFields(
      structureDefinition, fhirPaths, returnMap, startPath, type);
  print('After checkRequiredFields: $returnMap');

  return returnMap;
}
