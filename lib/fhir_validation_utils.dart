// import 'package:collection/collection.dart';
// import 'package:fhir_r4/fhir_r4.dart';
// import 'package:fhir_validation/fhir_validation.dart';

// class FhirValidationUtils {
//   static List<String> extractProfiles(Map<String, dynamic> resource) {
//     List<String> profiles = [];
//     if (resource.containsKey('meta') &&
//         resource['meta'].containsKey('profile')) {
//       profiles = List<String>.from(resource['meta']['profile']);
//     }
//     return profiles;
//   }

//   static Node? getPropertyNode(Node node, String propertyName) {
//     if (node is ObjectNode) {
//       for (var property in node.children) {
//         if (property.key?.value == propertyName) {
//           return property.value;
//         }
//       }
//     }
//     return null;
//   }

//   static Map<String, dynamic> fhirPathsFromMap({
//     required dynamic value,
//     required String path,
//   }) {
//     final returnMap = <String, dynamic>{};
//     if (value is Map) {
//       for (var key in value.keys) {
//         if (value[key] is Map) {
//           returnMap
//               .addAll(fhirPathsFromMap(value: value[key], path: '$path.$key'));
//         } else if (value[key] is List) {
//           for (var i = 0; i < value[key].length; i++) {
//             returnMap['$path.$key[$i]'] = value[key][i];
//             returnMap.addAll(
//                 fhirPathsFromMap(value: value[key][i], path: '$path.$key[$i]'));
//           }
//         } else {
//           returnMap.addAll({'$path.$key': value[key]});
//         }
//       }
//     } else if (value is List) {
//       for (var i = 0; i < value.length; i++) {
//         returnMap['$path[$i]'] = value[i];
//         returnMap.addAll(fhirPathsFromMap(value: value[i], path: '$path[$i]'));
//       }
//     } else {
//       returnMap.addAll({path: value.toString()});
//     }
//     return returnMap;
//   }

//   static Node? findAstNodeForPath(Node? node, String path) {
//     if (node is ObjectNode) {
//       var segments = path.split('.');
//       Node? currentNode = node;

//       for (var segment in segments) {
//         if (currentNode is ObjectNode) {
//           currentNode = currentNode.children
//               .firstWhereOrNull((child) => child.key?.value == segment)
//               ?.value;
//         } else if (currentNode is ArrayNode) {
//           var index = int.tryParse(segment);
//           if (index != null && index < currentNode.children.length) {
//             currentNode = currentNode.children[index];
//           } else {
//             return null;
//           }
//         } else {
//           return null;
//         }
//       }
//       return currentNode;
//     }
//     return null;
//   }

//   static Future<ValidationResults> evaluateFromPaths(
//     Map<String, dynamic> fhirPaths,
//     StructureDefinition structureDefinition,
//     String type,
//     String startPath,
//     Map<String, dynamic> mapToValidate,
//     Node? astNode,
//   ) async {
//     var results = ValidationResults();

//     fhirPaths.removeWhere((key, value) => key.endsWith('.resourceType'));

//     var fhirPathMatches = <String, FhirValidationObject>{};
//     final elementDefinitions = structureDefinition.snapshot?.element;

//     fhirPathMatches =
//         matchPaths(fhirPaths, elementDefinitions, fhirPathMatches);

//     results = await checkPaths(
//         fhirPathMatches, startPath, fhirPaths, structureDefinition, astNode);

//     final partialMatchMap =
//         buildPartialMatchMap(fhirPathMatches, startPath, results, fhirPaths);

//     results = await handlePartialMatches(
//       partialMatchMap,
//       elementDefinitions,
//       results,
//       startPath,
//       mapToValidate,
//       astNode,
//     );

//     results = checkRequiredFields(structureDefinition, fhirPaths, results,
//         startPath, type, astNode); // Pass astNode here

