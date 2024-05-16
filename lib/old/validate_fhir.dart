// import 'dart:convert';

// import 'package:collection/collection.dart';
// import 'package:fhir_r4/fhir_r4.dart';
// import 'package:fhir_validation/fhir_validation.dart';

// // Main validation function
// Future<ValidationResults> validateFhir({
//   required Map<String, dynamic> resourceToValidate,
//   StructureDefinition? structureDefinition,
// }) async {
//   var results = ValidationResults();

//   final String resourceString = json.encode(resourceToValidate);
//   // Parse the JSON with position information
//   final jsonAst = parse(resourceString, Settings());

//   // Extract the resourceType from the resource
//   final typeNode = getPropertyNode(jsonAst, 'resourceType');
//   if (typeNode == null || resourceToValidate['resourceType'] == null) {
//     return results
//       ..addResult(
//         '',
//         '',
//         'ResourceType is missing',
//         Severity.error,
//         line: typeNode?.loc?.start.line,
//         column: typeNode?.loc?.start.column,
//       );
//   }
//   final type = resourceToValidate['resourceType'];

//   // Extract profiles from the resource if any are specified in the meta section
//   final profiles = extractProfiles(resourceToValidate);
//   // List to hold profile definitions retrieved
//   List<Map<String, dynamic>> profileDefinitions = [];

//   // Retrieve profile definitions for each profile URL
//   for (var profile in profiles) {
//     try {
//       final profileDef = await getProfile(profile);
//       if (profileDef != null) {
//         profileDefinitions.add(profileDef);
//       }
//     } catch (e) {
//       // If there is an error retrieving a profile, return an error message
//       return results
//         ..addResult(
//           '',
//           '',
//           'Failed to retrieve profile definition: $profile',
//           Severity.error,
//         );
//     }
//   }

//   // If no profiles are found, use the regular structure definition
//   if (profileDefinitions.isEmpty) {
//     if (structureDefinition == null) {
//       // Retrieve the structure definition for the resource type
//       final definitionMap = await getStructureDefinition(type);
//       if (definitionMap == null) {
//         // If no structure definition is found, return an error
//         results.addResult(
//           '',
//           '',
//           'No StructureDefinition was found for this Resource, which is a resourceType of: $type',
//           Severity.error,
//         );
//       } else {
//         // Parse the structure definition from JSON
//         structureDefinition = StructureDefinition.fromJson(definitionMap);
//       }
//     }
//     if (structureDefinition == null) {
//       // If structure definition is still null, add an error message to returnMap
//       return results
//         ..addResult(
//           '',
//           '',
//           'No StructureDefinition was found for this Resource, which is a resourceType of: $type',
//           Severity.error,
//         );
//     } else {
//       // If structure definition is found, validate the resource against it
//       results.combineResults(
//         await validateFhirMaps(
//           mapToValidate: resourceToValidate,
//           structureDefinition: structureDefinition,
//           type: type,
//           startPath: type,
//           astNode: jsonAst,
//         ),
//       );
//     }
//   } else {
//     // If profiles are found, validate the resource against each profile
//     for (var profileDef in profileDefinitions) {
//       results.combineResults(
//         await validateFhirMaps(
//           mapToValidate: resourceToValidate,
//           structureDefinition: StructureDefinition.fromJson(profileDef),
//           type: type,
//           startPath: type,
//           astNode: jsonAst,
//         ),
//       );
//     }
//   }

//   // Return the final map with validation results
//   return results;
// }

// // Helper function to extract profiles from the resource
// List<String> extractProfiles(Map<String, dynamic> resource) {
//   List<String> profiles = [];
//   if (resource.containsKey('meta') && resource['meta'].containsKey('profile')) {
//     profiles = List<String>.from(resource['meta']['profile']);
//   }
//   return profiles;
// }

// Future<ValidationResults> validateFhirMaps({
//   required Map<String, dynamic> mapToValidate,
//   required StructureDefinition structureDefinition,
//   required String type,
//   required String startPath,
//   Node? astNode,
// }) async {
//   var results = ValidationResults();

//   // Create a list of all paths in the mapToValidate
//   final fhirPaths = fhirPathsFromMap(value: mapToValidate, path: type);

//   // Evaluate the resource based on the generated paths and structure definition
//   final evaluationResults = await evaluateFromPaths(
//     fhirPaths,
//     structureDefinition,
//     type,
//     startPath,
//     mapToValidate,
//     astNode, // Pass astNode here
//   );

//   // Add line and column information to the validation results
//   for (var result in evaluationResults.results) {
//     var node = findAstNodeForPath(astNode, result.path);
//     if (node != null) {
//       result = result.copyWith(
//         line: node.loc?.start.line,
//         column: node.loc?.start.column,
//       );
//     }
//   }

//   results.combineResults(evaluationResults);

//   return results;
// }

// // Helper function to find an AST node for a given path
// Node? findAstNodeForPath(Node? node, String path) {
//   if (node is ObjectNode) {
//     var segments = path.split('.');
//     Node? currentNode = node;

//     for (var segment in segments) {
//       if (currentNode is ObjectNode) {
//         currentNode = currentNode.children
//             .firstWhereOrNull((child) => child.key?.value == segment)
//             ?.value;
//       } else if (currentNode is ArrayNode) {
//         var index = int.tryParse(segment);
//         if (index != null && index < currentNode.children.length) {
//           currentNode = currentNode.children[index];
//         } else {
//           return null;
//         }
//       } else {
//         return null;
//       }
//     }
//     return currentNode;
//   }
//   return null;
// }

// // Helper function to get a property node from a JSON AST node
// Node? getPropertyNode(Node node, String propertyName) {
//   if (node is ObjectNode) {
//     for (var property in node.children) {
//       if (property.key?.value == propertyName) {
//         return property.value;
//       }
//     }
//   }
//   return null;
// }
