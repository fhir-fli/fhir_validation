import 'package:fhir_r4/fhir_r4.dart';

import 'fhir_validation.dart';

Future<Map<String, List<String>?>> handlePartialMatches(
  Map<String, dynamic> partialMatchMap,
  List<ElementDefinition>? elementDefinitions,
  Map<String, List<String>?> returnMap,
  String startPath,
  bool online,
  Map<String, dynamic> mapToValidate,
) async {
  for (var key in partialMatchMap.keys) {
    final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');
    final elementDefinitionIndex = elementDefinitions
        ?.indexWhere((element) => element.path == noIndexesPath);

    if (elementDefinitionIndex != null && elementDefinitionIndex != -1) {
      final types = elementDefinitions?[elementDefinitionIndex].type;

      if (types != null && types.isNotEmpty) {
        String? newType;
        if (types.length == 1) {
          newType = types.first.code?.toString();
        } else {
          final keyList = key.split('.');
          if (keyList.last.endsWith('[x]')) {
            final polymorphicField =
                partialMatchMap[key].keys.first.split('.')[keyList.length - 1];
            final fieldName = keyList.last.replaceAll('[x]', '');
            newType = polymorphicField.replaceFirst(fieldName, '');
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
          if (newType == null) {
            continue;
          } else {
            final newStructureDefinition =
                await getStructureDefinition(newType);
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
              returnMap = combineMaps(
                returnMap,
                await evaluateFromPaths(
                  newMapToEvaluate,
                  StructureDefinition.fromJson(newStructureDefinition),
                  newType,
                  startOfPath,
                  online,
                  mapToValidate,
                ),
              );
            }
          }
        }
      }
    } else {
      print('Key not found $key');
    }
  }

  return returnMap;
}
