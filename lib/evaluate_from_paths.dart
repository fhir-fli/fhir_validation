import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

Future<Map<String, List<String>?>> evaluateFromPaths(
  Map<String, dynamic> fhirPaths,
  StructureDefinition structureDefinition,
  String type,
  String startPath,
  bool online,
  Map<String, dynamic> mapToValidate,
) async {
  var returnMap = <String, List<String>?>{};

  // Remove resourceType as it's not in the StructureDefinition
  fhirPaths.removeWhere((key, value) => key.endsWith('.resourceType'));

  var fhirPathMatches = <String, FhirValidationObject>{};
  final elementDefinitions = structureDefinition.snapshot?.element;

  // Look at every key in the map
  for (var key in fhirPaths.keys) {
    final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');

    var index = elementDefinitions?.indexWhere((element) {
      final elementPath = element.path;
      if (elementPath == null) return false;

      // Exact match
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

      // Polymorphic types handling
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

      // Partial match handling
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

    if (index != null && index != -1) {
      returnMap = checkMaxCardinalityOfJson(elementDefinitions![index], key,
          returnMap, startPath, fhirPaths, fhirPathMatches[key]);
    }
  }

  final downloads = <String, dynamic>{};
  final codes = <String, List<String>>{};

  for (final key in fhirPathMatches.keys) {
    final FhirValidationObject value =
        fhirPathMatches[key] as FhirValidationObject;
    if (value.fullMatch != null && value.fullMatch != '') {
      if (value.type != null) {
        if (!isValueAValidPrimitive(value.type!, fhirPaths[key])) {
          returnMap = addToMap(
              returnMap,
              startPath,
              key,
              "This property should be a type '${value.type}' "
              "(${fhirPrimitiveToDartPrimitive(value.type!)}) but it is invalid");
        }
        if (value.binding?.valueSet != null) {
          if (value.binding?.strength != null &&
              value.binding!.strength !=
                  ElementDefinitionBindingStrength.example) {
            Map<String, dynamic>? valueSetMap;
            var canonical = value.binding!.valueSet.toString();

            if (online) {
              if (downloads.containsKey(canonical)) {
                valueSetMap = downloads[canonical];
              } else {
                valueSetMap = await getValueSet(canonical);
                if (valueSetMap != null) {
                  downloads[canonical] = valueSetMap;
                } else {
                  valueSetMap = await getCodeSystem(canonical);
                  if (valueSetMap != null) {
                    downloads[canonical] = valueSetMap;
                  }
                }
              }
            }

            if (valueSetMap == null) {
              valueSetMap = await getValueSet(canonical);
            }

            ValueSet? valueSet;

            if (valueSetMap != null) {
              valueSet = ValueSet.fromJson(valueSetMap);
            }

            if (!codes.containsKey(canonical)) {
              codes[canonical] = [];

              for (var include
                  in valueSet?.compose?.include ?? <ValueSetInclude>[]) {
                if (include.concept?.isNotEmpty ?? false) {
                  for (var concept in include.concept!) {
                    if (concept.code != null) {
                      codes[canonical]!.add(concept.code.toString());
                    }
                  }
                } else if (include.system != null) {
                  Map<String, dynamic>? codeSystemMap;
                  canonical = include.system.toString();

                  if (online) {
                    if (downloads.containsKey(include.system.toString())) {
                      codeSystemMap = downloads[include.system];
                    } else {
                      codeSystemMap = await getCodeSystem(canonical);
                      if (codeSystemMap != null) {
                        downloads[canonical] = codeSystemMap;
                      } else {
                        codeSystemMap = await getValueSet(canonical);
                        if (codeSystemMap != null) {
                          downloads[canonical] = codeSystemMap;
                        }
                      }
                    }

                    if (codeSystemMap == null) {
                      codeSystemMap = await getCodeSystem(canonical);
                    }

                    if (codeSystemMap != null) {
                      final codeSystem = CodeSystem.fromJson(codeSystemMap);
                      for (var concept
                          in codeSystem.concept ?? <CodeSystemConcept>[]) {
                        if (concept.code != null) {
                          codes[canonical] ??= [];
                          codes[canonical]!.add(concept.code.toString());
                        }
                      }
                    }
                  }
                }
              }
            }
            if (codes[canonical] != null && codes[canonical]!.isNotEmpty) {
              if (!(codes[canonical]?.contains(fhirPaths[key]) ?? false)) {
                if (value.binding!.strength ==
                    ElementDefinitionBindingStrength.required_) {
                  returnMap = addToMap(
                      returnMap,
                      startPath,
                      key,
                      await notInValueSetMessage(
                        fhirPaths[key],
                        value.binding?.valueSet,
                        'but is required to be',
                      ));
                } else if (value.binding!.strength ==
                    ElementDefinitionBindingStrength.extensible) {
                  returnMap = addToMap(
                      returnMap,
                      startPath,
                      key,
                      await notInValueSetMessage(
                          fhirPaths[key],
                          value.binding?.valueSet,
                          ', and it is extensible, so it probably should be'));
                } else if (value.binding!.strength ==
                    ElementDefinitionBindingStrength.extensible) {
                  returnMap = addToMap(
                      returnMap,
                      startPath,
                      key,
                      await notInValueSetMessage(
                          fhirPaths[key],
                          value.binding?.valueSet,
                          ', it is not required, but it is encouraged'));
                }
              }
            }
          }
        }
      }
    }
    final constraints = fhirPathMatches[key]?.constraint;
    for (final constraint in constraints ?? <ElementDefinitionConstraint>[]) {
      // TODO: Implement constraint validation logic
    }
  }

  final partialMatchMap = <String, dynamic>{};

  for (var key in fhirPathMatches.keys) {
    if ((fhirPathMatches[key]?.fullMatch ?? '') == '') {
      var partialMatch = (fhirPathMatches[key]!.partialMatch?.endsWith('[x]') ??
              false)
          ? fhirPathMatches[key]!.partialMatch!
          : key
              .split('.')
              .sublist(0, fhirPathMatches[key]!.partialMatch?.split('.').length)
              .join('.');
      if (partialMatch.endsWith('.')) {
        partialMatch = partialMatch.substring(0, partialMatch.length - 1);
      }
      if (partialMatch == startPath) {
        if (!returnMap.containsKey(key)) {
          returnMap[key] = <String>[];
        }
        returnMap[key]!.add(
            "Unrecognized property, '$key', not found in the StructureDefinition");
      } else {
        if (!partialMatchMap.containsKey(partialMatch)) {
          partialMatchMap[partialMatch] = <String, dynamic>{};
        }
        partialMatchMap[partialMatch][key] = fhirPaths[key];
      }
    }
  }

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
      } else {
        // Ensure the proper Cardinality of > 0
      }
    }
  }

  return returnMap;
}