//     // Add line and column information to the validation results
//     for (var diagnostic in results.results) {
//       var node = findAstNodeForPath(astNode, diagnostic.path);
//       if (node != null) {
//         diagnostic = diagnostic.copyWith(
//           line: node.loc?.start.line,
//           column: node.loc?.start.column,
//         );
//       }
//     }

//     return results;
//   }

//   static Map<String, FhirValidationObject> matchPaths(
//     Map<String, dynamic> fhirPaths,
//     List<ElementDefinition>? elementDefinitions,
//     Map<String, FhirValidationObject> fhirPathMatches,
//   ) {
//     for (var key in fhirPaths.keys) {
//       // Remove array indexes from the FHIR path for matching purposes
//       final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');

//       // Iterate through each element definition
//       elementDefinitions?.forEach((element) async {
//         final elementPath = element.path;
//         if (elementPath == null) return;

//         // Full match: if the element path matches the FHIR path without indexes
//         if (elementPath == noIndexesPath) {
//           fhirPathMatches = addToFhirPathMatches(
//             fhirPathMatches: fhirPathMatches,
//             key: key,
//             noIndex: noIndexesPath,
//             fullMatch: elementPath,
//             type: element.type,
//             binding: element.binding,
//             constraint: element.constraint,
//           );
//           return;
//         }

//         // Handle polymorphic elements (e.g., value[x])
//         if (elementPath.endsWith('[x]') &&
//             element.type != null &&
//             element.type!.isNotEmpty) {
//           final pathsList = elementPath.split('.');
//           var fieldName = pathsList.last.replaceAll('[x]', '');

//           // Iterate through each possible type for the polymorphic element
//           for (var type in element.type!) {
//             pathsList
//               ..removeLast()
//               ..add(
//                   '$fieldName${type.code.toString().substring(0, 1).toUpperCase()}${type.code.toString().substring(1)}');

//             final tempPath = pathsList.join('.');

//             // Full match with the specific type
//             if (noIndexesPath == tempPath) {
//               fhirPathMatches = addToFhirPathMatches(
//                 fhirPathMatches: fhirPathMatches,
//                 key: key,
//                 type: element.type,
//                 noIndex: noIndexesPath,
//                 fullMatch: pathsList.join('.'),
//                 binding: element.binding,
//                 constraint: null,
//               );
//               return;
//             } else if (noIndexesPath.startsWith(tempPath)) {
//               // Partial match
//               if (fhirPathMatches.containsKey(key) &&
//                   fhirPathMatches[key]!.partialMatch != null &&
//                   fhirPathMatches[key]!.partialMatch!.length <
//                       elementPath.length) {
//                 fhirPathMatches[key]!.partialMatch = elementPath;
//               } else {
//                 fhirPathMatches = addToFhirPathMatches(
//                   fhirPathMatches: fhirPathMatches,
//                   key: key,
//                   type: element.type,
//                   noIndex: noIndexesPath,
//                   partialMatch: elementPath,
//                   binding: element.binding,
//                   constraint: null,
//                 );
//               }
//             }
//           }
//           return;
//         }

//         // Partial match: if the element path is a prefix of the FHIR path
//         if (noIndexesPath.startsWith(elementPath)) {
//           if (fhirPathMatches.containsKey(key) &&
//               fhirPathMatches[key]!.partialMatch != null &&
//               fhirPathMatches[key]!.partialMatch!.length < elementPath.length) {
//             fhirPathMatches[key]!.partialMatch = elementPath;
//           } else {
//             fhirPathMatches = addToFhirPathMatches(
//               fhirPathMatches: fhirPathMatches,
//               key: key,
//               type: element.type,
//               noIndex: noIndexesPath,
//               partialMatch: elementPath,
//               binding: element.binding,
//               constraint: null,
//             );
//           }
//           return;
//         }

