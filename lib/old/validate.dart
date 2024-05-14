import 'dart:convert';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';

import '../src/systems/code_system_maps/code_system_maps.dart';
import '../src/systems/structure_definition_maps/structure_definition_maps.dart';
import '../src/utils/utils.dart';
import '../src/systems/value_set_maps/value_set_maps.dart';

// part 'check_cardinality_of_json.dart';
// part 'fhir_validation_object.dart';
part 'maps.dart';
// part 'fhir_paths_from_map.dart';

/// Function to validate a FHIR resource.
Future<Map<String, List<String>?>> validateFhirResource(
    Map<String, dynamic> resourceToValidate) async {
  // Extract the resource type from the resource.
  final String? type = resourceToValidate['resourceType'];
  if (type == null) {
    // Return an error if no resourceType is found.
    return {
      'resource': ['No resourceType was found']
    };
  } else if (!R4ResourceType.typesAsStrings.contains(type)) {
    // Return an error if the resourceType is not recognized.
    return {
      'resource': ['$type is not a recognized resourceType']
    };
  } else {
    // Retrieve the structure definition map for the given resource type.
    final structureDefinitionMap = structureDefinitionMaps[type];
    if (structureDefinitionMap == null) {
      // Return an error if no structure map is found for the resource type.
      return {
        'resource': ['No structureMap was found for $type']
      };
    } else {
      try {
        // Convert the structure definition map to a StructureDefinition object.
        final structureDefinition =
            StructureDefinition.fromJson(structureDefinitionMap);
        // Validate the FHIR resource using the structure definition.
        return await validateFhir(
            resourceToValidate: resourceToValidate,
            structureDefinition: structureDefinition);
      } catch (e, s) {
        // Catch and return any errors that occur during validation.
        return {
          'resource': [
            'There was an error with the Structuremap: $e',
            'The stack trace was: $s'
          ]
        };
      }
    }
  }
}

/// Function to validate a FHIR resource given its structure definition.
Future<Map<String, List<String>?>> validateFhir({
  required Map<String, dynamic> resourceToValidate,
  StructureDefinition? structureDefinition,
}) async {
  var returnMap = <String, List<String>?>{};

  // Retrieve the structure definition if it's not provided.
  structureDefinition ??=
      _getStructureDefinition(resourceToValidate['resourceType'], returnMap);

  if (structureDefinition == null) {
    return returnMap;
  }

  // Validate the FHIR resource against its structure definition.
  returnMap = await validateFhirMaps(
    mapToValidate: resourceToValidate,
    structureDefinition: structureDefinition,
    type: resourceToValidate['resourceType'],
    startPath: resourceToValidate['resourceType'],
  );

  return returnMap;
}

/// Helper function to get the structure definition for a given resource type.
StructureDefinition? _getStructureDefinition(
    String resourceType, Map<String, List<String>?> returnMap) {
  final definitionMap = structureDefinitionMaps[resourceType];
  if (definitionMap == null) {
    returnMap[resourceType] = [
      'No StructureDefinition was found for this Resource type'
    ];
    return null;
  }
  return StructureDefinition.fromJson(definitionMap);
}

/// Function to validate a FHIR resource map against its structure definition.
Future<Map<String, List<String>?>> validateFhirMaps({
  required Map<String, dynamic> mapToValidate,
  required StructureDefinition structureDefinition,
  required String type,
  required String startPath,
  bool online = true,
}) async {
  // Create a list of all paths in the mapToValidate.
  final fhirPaths = fhirPathsFromMap(value: mapToValidate, path: type);
  // Evaluate the paths against the structure definition.
  return await _evaluateFromPaths(
      fhirPaths, structureDefinition, type, startPath, online, mapToValidate);
}

