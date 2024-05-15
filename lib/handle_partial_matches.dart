import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

/// Function to handle partial matches found during FHIR validation.
/// It attempts to resolve the partial matches by checking polymorphic types and nested profiles.
Future<ValidationResults> handlePartialMatches(
  Map<String, dynamic> partialMatchMap, // Map of partial matches
  List<ElementDefinition>?
      elementDefinitions, // List of element definitions from the structure definition
  ValidationResults results, // Map to store validation results
  String startPath, // Starting path for validation
  Map<String, dynamic>
      mapToValidate, // Original map of the resource to validate
) async {
  // Iterate through each partial match
  for (var key in partialMatchMap.keys) {
    final noIndexesPath = key.replaceAll(
        RegExp(r'\[[0-9]+\]'), ''); // Remove indexes from the path
    final elementDefinitionIndex = elementDefinitions?.indexWhere((element) =>
        element.path == noIndexesPath); // Find the element definition index

    if (elementDefinitionIndex != null && elementDefinitionIndex != -1) {
      final types = elementDefinitions?[elementDefinitionIndex]
          .type; // Get the types of the element

      if (types != null && types.isNotEmpty) {
        String? newType;
        if (types.length == 1) {
          newType = types.first.code
              ?.toString(); // Get the type code if there is only one type
        } else {
          final keyList = key.split('.');
          if (keyList.last.endsWith('[x]')) {
            final polymorphicField =
                partialMatchMap[key].keys.first.split('.')[keyList.length - 1];
            final fieldName = keyList.last.replaceAll('[x]', '');
            newType = polymorphicField.replaceFirst(
                fieldName, ''); // Handle polymorphic fields
          }
        }

        if (newType == null) {
          continue;
        } else {
          if (newType == 'Resource') {
            final String resourceType =
                (partialMatchMap[key] as Map<String, dynamic>).keys.firstWhere(
                    (element) => element.endsWith('resourceType'),
                    orElse: () => '');
            newType =
                resourceType != '' ? partialMatchMap[key][resourceType] : null;
          }
          if (newType != null) {
            final newStructureDefinition = await getStructureDefinition(
                newType); // Get the new structure definition
            final polyMorphicLength =
                key.endsWith('[x]') ? key.split('.').length : -1;
            final startOfPath =
                '$startPath.${key.split('.').sublist(1).join('.')}';
            final newMapToEvaluate =
                (partialMatchMap[key] as Map<String, dynamic>)
                    .map((k, v) => MapEntry<String, dynamic>(
                          polyMorphicLength == -1
                              ? k.replaceFirst(key, newType!)
                              : '$newType.${k.split('.').sublist(polyMorphicLength).join('.')}',
                          v,
                        ));
            if (newStructureDefinition != null) {
              // Handle the partial match
              results.combineResults(
                await evaluateFromPaths(
                  newMapToEvaluate,
                  StructureDefinition.fromJson(newStructureDefinition),
                  newType,
                  startOfPath,
                  mapToValidate,
                ),
              );
            }
          }
        }
      }
    } else {
      // Key not found in element definitions
    }
  }

  return results; // Return the updated return map
}
