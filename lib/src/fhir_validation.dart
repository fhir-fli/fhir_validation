import 'systems/system_loader.dart';
import 'package:fhir_primitives/fhir_primitives.dart';

class FhirValidator {
  FhirValidator();

  /// Validates a FHIR resource against its structure definition.
  Future<Map<String, List<String>?>> validateFhirResource(
      Map<String, dynamic> resourceToValidate) async {
    final String? type = resourceToValidate['resourceType'];
    if (type == null) {
      return {
        'resource': ['No resourceType was found']
      };
    } else {
      final Map<String, dynamic>? structureDefinition =
          await getStructureDefinition(type);
      if (structureDefinition == null) {
        return {
          'resource': ['No structureDefinition was found for $type']
        };
      } else {
        return await validateFhir(resourceToValidate, structureDefinition);
      }
    }
  }

  /// Validates a FHIR resource given its structure definition.
  Future<Map<String, List<String>?>> validateFhir(
      Map<String, dynamic> resourceToValidate,
      Map<String, dynamic> structureDefinition) async {
    var returnMap = <String, List<String>?>{};
    returnMap =
        await _validateFhirMaps(resourceToValidate, structureDefinition);
    return returnMap;
  }

  /// Validates a FHIR resource map against its structure definition.
  Future<Map<String, List<String>?>> _validateFhirMaps(
      Map<String, dynamic> mapToValidate,
      Map<String, dynamic> structureDefinition) async {
    var returnMap = <String, List<String>?>{};

    // Create a list of all paths in the mapToValidate.
    final fhirPaths = _fhirPathsFromMap(
        value: mapToValidate, path: structureDefinition['url']);

    // Evaluate the paths against the structure definition.
    returnMap =
        await _evaluateFromPaths(fhirPaths, structureDefinition, mapToValidate);

    return returnMap;
  }

  /// Creates a list of all paths in the mapToValidate.
  Map<String, dynamic> _fhirPathsFromMap(
      {required dynamic value, required String path}) {
    final returnMap = <String, dynamic>{};
    if (value is Map) {
      for (var key in value.keys) {
        if (value[key] is Map) {
          returnMap
              .addAll(_fhirPathsFromMap(value: value[key], path: '$path.$key'));
        } else if (value[key] is List) {
          for (var i = 0; i < value[key].length; i++) {
            returnMap.addAll(_fhirPathsFromMap(
                value: value[key][i], path: '$path.$key[$i]'));
          }
        } else {
          returnMap['$path.$key'] = value[key];
        }
      }
    } else if (value is List) {
      for (var i = 0; i < value.length; i++) {
        returnMap.addAll(_fhirPathsFromMap(value: value[i], path: '$path[$i]'));
      }
    } else {
      returnMap[path] = value.toString();
    }
    return returnMap;
  }

  /// Evaluates paths in the FHIR resource against the structure definition.
  Future<Map<String, List<String>?>> _evaluateFromPaths(
      Map<String, dynamic> fhirPaths,
      Map<String, dynamic> structureDefinition,
      Map<String, dynamic> mapToValidate) async {
    var returnMap = <String, List<String>?>{};

    final elementDefinitions =
        structureDefinition['snapshot']['element'] as List<dynamic>;

    // Validate structure, cardinality, value domains, bindings, and invariants.
    for (var key in fhirPaths.keys) {
      final noIndexesPath = key.replaceAll(RegExp(r'\[[0-9]+\]'), '');
      final matchingElement = elementDefinitions.firstWhere(
        (element) => element['path'] == noIndexesPath,
        orElse: () => null,
      );

      if (matchingElement == null) {
        returnMap = _addToMap(
            returnMap, key, 'Structure validation failed: Unrecognized path');
      } else {
        // Check cardinality
        final min = matchingElement['min'];
        final max = matchingElement['max'];
        final actualCount = fhirPaths[key] is List ? fhirPaths[key].length : 1;

        if (min != null && actualCount < min) {
          returnMap = _addToMap(returnMap, key,
              'Cardinality validation failed: Minimum cardinality of $min not met');
        }
        if (max != null && max != '*' && actualCount > int.parse(max)) {
          returnMap = _addToMap(returnMap, key,
              'Cardinality validation failed: Maximum cardinality of $max exceeded');
        }

        // Check value domains
        final type = matchingElement['type'] as List<dynamic>?;
        if (type != null && type.isNotEmpty) {
          final primitiveType = type.first['code'];
          if (!_isValidPrimitive(primitiveType, fhirPaths[key])) {
            returnMap = _addToMap(returnMap, key,
                'Value domain validation failed: Invalid value for type $primitiveType');
          }
        }

        // Check bindings
        final binding = matchingElement['binding'];
        if (binding != null) {
          final valueSetUrl = binding['valueSet'];
          if (valueSetUrl != null) {
            final valueSet = await getValueSet(valueSetUrl);
            if (valueSet != null && !_isValidCode(valueSet, fhirPaths[key])) {
              returnMap = _addToMap(returnMap, key,
                  'Coding validation failed: Code not found in ValueSet $valueSetUrl');
            }
          }
        }

        // Check invariants
        final constraints = matchingElement['constraint'] as List<dynamic>?;
        if (constraints != null) {
          for (var constraint in constraints) {
            final expression = constraint['expression'];
            // Implement your logic to validate the expression here
          }
        }
      }
    }

    // Check profiles
    final profiles = structureDefinition['extension']?.where((extension) =>
        extension['url'] ==
        'http://hl7.org/fhir/StructureDefinition/structuredefinition-profile');
    if (profiles != null && profiles.isNotEmpty) {
      for (var profile in profiles) {
        final profileUrl = profile['valueUrl'];
        await _validateProfile(profileUrl, mapToValidate, returnMap);
      }
    }

    return returnMap;
  }

