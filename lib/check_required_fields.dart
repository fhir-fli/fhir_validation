import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

Map<String, dynamic> checkRequiredFields(
  StructureDefinition structureDefinition,
  Map<String, dynamic> fhirPaths,
  Map<String, dynamic> returnMap,
  String startPath,
  String type,
) {
  // Get a list of paths from the StructureDefinition snapshot's elements
  final structureDefinitionPaths =
      structureDefinition.snapshot?.element.map((e) => e.path).toList() ??
          <String>[];
  final notFound = <String>{};

  // Remove any null values from the list
  structureDefinitionPaths.removeWhere((element) => element == null);

  // Iterate over each element in the StructureDefinition snapshot
  for (final path in structureDefinitionPaths) {
    // Print current element path and type for debugging
    // print('Checking element path: ${element.path}, type: ${element.type}');

    // Check if the element's path is not the root type
    if (path != null &&
        path != type &&
        !notFound.any((element) => path.startsWith(element))) {
      bool found = false;

      // Check if the current path in fhirPaths matches the element path without indexes
      for (var key in fhirPaths.keys) {
        if (key.replaceAll(RegExp(r'\[[0-9]+\]'), '') == path) {
          found = true;
          break;
        }
      }

      // If the element is not found in fhirPaths and has a minimum cardinality greater than 0
      if (!found) {
        final element = structureDefinition.differential?.element
            .firstWhereOrNull((element) => element.path == path);
        if (element?.min != null &&
            element!.min?.value != null &&
            element.min!.value! > 0) {
          // Add an error to returnMap for the missing required field
          if (element.path != null) {
            returnMap = addToMap(
              returnMap,
              startPath,
              element.path ?? '',
              'minimum required = ${element.min}, but only 0 found '
              "(from '${structureDefinition.url}${structureDefinition.version == null ? '' : '|${structureDefinition.version}'}')",
              Severity.error,
            );
          }
        }
        // If the element is not found, it doesn't matter if it's required or
        // not, we don't need to evaluate any sub paths, because we know they
        // don't exist
        if (element?.path != null) {
          notFound.add(element!.path!);
        }
      }
    }
  }

  return returnMap;
}