//         // Check for profile references in extensions
//         if (elementPath.endsWith('.extension') && element.type != null) {
//           for (var type in element.type!) {
//             if (type.profile != null) {
//               for (var profile in type.profile!) {
//                 final profileStructureDefinition =
//                     await getStructureDefinition(profile.toString());
//                 if (profileStructureDefinition != null) {
//                   final nestedElementDefinitions =
//                       StructureDefinition.fromJson(profileStructureDefinition)
//                           .snapshot
//                           ?.element;
//                   fhirPathMatches = matchPaths(
//                     fhirPaths,
//                     nestedElementDefinitions,
//                     fhirPathMatches,
//                   );
//                 }
//               }
//             }
//           }
//         }
//       });

//       // If no match found, create a FhirValidationObject with the noIndex path
//       if (!fhirPathMatches.containsKey(key) && !key.endsWith('resourceType')) {
//         fhirPathMatches[key] = FhirValidationObject(noIndex: noIndexesPath);
//         print('No match found: $key');
//       }
//     }

//     return fhirPathMatches;
//   }

//   static Future<ValidationResults> checkPaths(
//     Map<String, FhirValidationObject> fhirPathMatches,
//     String startPath,
//     Map<String, dynamic> fhirPaths,
//     StructureDefinition structureDefinition,
//     Node? astNode,
//   ) async {
//     var results = ValidationResults();
//     final downloads = <String, dynamic>{};
//     final codes = <String, List<String>>{};

//     for (final key in fhirPathMatches.keys) {
//       final FhirValidationObject value = fhirPathMatches[key]!;

//       if (value.fullMatch != null && value.fullMatch != '') {
//         print('Processing full match for key: $key');

//         if (value.type != null && value.type!.isNotEmpty) {
//           if (isPrimitiveType(value.type!)) {
//             if (!isValueAValidPrimitive(value.type!, fhirPaths[key])) {
//               var node = findAstNodeForPath(astNode, key);
//               print(
//                   'Invalid primitive type for key: $key, type: ${value.type}');
//               results.addResult(
//                 startPath,
//                 key,
//                 "This property should be a type '${value.type}' (${fhirPrimitiveToDartPrimitive(value.type!)}) but it is invalid",
//                 Severity.error,
//                 line: node?.loc?.start.line,
//                 column: node?.loc?.start.column,
//               );
//             }
//           }

//           // Check value set binding for code fields within Coding elements or directly bound elements
//           if (value.binding?.valueSet != null &&
//               shouldCheckValueSet(key, fhirPaths[key])) {
//             print('Processing value set binding for key: $key');
//             if (value.binding?.strength != null &&
//                 value.binding!.strength !=
//                     ElementDefinitionBindingStrength.example) {
//               Map<String, dynamic>? valueSetMap;
//               var canonical = value.binding!.valueSet.toString();

//               if (downloads.containsKey(canonical)) {
//                 valueSetMap = downloads[canonical];
//               } else {
//                 valueSetMap = await getValueSet(canonical);
//                 downloads[canonical] = valueSetMap;
//               }

//               if (valueSetMap == null) {
//                 valueSetMap = await getValueSet(canonical);
//               }

//               ValueSet? valueSet;

//               if (valueSetMap != null) {
//                 valueSet = ValueSet.fromJson(valueSetMap);

//                 if (!codes.containsKey(canonical)) {
//                   codes[canonical] = [];

//                   for (var include
//                       in valueSet.compose?.include ?? <ValueSetInclude>[]) {
//                     if (include.concept?.isNotEmpty ?? false) {
//                       for (var concept in include.concept!) {
//                         if (concept.code != null) {
//                           codes[canonical]!.add(concept.code.toString());
//                         }
//                       }
//                     } else if (include.system != null) {
//                       Map<String, dynamic>? codeSystemMap;
//                       canonical = include.system.toString();

//                       if (downloads.containsKey(include.system.toString())) {
//                         codeSystemMap = downloads[include.system];
//                       } else {
//                         codeSystemMap = await getCodeSystem(canonical);
//                         downloads[canonical] = codeSystemMap;
//                       }

