import 'dart:convert';

import 'package:fhir/r4.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:http/http.dart';

import '../code_system_maps/code_system_maps.dart';
import '../structure_definition_maps/structure_definition_maps.dart';
import '../utils/utils.dart';
import '../value_set_maps/value_set_maps.dart';

part 'check_cardinality_of_json.dart';
part 'fhir_validation_object.dart';
part 'maps.dart';
part 'fhir_paths_from_map.dart';

Future<Map<String, List<String>?>> validateFhir({
  required Resource resourceToValidate,
  StructureDefinition? structureDefinition,
}) async {
  var returnMap = <String, List<String>?>{};
  if (structureDefinition == null) {
    final definitionMap =
        structureDefinitionMaps[resourceToValidate.resourceTypeString];
    if (definitionMap == null) {
      returnMap[
          resourceToValidate.resourceTypeString ?? 'No ResourceType Found'] = [
        'No StructureDefinition was found for this Resource, which is '
            'as a resourceType of: ${resourceToValidate.resourceTypeString}'
      ];
    } else {
      structureDefinition = StructureDefinition.fromJson(definitionMap);
    }
  }
  if (structureDefinition == null) {
    if (returnMap[resourceToValidate.resourceTypeString ??
                'No ResourceType Found'] ==
            null ||
        returnMap[resourceToValidate.resourceTypeString ??
                'No ResourceType Found']!
            .isEmpty) {
      returnMap[
          resourceToValidate.resourceTypeString ?? 'No ResourceType Found'] = [
        'No StructureDefinition was found for this Resource, which is '
            'a resourceType of: ${resourceToValidate.resourceTypeString}'
      ];
    } else {
      returnMap[
              resourceToValidate.resourceTypeString ?? 'No ResourceType Found']!
          .add('No StructureDefinition was found for this Resource, which is '
              'a resourceType of: ${resourceToValidate.resourceTypeString}');
    }
  } else {
    returnMap = combineMaps(
      returnMap,
      await validateFhirMaps(
        mapToValidate: resourceToValidate.toJson(),
        structureDefinition: structureDefinition,
        type: resourceToValidate.resourceTypeString!,
        startPath: resourceToValidate.resourceTypeString!,
      ),
    );
  }
  return returnMap;
}

Future<Map<String, List<String>?>> validateFhirMaps({
  required Map<String, dynamic> mapToValidate,
  required StructureDefinition structureDefinition,
  required String type,
  required String startPath,
  bool online = true,
}) async {
  /// Create a list of all paths in the [mapToValidate]
  final fhirPaths = fhirPathsFromMap(value: mapToValidate, path: type);
  final returnMap = await evaluateFromPaths(
      fhirPaths, structureDefinition, type, startPath, online, mapToValidate);

  return returnMap;
}

