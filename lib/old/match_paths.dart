// import 'package:fhir_r4/fhir_r4.dart';
// import 'fhir_validation.dart';

// /// Matches FHIR paths from the resource to the element definitions in the structure definition.
// /// This function traverses each key in the fhirPaths and attempts to find matching elements
// /// in the provided elementDefinitions.
// Map<String, FhirValidationObject> matchPaths(
//   Map<String, dynamic> fhirPaths,
//   List<ElementDefinition>? elementDefinitions,
//   Map<String, FhirValidationObject> fhirPathMatches,
// ) {
//   for (var key in fhirPaths.keys) {
//     // Remove array indexes from the FHIR path for matching purposes
//     final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');

//     // Iterate through each element definition
//     elementDefinitions?.forEach((element) async {
//       final elementPath = element.path;
//       if (elementPath == null) return;

//       // Full match: if the element path matches the FHIR path without indexes
//       if (elementPath == noIndexesPath) {
//         fhirPathMatches = addToFhirPathMatches(
//           fhirPathMatches: fhirPathMatches,
//           key: key,
//           noIndex: noIndexesPath,
//           fullMatch: elementPath,
//           type: element.type,
//           binding: element.binding,
//           constraint: element.constraint,
//         );
//         return;
//       }

//       // Handle polymorphic elements (e.g., value[x])
//       if (elementPath.endsWith('[x]') &&
//           element.type != null &&
//           element.type!.isNotEmpty) {
//         final pathsList = elementPath.split('.');
//         var fieldName = pathsList.last.replaceAll('[x]', '');

//         // Iterate through each possible type for the polymorphic element
//         for (var type in element.type!) {
//           pathsList
//             ..removeLast()
//             ..add(
//                 '$fieldName${type.code.toString().substring(0, 1).toUpperCase()}${type.code.toString().substring(1)}');

//           final tempPath = pathsList.join('.');

//           // Full match with the specific type
//           if (noIndexesPath == tempPath) {
//             fhirPathMatches = addToFhirPathMatches(
//               fhirPathMatches: fhirPathMatches,
//               key: key,
//               type: element.type,
//               noIndex: noIndexesPath,
//               fullMatch: pathsList.join('.'),
//               binding: element.binding,
//               constraint: null,
//             );
//             return;
//           } else if (noIndexesPath.startsWith(tempPath)) {
//             // Partial match
//             if (fhirPathMatches.containsKey(key) &&
//                 fhirPathMatches[key]!.partialMatch != null &&
//                 fhirPathMatches[key]!.partialMatch!.length <
//                     elementPath.length) {
//               fhirPathMatches[key]!.partialMatch = elementPath;
//             } else {
//               fhirPathMatches = addToFhirPathMatches(
//                 fhirPathMatches: fhirPathMatches,
//                 key: key,
//                 type: element.type,
//                 noIndex: noIndexesPath,
//                 partialMatch: elementPath,
//                 binding: element.binding,
//                 constraint: null,
//               );
//             }
//           }
//         }
//         return;
//       }

//       // Partial match: if the element path is a prefix of the FHIR path
//       if (noIndexesPath.startsWith(elementPath)) {
//         if (fhirPathMatches.containsKey(key) &&
//             fhirPathMatches[key]!.partialMatch != null &&
//             fhirPathMatches[key]!.partialMatch!.length < elementPath.length) {
//           fhirPathMatches[key]!.partialMatch = elementPath;
//         } else {
//           fhirPathMatches = addToFhirPathMatches(
//             fhirPathMatches: fhirPathMatches,
//             key: key,
//             type: element.type,
//             noIndex: noIndexesPath,
//             partialMatch: elementPath,
//             binding: element.binding,
//             constraint: null,
//           );
//         }
//         return;
//       }

//       // Check for profile references in extensions
//       if (elementPath.endsWith('.extension') && element.type != null) {
//         for (var type in element.type!) {
//           if (type.profile != null) {
//             for (var profile in type.profile!) {
//               final profileStructureDefinition =
//                   await getStructureDefinition(profile.toString());
//               if (profileStructureDefinition != null) {
//                 final nestedElementDefinitions =
//                     StructureDefinition.fromJson(profileStructureDefinition)
//                         .snapshot
//                         ?.element;
//                 fhirPathMatches = matchPaths(
//                   fhirPaths,
//                   nestedElementDefinitions,
//                   fhirPathMatches,
//                 );
//               }
//             }
//           }
//         }
//       }
//     });

//     // If no match found, create a FhirValidationObject with the noIndex path
//     if (!fhirPathMatches.containsKey(key) && !key.endsWith('resourceType')) {
//       fhirPathMatches[key] = FhirValidationObject(noIndex: noIndexesPath);
//       print('No match found: $key');
//     }
//   }

//   return fhirPathMatches;
// }
