import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

Map<String, List<String>?> checkRequiredFields(
  StructureDefinition structureDefinition,
  Map<String, dynamic> fhirPaths,
  Map<String, List<String>?> returnMap,
  String startPath,
  String type,
) {
  final structureDefinitionPaths =
      structureDefinition.snapshot?.element.map((e) => e.path).toList() ??
          <String>[];

  structureDefinitionPaths.removeWhere((element) => element == null);

  for (var element
      in structureDefinition.snapshot?.element ?? <ElementDefinition>[]) {
    if (structureDefinitionPaths.contains(element.path) &&
        element.path != type) {
      bool found = false;

      for (var key in fhirPaths.keys) {
        if (key.replaceAll(RegExp(r'\[[0-9]+\]'), '') == element.path) {
          found = true;
          break;
        }
      }

      if (!found) {
        if (element.min != null &&
            element.min?.value != null &&
            element.min!.value! > 0) {
          // Special handling for nested structures
          final basePath = element.path?.split('.').first;
          if (basePath != null &&
              fhirPaths.keys.any((key) => key.startsWith('$basePath.'))) {
            continue; // Skip this element if any nested structure exists
          }

          if (element.path != null) {
            final fullPath =
                fullPathFromStartAndCurrent(startPath, element.path ?? '');
            if (!returnMap.containsKey(fullPath)) {
              returnMap[fullPath] = <String>[];
            }
            returnMap[fullPath]!.add(
                'This property is required by the StructureDefinition but has no value. '
                'Cardinality: ${element.min ?? "not defined"}..${element.max ?? "not defined"}');
          }
        } else {
          if (element.path != null) {
            structureDefinitionPaths
                .removeWhere((e) => e!.startsWith(element.path!));
          }
        }
      }
    }
  }

  return returnMap;
}