Future<Map<String, List<String>?>> evaluateFromPaths(
  Map<String, dynamic> fhirPaths,
  StructureDefinition structureDefinition,
  String type,
  String startPath,
  bool online,
  Map<String, dynamic> mapToValidate,
) async {
  var returnMap = <String, List<String>?>{};

  /// This is because we don't do anything for the value "resourceType" in the
  /// json map, and because it's not a listed field in the StructureDefinition
  if (fhirPaths['$type.resourceType'] != null &&
      fhirPaths['$type.resourceType'] == type) {
    fhirPaths.removeWhere((key, value) => key == '$type.resourceType');
  }
  var fhirPathMatches = <String, FhirValidationObject>{};
  final elementDefinitions = structureDefinition.snapshot?.element;

  /// Look at every key in the map
  for (var key in fhirPaths.keys) {
    /// remove all indexes for the moment
    final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');

    /// check if there is a path in the current StructureDefinition that
    /// corresponds to this path
    var index = elementDefinitions?.indexWhere((element) {
      final elementPath = element.path;
      if (elementPath == null) {
        return false;
      }

      /// If there is, then we've found the proper index
      else if (elementPath == noIndexesPath) {
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

      /// If not, this could still be the index because there are some polymorphic
      /// types that end in [x]. We check if it's one of those, and just to be
      /// safe check that there is a list of types that this polymorphic value
      /// could be.
      else if (elementPath.endsWith('[x]') &&
          element.type != null &&
          element.type!.isNotEmpty) {
        /// Split the element's path into a list, andm then remove the "[x]"
        /// from the end, so
        ///
        /// "Bundle.entry[3].resource.parameter[2].valueCoding" would be
        /// stripped of index to become:
        /// "Bundle.entry.resource.parameter.valueCoding"
        ///
        /// Then, while looking through the paths in the elements, it would
        /// come along one that looked like
        /// "Bundle.entry.resource.parameter.value[x]"
        /// which would then become
        /// ["Bundle", "entry", "resource", "parameter", "value[x]"]
        ///
        /// And then we just remove the "[x]" from the last value to get the
        /// fieldName to test
        final pathsList = elementPath.split('.');
        var fieldName = pathsList.last.replaceAll('[x]', '');

        /// If it is, we go through each time listed in the element. We first
        /// remove the last value inj the list, so from our example above
        ///
        /// ["Bundle", "entry", "resource", "parameter", "value[x]"] ->
        /// ["Bundle", "entry", "resource", "parameter", ]
        ///
        /// and fieldName = "value"
        ///
        /// Then we create the new last entry in the path, we just do this by
        /// adding fieldName (value) in our example, to the current element.type
        /// where we change the case of the first letter because that's how
        /// FHIR works.
        ///
        /// So if fieldName == "value" and the list of codes includes
        /// "boolean" and "dateTime", then we would create the new fields as
        /// "valueBoolean" and "valueDateTime"
        for (var type in element.type!) {
          pathsList
            ..removeLast()
            ..add(
                '$fieldName${type.code.toString().substring(0, 1).toUpperCase()}${type.code.toString().substring(1)}');

          final tempPath = pathsList.join('.');

          /// We are now finally ready to recreate the path.
          if (noIndexesPath == tempPath) {
            fhirPathMatches = addToFhirPathMatches(
              fhirPathMatches: fhirPathMatches,
              key: key,
              type: element.type,
              noIndex: noIndexesPath,
              fullMatch: pathsList.join('.'),
              binding: element.binding,
              constraint: null, //element.constraint,
            );
            return true;
          } else if (noIndexesPath.startsWith(tempPath)) {
            if (fhirPathMatches.keys.contains(key) &&
                fhirPathMatches[key]!.partialMatch != null &&
                fhirPathMatches[key]!.partialMatch!.length <
                    elementPath.length) {
              fhirPathMatches[key]!.partialMatch = elementPath;
            } else {
              /// If there's no key yet in the Map, we create one
              fhirPathMatches = addToFhirPathMatches(
                fhirPathMatches: fhirPathMatches,
                key: key,
                type: element.type,
                noIndex: noIndexesPath,
                partialMatch: elementPath,
                binding: element.binding,
                constraint: null, //element.constraint,
              );
            }
          }
        }
        return false;
      } else {
        /// Otherwise, since we're running through all of the paths anyway,
        /// we're going to check if there's a partial patch so that we don't
        /// have to run through them all again later
        if (noIndexesPath.startsWith(elementPath)) {
          /// We look to see if the fhirPathMatches already has the key, if
          /// not, we create a new entry. If it does have a key, we look to see
          /// the length of the partialMatch (when created, all partialMatches
          /// have an empty string or value, never null). If the current
          /// partialMatch is shorter than the elementPath, the elementPath
          /// is closer to the full path and replaces the old partialMatch Value
          /// For instance
          ///
          /// "Bundle.entry[9].resource" is the current partialMatch in
          /// fhirPathMatches. However, the current elementPath is
          /// "Bundle.entry[9].resource.valueCoding", because this is longer,
          /// the partialMatch is updated
          if (fhirPathMatches.keys.contains(key) &&
              fhirPathMatches[key]!.partialMatch != null &&
              fhirPathMatches[key]!.partialMatch!.length < elementPath.length) {
            fhirPathMatches[key]!.partialMatch = elementPath;
          } else {
            /// If there's no key yet in the Map, we create one
            fhirPathMatches = addToFhirPathMatches(
              fhirPathMatches: fhirPathMatches,
              key: key,
              type: element.type,
              noIndex: noIndexesPath,
              partialMatch: elementPath,
              binding: element.binding,
              constraint: null, //element.constraint,
            );
          }
        }

        /// Similar to above, there may still be a partial match if the entry
        /// is polymorphic, so we have to do some messing around, remove the
        /// final "[x]" from the String, test it against the path, etc.
        else if (elementPath.endsWith('[x]') &&
            element.type != null &&
            element.type!.isNotEmpty) {
          final pathsList = elementPath.split('.');
          var fieldName = pathsList.last.replaceAll('[x]', '');
          for (var type in element.type!) {
            pathsList
              ..removeLast()
              ..add('$fieldName'
                  '${type.code.toString().substring(0, 1).toUpperCase()}'
                  '${type.code.toString().substring(1)}');

            final tempPaths = pathsList.join('.');

            /// However, in this case, we're not looking for an exact match,
            /// because if there was we should have found it above.
            if (noIndexesPath.contains(tempPaths)) {
              fhirPathMatches = addToFhirPathMatches(
                fhirPathMatches: fhirPathMatches,
                key: key,
                type: element.type,
                noIndex: noIndexesPath,
                partialMatch: tempPaths,
                binding: element.binding,
                constraint: null, //element.constraint,
              );
            }
          }
        }
        return false;
      }
    });

    if (!fhirPathMatches.keys.contains(key) && !key.endsWith('resourceType')) {
      fhirPathMatches[key] = FhirValidationObject(noIndex: noIndexesPath);
    }

    /// If there is not, then it's possible this is a Resource or another
    /// StructureDefinition that we'll have to look in
    if (index != null && index != -1) {
      returnMap = checkMaxCardinalityOfJson(elementDefinitions![index], key,
          returnMap, startPath, fhirPaths, fhirPathMatches[key]);
    }
  }

  final downloads = <String, dynamic>{};
  final codes = <String, List<String>>{};

  /// We're going to check for bindings to various ValueSets, first there's
  /// a bunch of checking just to make sure it's available and not null
  ///
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
            /// I changed my mind. We're going to look online first since that
            /// version will probably be the most updated. If we can't find it
            /// online, OR we specifically state offline, then we look locally
            Map<String, dynamic>? valueSetMap;

            /// First get the canonical (remember, while this is usually a url
            /// where it can be accessed, that's not always true)
            var canonical = value.binding!.valueSet.toString();

            /// As long as we're online
            if (online) {
              /// We check and see if it's already been downloaded, if it has,
              /// just use that
              if (downloads.keys.contains(canonical)) {
                valueSetMap = downloads[canonical];
              } else {
                /// Otherwise, try and request it
                valueSetMap = await requestFromCanonical(canonical);
                if (valueSetMap != null &&
                        valueSetMap['resourceType'] == 'ValueSet' ||
                    valueSetMap!['resourceType'] == 'CodeSystem') {
                  downloads[canonical] = valueSetMap;
                }
              }
            }

            /// Only if we haven't found it yet
            if (valueSetMap == null) {
              /// We try and find it in the local map
              valueSetMap = valueSetMaps[canonical];

              /// If it's still null, we split off version numbers from the end
              /// because sometimes that messes it up
              if (valueSetMap == null) {
                canonical = canonical.split('|').first;
                valueSetMap = valueSetMaps[canonical];
              }
            }

            if (valueSetMap == null) {
              returnMap = addToMap(returnMap, startPath, key,
                  "This value has a binding ValueSet @ ${value.binding!.valueSet} but wasn't found");
            }

            /// We're going to go through the ValueSet and make a List of any
            /// codes that we find
            if (valueSetMap != null) {
              final valueSet = ValueSet.fromJson(valueSetMap);

              /// We only have to go through this ValueSet if we don't already
              /// have the codes
              if (!codes.keys.contains(canonical)) {
                codes[canonical] = [];

                /// For each CodeSystem that might be included in the ValueSet
                /// we look to see if individual codes are listed first. If
                /// they are, these are the only codes that we need to include
                /// from that CodeSystem. However, sometimes it's just the
                /// Canonical for the CodeSystem and we have to include the
                /// entire thing. For these we once again have to go and make
                /// a request to find it.
                for (var include
                    in valueSet.compose?.include ?? <ValueSetInclude>[]) {
                  if (include.concept?.isNotEmpty ?? false) {
                    for (var concept in include.concept!) {
                      if (concept.code != null) {
                        codes[canonical]!.add(concept.code.toString());
                      }
                    }
                  } else if (include.system != null) {
                    Map<String, dynamic>? codeSystemMap;
                    canonical = include.system.toString();

                    /// As long as we're online
                    if (online) {
                      /// We check and see if it's already been downloaded, if it has,
                      /// just use that
                      if (downloads.keys.contains(include.system.toString())) {
                        codeSystemMap = downloads[include.system];
                      } else {
                        /// Otherwise, try and request it
                        codeSystemMap = await requestFromCanonical(canonical);
                        if (codeSystemMap != null &&
                                codeSystemMap['resourceType'] == 'ValueSet' ||
                            codeSystemMap!['resourceType'] == 'CodeSystem') {
                          downloads[canonical] = codeSystemMap;
                        }
                      }

                      /// only if we haven't found it yet
                      if (codeSystemMap == null) {
                        /// We try and find it in the local map
                        codeSystemMap = codeSystemMaps[canonical];

                        /// If it's still null, we split off version numbers from the end
                        /// because sometimes that messes it up
                        if (codeSystemMap == null) {
                          canonical = canonical.split('|').first;
                          codeSystemMap = codeSystemMaps[canonical];
                        }
                      }

                      if (codeSystemMap != null) {
                        final codeSystem = CodeSystem.fromJson(codeSystemMap);
                        for (var concept
                            in codeSystem.concept ?? <CodeSystemConcept>[]) {
                          if (concept.code != null) {
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
    }
    final constraints = fhirPathMatches[key]?.constraint;
    for (final constraint in constraints ?? <ElementDefinitionConstraint>[]) {
      print(
          '${fullPathFromStartAndCurrent(startPath, key)}.where(${constraint.expression})');
      print(walkFhirPath(
          context: mapToValidate,
          pathExpression:
              '${fullPathFromStartAndCurrent(startPath, key)}.where(${constraint.expression})'
                  .replaceAll('[x]', '')));
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
        if (!returnMap.keys.contains(key)) {
          returnMap[key] = <String>[];
        }
        returnMap[key]!.add(
            "Unrecognized property, '$key', not found in the StructureDefinition");
      } else {
        if (!partialMatchMap.keys.contains(partialMatch)) {
          partialMatchMap[partialMatch] = <String, dynamic>{};
        }
        partialMatchMap[partialMatch][key] = fhirPaths[key];
      }
    }
  }

  /// remove all indexes for the moment
  for (var key in partialMatchMap.keys) {
    final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');
    final elementDefinitionIndex = elementDefinitions
        ?.indexWhere((element) => element.path == noIndexesPath);

    /// ToDo(Dokotela): handle if unable to find
    if (elementDefinitionIndex != null && elementDefinitionIndex != -1) {
      final types = elementDefinitions?[elementDefinitionIndex].type;

      /// ToDo(Dokotela): handle for all cases
      if (types == null) {
      } else if (types.isEmpty) {
      } else {
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
          } else {
            final newStructureDefinition = structureDefinitionMaps[newType];
            if (newStructureDefinition == null) {
            } else {
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

  /// This feels like it should be easier. I need all of the paths in the
  /// current StructureDefinition. This is where we're going to store paths
  /// that still might be required. We do this because there are some subfields
  /// that are required, but only if a superfield is present, and that superfield
  /// may not be required. Por ejemplo:
  ///
  /// A Narrative is an optional field in all Resources. However, if there is
  /// a Narrative object as part of that resource, it is required to have a
  /// status.
  final structureDefinitionPaths =
      structureDefinition.snapshot?.element.map((e) => e.path).toList() ??
          <String>[];

  /// While there shouldn't be any null values, we remove just in case
  structureDefinitionPaths.removeWhere((element) => element == null);

  /// Then we go back though all of the definitions, again
  for (var element
      in structureDefinition.snapshot?.element ?? <ElementDefinition>[]) {
    if (structureDefinitionPaths.contains(element.path) &&
        element.path != type) {
      bool found = false;

      /// Once the elementDefinition path is found, we mark it, but don't have
      /// to do anything more for it at the moment
      for (var key in fhirPaths.keys) {
        if (key.replaceAll(RegExp(r'\[[0-9]+\]'), '') == element.path) {
          found = true;
          break;
        }
      }

      /// If the current Path is not found
      if (!found) {
        /// But it is required, then we note this as an error
        if (element.min != null &&
            element.min?.value != null &&
            element.min!.value! > 0) {
          if (element.path != null) {
            final fullPath =
                fullPathFromStartAndCurrent(startPath, element.path ?? '');
            if (!returnMap.keys.contains(fullPath)) {
              returnMap[fullPath] = <String>[];
            }
            returnMap[fullPath]!.add(
                'This property is required by the StructureDefinition but has no value. '
                'Cardinality: ${element.min ?? "not defined"}..${element.max ?? "not defined"}');
          }
        } else {
          /// However if it's not required AND we don't find it, we don't need
          /// to worry about it AND we don't need to worry about anything that
          /// may be a subfield of that path
          if (element.path != null) {
            structureDefinitionPaths
                .removeWhere((e) => e!.startsWith(element.path!));
          }
        }
      } else {
        // TODO(Dokotela): ensure the proper Cardinality of > 0
      }
    }
  }

  return returnMap;
}

Future<String> notInValueSetMessage(
    dynamic value, FhirCanonical? valueSetCanonical, String message) async {
  if (valueSetCanonical == null) {
    return "There was an error in our software evaluating the value ($value), please let us know.";
  }
  final valueSetMap = await requestFromCanonical(valueSetCanonical.toString());

  if (valueSetMap != null) {
    final valueSet = ValueSet.fromJson(valueSetMap);
    if (valueSet.title != null) {
      return "The value provided ($value) is not from the ValueSet ${valueSet.title} ($valueSetCanonical), $message.";
    } else if (valueSet.name != null) {
      return "The value provided ($value) is not from the ValueSet ${valueSet.name}} ($valueSetCanonical), $message.";
    }
  }
  return "The value provided ($value) is not from the ValueSet ($valueSetCanonical), $message.";
}

Future<Map<String, dynamic>?> requestFromCanonical(String canonical) async {
  Map<String, dynamic>? downloadedMap;
  try {
    final response = await get(Uri.parse(canonical),
        headers: {'Accept': 'application/fhir+json'});
    if (response.statusCode == 200) {
      downloadedMap = jsonDecode(response.body);
    }
    return downloadedMap;
  } catch (e) {
    return null;
  }
}