Future<Map<String, List<String>?>> _evaluateFromPaths(
  Map<String, dynamic> fhirPaths,
  StructureDefinition structureDefinition,
  String type,
  String startPath,
  bool online,
  Map<String, dynamic> mapToValidate,
) async {
  var returnMap = <String, List<String>?>{};

  // Remove the resourceType from the paths as it's not in the StructureDefinition.
  fhirPaths.removeWhere((key, value) => key == '$type.resourceType');

  var fhirPathMatches = <String, FhirValidationObject>{};
  final elementDefinitions = structureDefinition.snapshot?.element;

  // Look at every key in the map.
  for (var key in fhirPaths.keys) {
    // Remove all indexes for the moment.
    final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');

    // Check if there is a path in the current StructureDefinition that corresponds to this path.
    var index = elementDefinitions
        ?.indexWhere((element) => element.path == noIndexesPath);
    index = index == -1 ? null : index;

    if (index != null) {
      // If found, add to FhirPathMatches.
      fhirPathMatches = addToFhirPathMatches(
        fhirPathMatches: fhirPathMatches,
        key: key,
        noIndex: noIndexesPath,
        fullMatch: elementDefinitions![index].path!,
        type: elementDefinitions[index].type,
        binding: elementDefinitions[index].binding,
        constraint: elementDefinitions[index].constraint,
      );
      // Check max cardinality of the JSON.
      returnMap = checkCardinalityOfJson(elementDefinitions[index], key,
          returnMap, startPath, fhirPaths, fhirPathMatches[key]);
    } else {
      // If the path is not found in the structure definition, add an error.
      returnMap = addToMap(returnMap, startPath, key,
          'The path $key is not defined in the StructureDefinition for $type');
    }
  }

  final downloads = <String, dynamic>{};
  final codes = <String, List<String>>{};

  // Check for bindings to various ValueSets.
  for (final key in fhirPathMatches.keys) {
    final validationObject = fhirPathMatches[key]!;
    if (validationObject.fullMatch != null) {
      returnMap = await _validateBindingsAndConstraints(validationObject, key,
          startPath, returnMap, fhirPaths, downloads, codes, online);
    }
  }

  return returnMap;
}

/// Function to validate bindings and constraints for a FHIR resource path.
Future<Map<String, List<String>?>> _validateBindingsAndConstraints(
  FhirValidationObject validationObject,
  String key,
  String startPath,
  Map<String, List<String>?> returnMap,
  Map<String, dynamic> fhirPaths,
  Map<String, dynamic> downloads,
  Map<String, List<String>> codes,
  bool online,
) async {
  final binding = validationObject.binding;
  final type = validationObject.type;
  final value = fhirPaths[key];

  // Validate primitive types.
  if (type != null && !isValueAValidPrimitive(type, value)) {
    returnMap = addToMap(returnMap, startPath, key,
        "This property should be a type '${type}' but it is invalid");
  }

  // Validate bindings to ValueSets.
  if (binding?.valueSet != null &&
      binding!.strength != ElementDefinitionBindingStrength.example) {
    final canonical = binding.valueSet.toString();
    final valueSetMap = await _getValueSetMap(canonical, downloads, online);

    if (valueSetMap == null) {
      returnMap = addToMap(
          returnMap, startPath, key, "ValueSet not found at $canonical");
    } else {
      final valueSet = ValueSet.fromJson(valueSetMap);
      final codesList = _extractCodesFromValueSet(
          valueSet, canonical, downloads, codes, online);

      if (codesList.isNotEmpty && !codesList.contains(value)) {
        returnMap = _addInvalidValueMessage(
            returnMap, key, startPath, value, canonical, binding.strength!);
      }
    }
  }

  // Validate constraints.
  for (final constraint
      in validationObject.constraint ?? <ElementDefinitionConstraint>[]) {
    final path =
        '${fullPathFromStartAndCurrent(startPath, key)}.where(${constraint.expression})';
    final result = walkFhirPath(
        context: value, pathExpression: path.replaceAll('[x]', ''));
    // Add constraint validation results if needed.
  }

  return returnMap;
}

/// Function to get a ValueSet map from a canonical URL.
Future<Map<String, dynamic>?> _getValueSetMap(
    String canonical, Map<String, dynamic> downloads, bool online) async {
  if (downloads.containsKey(canonical)) {
    return downloads[canonical];
  } else if (online) {
    final valueSetMap = await requestFromCanonical(canonical);
    if (valueSetMap != null) {
      downloads[canonical] = valueSetMap;
    }
    return valueSetMap;
  } else {
    return valueSetMaps[canonical] ?? valueSetMaps[canonical.split('|').first];
  }
}