//                       if (codeSystemMap == null) {
//                         codeSystemMap = await getCodeSystem(canonical);
//                       }
//                       if (codeSystemMap != null) {
//                         final codeSystem = CodeSystem.fromJson(codeSystemMap);
//                         for (var concept
//                             in codeSystem.concept ?? <CodeSystemConcept>[]) {
//                           if (concept.code != null) {
//                             codes[canonical] ??= [];
//                             codes[canonical]!.add(concept.code.toString());
//                           }
//                         }
//                       }
//                     }
//                   }
//                 }
//               }

//               if (codes[canonical] != null && codes[canonical]!.isNotEmpty) {
//                 bool codeIsInValueSet = false;
//                 var valueToCheck = fhirPaths[key];

//                 if (valueToCheck is Map && valueToCheck.containsKey('coding')) {
//                   for (var coding in valueToCheck['coding']) {
//                     if (codes[canonical]!.contains(coding['code'])) {
//                       codeIsInValueSet = true;
//                       break;
//                     }
//                   }
//                 } else if (valueToCheck is Map &&
//                     valueToCheck.containsKey('code')) {
//                   codeIsInValueSet =
//                       codes[canonical]!.contains(valueToCheck['code']);
//                 } else if (codes[canonical]!.contains(valueToCheck)) {
//                   codeIsInValueSet = true;
//                 }

//                 if (!codeIsInValueSet) {
//                   var node = findAstNodeForPath(astNode, key);
//                   print(
//                       'Code not in value set for key: $key, value: ${fhirPaths[key]}');
//                   if (value.binding!.strength ==
//                       ElementDefinitionBindingStrength.required_) {
//                     results.addResult(
//                       startPath,
//                       key,
//                       await notInValueSetMessage(
//                         fhirPaths[key],
//                         value.binding?.valueSet,
//                         'but is required to be',
//                       ),
//                       Severity.error,
//                       line: node?.loc?.start.line,
//                       column: node?.loc?.start.column,
//                     );
//                   } else if (value.binding!.strength ==
//                       ElementDefinitionBindingStrength.extensible) {
//                     results.addResult(
//                       startPath,
//                       key,
//                       await notInValueSetMessage(
//                         fhirPaths[key],
//                         value.binding?.valueSet,
//                         ', and it is extensible, so it probably should be',
//                       ),
//                       Severity.warning,
//                       line: node?.loc?.start.line,
//                       column: node?.loc?.start.column,
//                     );
//                   } else if (value.binding!.strength ==
//                       ElementDefinitionBindingStrength.preferred) {
//                     results.addResult(
//                       startPath,
//                       key,
//                       await notInValueSetMessage(
//                         fhirPaths[key],
//                         value.binding?.valueSet,
//                         ', it is not required, but it is encouraged',
//                       ),
//                       Severity.information,
//                       line: node?.loc?.start.line,
//                       column: node?.loc?.start.column,
//                     );
//                   }
//                 }
//               } else {
//                 var node = findAstNodeForPath(astNode, key);
//                 print(
//                     'No codes available in value set for key: $key, value set: $canonical');
//                 results.addResult(
//                   startPath,
//                   key,
//                   'The definition for the Code System with URI \'$canonical\' doesn\'t provide any codes so the code cannot be validated',
//                   Severity.information,
//                   line: node?.loc?.start.line,
//                   column: node?.loc?.start.column,
//                 );
//               }
//             }
//           }
//         }

//         final constraints = value.constraint;
//         for (final constraint
//             in constraints ?? <ElementDefinitionConstraint>[]) {
//           if (!await evaluateConstraint(
//               constraint.expression!, fhirPaths[key], startPath)) {
//             var node = findAstNodeForPath(astNode, key);
//             print(
//                 'Constraint violated for key: $key, constraint: ${constraint.human}');
//             results.addResult(
//               startPath,
//               key,
//               "Constraint violated: ${constraint.human}",
//               Severity.error,
//               line: node?.loc?.start.line,
//               column: node?.loc?.start.column,
//             );
//           }
//         }
//       }
//     }

