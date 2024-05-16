// import 'package:fhir_r4/fhir_r4.dart';
// import 'package:fhir_validation/fhir_validation.dart';

// Future<ValidationResults> evaluateFromPaths(
//   Map<String, dynamic> fhirPaths,
//   StructureDefinition structureDefinition,
//   String type,
//   String startPath,
//   Map<String, dynamic> mapToValidate,
//   Node? astNode, // Added AST node parameter
// ) async {
//   var results = ValidationResults();

//   // Remove resourceType as it's not in the StructureDefinition
//   fhirPaths.removeWhere((key, value) => key.endsWith('.resourceType'));

//   var fhirPathMatches = <String, FhirValidationObject>{};
//   final elementDefinitions = structureDefinition.snapshot?.element;

//   // Match FHIR paths to the element definitions in the structure definition
//   fhirPathMatches = matchPaths(fhirPaths, elementDefinitions, fhirPathMatches);

//   // Check the paths for compliance with the structure definition
//   results = await checkPaths(
//       fhirPathMatches, startPath, fhirPaths, structureDefinition);

//   // Build a map for partially matched paths
//   final partialMatchMap =
//       buildPartialMatchMap(fhirPathMatches, startPath, results, fhirPaths);

//   // Handle any partial matches found
//   results = await handlePartialMatches(partialMatchMap, elementDefinitions,
//       results, startPath, mapToValidate, astNode);

//   // Check for required fields and their presence
//   results = checkRequiredFields(
//       structureDefinition, fhirPaths, results, startPath, type);

//   // Add line and column information to the validation results
//   for (var diagnostic in results.results) {
//     var node = findAstNodeForPath(astNode, diagnostic.path);
//     if (node != null) {
//       diagnostic = diagnostic.copyWith(
//         line: node.loc?.start.line,
//         column: node.loc?.start.column,
//       );
//     }
//   }

//   return results;
// }