/// Function to extract codes from a ValueSet.
List<String> _extractCodesFromValueSet(
    ValueSet valueSet,
    String canonical,
    Map<String, dynamic> downloads,
    Map<String, List<String>> codes,
    bool online) {
  if (!codes.containsKey(canonical)) {
    codes[canonical] = [];

    for (var include in valueSet.compose?.include ?? <ValueSetInclude>[]) {
      if (include.concept?.isNotEmpty ?? false) {
        codes[canonical]!
            .addAll(include.concept!.map((concept) => concept.code.toString()));
      } else if (include.system != null) {
        final codeSystemMap =
            _getCodeSystemMap(include.system.toString(), downloads, online);
        final codeSystem = CodeSystem.fromJson(codeSystemMap);
        codes[canonical]!.addAll(
            codeSystem.concept!.map((concept) => concept.code.toString()));
      }
    }
  }

  return codes[canonical]!;
}

/// Function to get a CodeSystem map from a canonical URL.
Future<Map<String, dynamic>?> _getCodeSystemMap(
    String canonical, Map<String, dynamic> downloads, bool online) async {
  if (downloads.containsKey(canonical)) {
    return downloads[canonical];
  } else if (online) {
    final codeSystemMap = await requestFromCanonical(canonical);
    if (codeSystemMap != null) {
      downloads[canonical] = codeSystemMap;
    }
    return codeSystemMap;
  } else {
    return codeSystemMaps[canonical] ??
        codeSystemMaps[canonical.split('|').first];
  }
}

/// Function to add an invalid value message to the return map.
Map<String, List<String>?> _addInvalidValueMessage(
  Map<String, List<String>?> returnMap,
  String key,
  String startPath,
  dynamic value,
  String canonical,
  ElementDefinitionBindingStrength strength,
) {
  final message = (strength == ElementDefinitionBindingStrength.required_)
      ? "is required to be"
      : (strength == ElementDefinitionBindingStrength.extensible)
          ? "probably should be"
          : "is encouraged to be";

  return addToMap(returnMap, startPath, key,
      "The value provided ($value) is not from the ValueSet ($canonical), $message");
}

/// Function to request a resource from a canonical URL.
// Future<Map<String, dynamic>?> requestFromCanonical(String canonical,
//     [Client? client]) async {
//   try {
//     final response = await (client?.get(Uri.parse(canonical),
//             headers: {'Accept': 'application/fhir+json'}) ??
//         get(Uri.parse(canonical),
//             headers: {'Accept': 'application/fhir+json'}));
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     }
//   } catch (e) {
//     // Handle exception or logging.
//   }
//   return null;
// }