//     print('Finished processing checkPaths');
//     return results;
//   }

//   static bool shouldCheckValueSet(String key, dynamic value) {
//     // Check if the key indicates a Coding element or a direct value set binding
//     return (key.endsWith('.code') || (value is! Map));
//   }

//   /// Utility function to check if a type is a primitive type
//   static bool isPrimitiveType(String type) {
//     // Add logic to determine if the type is a primitive type based on your requirements
//     return canonicalToPrimitiveType.containsValue(type);
//   }

//   /// Utility function to evaluate FHIRPath expressions
//   static Future<bool> evaluateConstraint(
//     String expression, // FHIRPath expression to evaluate
//     dynamic context, // Context in which to evaluate the expression
//     String startPath, // Starting path for evaluation
//   ) async {
//     // Placeholder for actual FHIRPath evaluation logic
//     try {
//       final result = walkFhirPath(pathExpression: expression, context: context);
//       if (result.isNotEmpty) {
//         return result[0] == true;
//       }
//       return false;
//     } catch (e) {
//       // Handle exception or logging
//       return false;
//     }
//   }

//   static Map<String, dynamic> buildPartialMatchMap(
//     Map<String, FhirValidationObject> fhirPathMatches,
//     String startPath,
//     ValidationResults results,
//     Map<String, dynamic> fhirPaths,
//   ) {
//     final partialMatchMap = <String, dynamic>{}; // Map to store partial matches

//     // Iterate through each FHIR path match
//     for (var key in fhirPathMatches.keys) {
//       // Check if there is no full match for the element path
//       if ((fhirPathMatches[key]?.fullMatch ?? '') == '') {
//         // Determine the partial match path
//         var partialMatch =
//             (fhirPathMatches[key]!.partialMatch?.endsWith('[x]') ?? false)
//                 ? fhirPathMatches[key]!.partialMatch!
//                 : key
//                     .split('.')
//                     .sublist(0,
//                         fhirPathMatches[key]!.partialMatch?.split('.').length)
//                     .join('.');
//         if (partialMatch.endsWith('.')) {
//           partialMatch = partialMatch.substring(0, partialMatch.length - 1);
//         }
//         if (partialMatch == startPath) {
//           results.addResult(
//               startPath,
//               '$key',
//               "Unrecognized property, '$key', not found in the StructureDefinition",
//               Severity.error);
//         } else {
//           if (!partialMatchMap.containsKey(partialMatch)) {
//             partialMatchMap[partialMatch] = <String, dynamic>{};
//           }
//           partialMatchMap[partialMatch][key] = fhirPaths[key];
//         }
//       }
//     }

//     // Return the partial match map
//     return partialMatchMap;
//   }

//   static Future<ValidationResults> handlePartialMatches(
//     Map<String, dynamic> partialMatchMap,
//     List<ElementDefinition>? elementDefinitions,
//     ValidationResults results,
//     String startPath,
//     Map<String, dynamic> mapToValidate,
//     Node? astNode,
//   ) async {
//     // Iterate through each partial match
//     for (var key in partialMatchMap.keys) {
//       final noIndexesPath = key.replaceAll(
//           RegExp(r'\[[0-9]+\]'), ''); // Remove indexes from the path
//       final elementDefinitionIndex = elementDefinitions?.indexWhere((element) =>
//           element.path == noIndexesPath); // Find the element definition index

//       if (elementDefinitionIndex != null && elementDefinitionIndex != -1) {
//         final types = elementDefinitions?[elementDefinitionIndex]
//             .type; // Get the types of the element