  /// Validates if the value conforms to the specified primitive type.
  bool _isValidPrimitive(String primitiveType, dynamic value) {
    try {
      switch (primitiveType) {
        case 'base64binary':
          return FhirBase64Binary.fromJson(value).isValid;
        case 'boolean':
          return FhirBoolean.fromJson(value).isValid;
        case 'canonical':
          return FhirCanonical.fromJson(value).isValid;
        case 'code':
          return FhirCode.fromJson(value).isValid;
        case 'date':
          return FhirDate.fromJson(value).isValid;
        case 'decimal':
          return FhirDecimal.fromJson(value).isValid;
        case 'dateTime':
          return FhirDateTime.fromJson(value).isValid;
        case 'uri':
          return FhirUri.fromJson(value).isValid;
        case 'url':
          return FhirUrl.fromJson(value).isValid;
        case 'id':
          return FhirId.fromJson(value).isValid;
        case 'instant':
          return FhirInstant.fromJson(value).isValid;
        case 'integer':
          return FhirInteger.fromJson(value).isValid;
        case 'integer64':
          return FhirInteger64.fromJson(value).isValid;
        case 'markdown':
          return FhirMarkdown.fromJson(value).isValid;
        case 'xhtml':
          return FhirMarkdown(value).isValid;
        case 'oid':
          return FhirOid.fromJson(value).isValid;
        case 'positiveInt':
          return FhirPositiveInt.fromJson(value).isValid;
        case 'time':
          return FhirTime.fromJson(value).isValid;
        case 'unsignedInt':
          return FhirUnsignedInt.fromJson(value).isValid;
        case 'uuid':
          return FhirUuid.fromJson(value).isValid;
        case 'string':
          return true; // Simple string validation
        default:
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Validates if the code is valid according to the ValueSet.
  bool _isValidCode(Map<String, dynamic> valueSet, dynamic value) {
    if (valueSet['compose'] != null) {
      for (var include in valueSet['compose']['include']) {
        if (include['concept'] != null) {
          for (var concept in include['concept']) {
            if (concept['code'] == value) {
              return true;
            }
          }
        }
      }
    }
    if (valueSet['expansion'] != null) {
      for (var contains in valueSet['expansion']['contains']) {
        if (contains['code'] == value) {
          return true;
        }
      }
    }
    return false;
  }

  /// Validates the resource against the specified profile.
  Future<void> _validateProfile(
      String profileUrl,
      Map<String, dynamic> resource,
      Map<String, List<String>?> returnMap) async {
    final profile = await getStructureDefinition(profileUrl);
    if (profile != null) {
      final profileElements = profile['snapshot']['element'] as List<dynamic>;
      for (var element in profileElements) {
        // Validate each element according to the profile
        // Implement specific profile validation logic here
      }
    } else {
      returnMap['profile'] = ['Profile not found: $profileUrl'];
    }
  }

  Map<String, List<String>?> _addToMap(
      Map<String, List<String>?> map, String key, String message) {
    if (!map.containsKey(key)) {
      map[key] = [];
    }
    map[key]!.add(message);
    return map;
  }
}