/// Checks the cardinality of a given JSON element and updates the
/// returnMap with validation errors if the cardinality rules are violated.
Map<String, List<String>?> checkCardinalityOfJson(
  ElementDefinition elementDefinition,
  String key,
  Map<String, List<String>?> returnMap,
  String startPath,
  Map<String, dynamic> fhirPaths,
  FhirValidationObject? fhirValidationObject,
) {
  // Check if the maximum cardinality is specified and greater than 1 or unlimited (*)
  // Also check if the minimum cardinality is greater than 1
  if ((elementDefinition.max != null &&
          (elementDefinition.max == '*' ||
              ((int.tryParse(elementDefinition.max!) ?? 0) > 1))) ||
      (elementDefinition.min != null &&
          (elementDefinition.min?.value ?? 0) > 1)) {
    // If the field is not a list, it indicates an error
    if (fhirPaths[key] is! List) {
      final maybeIndex = pathIndexIfAvailable(key);

      // If maybeIndex is null, it's not a list or indexed, so this is an error
      if (maybeIndex == null) {
        returnMap = addToMap(
            returnMap,
            startPath,
            key,
            'This path is not a list (or one of a list), although it should be. '
            'Minimum Cardinality: ${elementDefinition.min ?? "none defined"}. '
            'Maximum Cardinality: ${elementDefinition.max ?? "none defined"}');
      }
      // If it is indexed and exceeds the maximum cardinality, it's an error
      else if (elementDefinition.max != '*' &&
          maybeIndex >= int.parse(elementDefinition.max!)) {
        returnMap = addToMap(
            returnMap,
            startPath,
            key,
            'The value at this path does not match the Maximum Cardinality for this field. '
            'Minimum Cardinality: ${elementDefinition.min ?? "none defined"}. '
            'Number of items or index in this list: '
            '${fhirPaths[key] is List ? fhirPaths[key].length : maybeIndex}');
      }
    } else {
      // If it is a list, check if it exceeds the maximum cardinality allowed
      if (elementDefinition.max != null &&
          elementDefinition.max != '*' &&
          int.tryParse(elementDefinition.max!) != null) {
        if (fhirPaths[key].length > int.parse(elementDefinition.max!)) {
          returnMap = addToMap(
              returnMap,
              startPath,
              key,
              'The value at this path has more items than is allowed. '
              'Maximum Cardinality: ${elementDefinition.max ?? "none defined"}. '
              'Item number in this list: ${fhirPaths[key].length}');
        }
      }
    }
  }
  // Check for minimum cardinality
  if (elementDefinition.min != null &&
      (elementDefinition.min?.value ?? 0) > 0) {
    if (fhirPaths[key] == null ||
        (fhirPaths[key] is List &&
            fhirPaths[key].length < elementDefinition.min!.value!)) {
      returnMap = addToMap(
          returnMap,
          startPath,
          key,
          'The value at this path does not match the Minimum Cardinality for this field. '
          'Minimum Cardinality: ${elementDefinition.min?.value ?? "none defined"}. '
          'Number of items in this list: ${fhirPaths[key] is List ? fhirPaths[key].length : 0}');
    }
  }
  // If the maximum cardinality is 1, ensure the field is not a list
  else if (elementDefinition.max != null &&
      elementDefinition.max != '*' &&
      (int.tryParse(elementDefinition.max!) ?? 0) == 1) {
    if (fhirPaths[key] is List) {
      returnMap = addToMap(returnMap, startPath, key,
          notArrayMessage(fhirValidationObject, elementDefinition));
    } else {
      final maybeIndex = pathIndexIfAvailable(key);
      if (maybeIndex != null) {
        returnMap = addToMap(returnMap, startPath, key,
            notArrayMessage(fhirValidationObject, elementDefinition));
      }
    }
  }
  return returnMap;
}

/// Generates an error message indicating that the property should not be an array.
String notArrayMessage(FhirValidationObject? fhirValidationObject,
        ElementDefinition elementDefinition) =>
    'This property must be a ${fhirValidationObject?.type}, not an Array. '
    'Cardinality: ${elementDefinition.min ?? "none defined"}..${elementDefinition.max ?? "none defined"}';

/// This function runs through the current Resource and creates a single-level
/// map where everything is a String : primitive pair. The String in this case
/// is the fhirPath to the object (including indexes) and the primitive is the
/// actual value of that object.
Map<String, dynamic> fhirPathsFromMap({
  required dynamic value,
  required String path,
}) {
  final returnMap = <String, dynamic>{};

  if (value is Map) {
    // Iterate over each key-value pair in the Map.
    for (var key in value.keys) {
      if (value[key] is Map) {
        // If the value is a Map, recursively process it.
        returnMap
            .addAll(fhirPathsFromMap(value: value[key], path: '$path.$key'));
      } else if (value[key] is List) {
        // If the value is a List, process each element with its index.
        for (var i = 0; i < value[key].length; i++) {
          returnMap.addAll(
              fhirPathsFromMap(value: value[key][i], path: '$path.$key[$i]'));
        }
      } else {
        // Otherwise, add the key-value pair to the returnMap.
        returnMap['$path.$key'] = value[key];
      }
    }
  } else if (value is List) {
    // If the value is a List, process each element with its index.
    for (var i = 0; i < value.length; i++) {
      returnMap.addAll(fhirPathsFromMap(value: value[i], path: '$path[$i]'));
    }
  } else {
    // If the value is a primitive, add it directly to the returnMap.
    returnMap[path] = value.toString();
  }

  return returnMap;
}