//         if (types != null && types.isNotEmpty) {
//           String? newType;
//           if (types.length == 1) {
//             newType = types.first.code
//                 ?.toString(); // Get the type code if there is only one type
//           } else {
//             final keyList = key.split('.');
//             if (keyList.last.endsWith('[x]')) {
//               final polymorphicField = partialMatchMap[key]
//                   .keys
//                   .first
//                   .split('.')[keyList.length - 1];
//               final fieldName = keyList.last.replaceAll('[x]', '');
//               newType = polymorphicField.replaceFirst(
//                   fieldName, ''); // Handle polymorphic fields
//             }
//           }

//           if (newType == null) {
//             continue;
//           } else {
//             if (newType == 'Resource') {
//               final String resourceType =
//                   (partialMatchMap[key] as Map<String, dynamic>)
//                       .keys
//                       .firstWhere((element) => element.endsWith('resourceType'),
//                           orElse: () => '');
//               newType = resourceType != ''
//                   ? partialMatchMap[key][resourceType]
//                   : null;
//             }
//             if (newType != null) {
//               final newStructureDefinition = await getStructureDefinition(
//                   newType); // Get the new structure definition
//               final polyMorphicLength =
//                   key.endsWith('[x]') ? key.split('.').length : -1;
//               final startOfPath =
//                   '$startPath.${key.split('.').sublist(1).join('.')}';
//               final newMapToEvaluate =
//                   (partialMatchMap[key] as Map<String, dynamic>)
//                       .map((k, v) => MapEntry<String, dynamic>(
//                             polyMorphicLength == -1
//                                 ? k.replaceFirst(key, newType!)
//                                 : '$newType.${k.split('.').sublist(polyMorphicLength).join('.')}',
//                             v,
//                           ));
//               if (newStructureDefinition != null) {
//                 // Handle the partial match
//                 results.combineResults(
//                   await FhirValidationUtils.evaluateFromPaths(
//                     newMapToEvaluate,
//                     StructureDefinition.fromJson(newStructureDefinition),
//                     newType,
//                     startOfPath,
//                     mapToValidate,
//                     astNode, // Pass astNode here
//                   ),
//                 );
//               }
//             }
//           }
//         }
//       } else {
//         // Key not found in element definitions
//       }
//     }

//     return results; // Return the updated return map
//   }

//   static ValidationResults checkRequiredFields(
//     StructureDefinition structureDefinition,
//     Map<String, dynamic> fhirPaths,
//     ValidationResults results,
//     String startPath,
//     String type,
//     Node? astNode,
//   ) {
//     final structureDefinitionPaths =
//         structureDefinition.snapshot?.element.map((e) => e.path).toList() ??
//             <String>[];
//     final notFound = <String>{};

//     structureDefinitionPaths.removeWhere((element) => element == null);

//     for (final path in structureDefinitionPaths) {
//       if (path != null &&
//           path != type &&
//           !notFound.any((element) => path.startsWith(element))) {
//         bool found = false;

//         for (var key in fhirPaths.keys) {
//           if (key.replaceAll(RegExp(r'\[[0-9]+\]'), '') == path) {
//             found = true;
//             break;
//           }
//         }

//         if (!found) {
//           final element = structureDefinition.differential?.element
//               .firstWhereOrNull((element) => element.path == path);
//           if (element?.min != null &&
//               element!.min?.value != null &&
//               element.min!.value! > 0) {
//             var node = findAstNodeForPath(astNode, path);
//             results.addResult(
//               startPath,
//               path,
//               'minimum required = ${element.min}, but only 0 found '
//               "(from '${structureDefinition.url}${structureDefinition.version == null ? '' : '|${structureDefinition.version}'}')",
//               Severity.error,
//               line: node?.loc?.start.line,
//               column: node?.loc?.start.column,
//             );
//           }
//           if (element?.path != null) {
//             notFound.add(element!.path!);
//           }
//         }
//       }
//     }

//     return results;
//   }
// }
