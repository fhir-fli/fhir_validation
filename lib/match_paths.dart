import 'package:fhir_r4/fhir_r4.dart';

import 'fhir_validation.dart';

Map<String, FhirValidationObject> matchPaths(
  Map<String, dynamic> fhirPaths,
  List<ElementDefinition>? elementDefinitions,
  Map<String, FhirValidationObject> fhirPathMatches,
) {
  for (var key in fhirPaths.keys) {
    final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');

    elementDefinitions?.indexWhere((element) {
      final elementPath = element.path;
      if (elementPath == null) return false;

      if (elementPath == noIndexesPath) {
        fhirPathMatches = addToFhirPathMatches(
          fhirPathMatches: fhirPathMatches,
          key: key,
          noIndex: noIndexesPath,
          fullMatch: elementPath,
          type: element.type,
          binding: element.binding,
          constraint: element.constraint,
        );
        return true;
      }

      if (elementPath.endsWith('[x]') &&
          element.type != null &&
          element.type!.isNotEmpty) {
        final pathsList = elementPath.split('.');
        var fieldName = pathsList.last.replaceAll('[x]', '');

        for (var type in element.type!) {
          pathsList
            ..removeLast()
            ..add(
                '$fieldName${type.code.toString().substring(0, 1).toUpperCase()}${type.code.toString().substring(1)}');

          final tempPath = pathsList.join('.');

          if (noIndexesPath == tempPath) {
            fhirPathMatches = addToFhirPathMatches(
              fhirPathMatches: fhirPathMatches,
              key: key,
              type: element.type,
              noIndex: noIndexesPath,
              fullMatch: pathsList.join('.'),
              binding: element.binding,
              constraint: null,
            );
            return true;
          } else if (noIndexesPath.startsWith(tempPath)) {
            if (fhirPathMatches.containsKey(key) &&
                fhirPathMatches[key]!.partialMatch != null &&
                fhirPathMatches[key]!.partialMatch!.length <
                    elementPath.length) {
              fhirPathMatches[key]!.partialMatch = elementPath;
            } else {
              fhirPathMatches = addToFhirPathMatches(
                fhirPathMatches: fhirPathMatches,
                key: key,
                type: element.type,
                noIndex: noIndexesPath,
                partialMatch: elementPath,
                binding: element.binding,
                constraint: null,
              );
            }
          }
        }
        return false;
      }

      if (noIndexesPath.startsWith(elementPath)) {
        if (fhirPathMatches.containsKey(key) &&
            fhirPathMatches[key]!.partialMatch != null &&
            fhirPathMatches[key]!.partialMatch!.length < elementPath.length) {
          fhirPathMatches[key]!.partialMatch = elementPath;
        } else {
          fhirPathMatches = addToFhirPathMatches(
            fhirPathMatches: fhirPathMatches,
            key: key,
            type: element.type,
            noIndex: noIndexesPath,
            partialMatch: elementPath,
            binding: element.binding,
            constraint: null,
          );
        }
        return false;
      }

      return false;
    });

    if (!fhirPathMatches.containsKey(key) && !key.endsWith('resourceType')) {
      fhirPathMatches[key] = FhirValidationObject(noIndex: noIndexesPath);
    }
  }

  return fhirPathMatches;
}