/// This function combines the startPath with the currentPath to generate a full path.
/// It removes the first segment from the currentPath and appends the remaining
/// segments to the startPath.
String fullPathFromStartAndCurrent(String startPath, String currentPath) {
  var pathList = currentPath.split('.');
  pathList.removeAt(0);
  pathList = [startPath, ...pathList];
  return pathList.join('.');
}

/// This function checks if the provided path ends with an index in square brackets.
/// If it does, it returns the index as an integer. Otherwise, it returns null.
int? pathIndexIfAvailable(String path) {
  // Check if the path ends with an index enclosed in square brackets.
  final lastOpenBracket = path.lastIndexOf('[') + 1;
  final lastClosedBracket = path.lastIndexOf(']');
  if (lastOpenBracket == 0 ||
      lastClosedBracket == -1 ||
      lastClosedBracket != path.length - 1) {
    return null;
  } else {
    return int.tryParse(path.substring(lastOpenBracket, lastClosedBracket));
  }
}

/// Class representing a FhirValidationObject.
class FhirValidationObject {
  FhirValidationObject({
    required this.noIndex,
    this.fullMatch = '',
    this.partialMatch = '',
    this.type = '',
    this.binding,
    this.constraint,
  });

  String noIndex;
  String? fullMatch;
  String? partialMatch;
  String? type;
  ElementDefinitionBinding? binding;
  List<ElementDefinitionConstraint>? constraint;

  Map<String, dynamic> toJson() => {
        'noIndex': noIndex,
        'fullMatch': fullMatch,
        'partialMatch': partialMatch,
        'type': type,
        'binding': binding?.toJson(),
        'constraint': constraint?.map((e) => e.toJson()).toList(),
      };
}

/// Adds a FhirValidationObject to the fhirPathMatches map.
Map<String, FhirValidationObject> addToFhirPathMatches({
  required Map<String, FhirValidationObject> fhirPathMatches,
  required String key,
  required String noIndex,
  String? fullMatch,
  String? partialMatch,
  required List<ElementDefinitionType>? type,
  required ElementDefinitionBinding? binding,
  required List<ElementDefinitionConstraint>? constraint,
}) {
  if (fhirPathMatches.containsKey(key)) {
    fhirPathMatches[key]!.noIndex = noIndex;
    fhirPathMatches[key]!.fullMatch =
        fullMatch ?? fhirPathMatches[key]!.fullMatch;
    fhirPathMatches[key]!.partialMatch =
        partialMatch ?? fhirPathMatches[key]!.partialMatch;
    if (fhirPathMatches[key]!.constraint == null) {
      fhirPathMatches[key]!.constraint = constraint;
    } else if (constraint != null) {
      fhirPathMatches[key]!.constraint = [
        ...fhirPathMatches[key]!.constraint!,
        ...constraint
      ];
    }
  } else {
    fhirPathMatches[key] = FhirValidationObject(
      noIndex: noIndex,
      fullMatch: fullMatch,
      partialMatch: partialMatch,
      constraint: constraint,
    );
  }
  if (fullMatch != null) {
    if (type != null && type.isNotEmpty) {
      if (type.length == 1) {
        fhirPathMatches[key]!.type =
            primitiveTypes[type.first.code.toString()] ??
                type.first.code.toString();
      }
    }
    if (binding != null) {
      fhirPathMatches[key]!.binding = binding;
    }
  }
  return fhirPathMatches;
}

const primitiveTypes = {
  'http://hl7.org/fhirpath/System.Boolean': 'boolean',
  'http://hl7.org/fhirpath/System.Date': 'date',
  'http://hl7.org/fhirpath/System.DateTime': 'dateTime',
  'http://hl7.org/fhirpath/System.Decimal': 'decimal',
  'http://hl7.org/fhirpath/System.Integer': 'integer',
  'http://hl7.org/fhirpath/System.Time': 'time',
  'http://hl7.org/fhirpath/System.String': 'string',
};
