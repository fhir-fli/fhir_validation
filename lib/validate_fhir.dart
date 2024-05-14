import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';

// Main validation function
Future<Map<String, List<String>?>> validateFhir({
  required Map<String, dynamic> resourceToValidate,
  StructureDefinition? structureDefinition,
}) async {
  var returnMap = <String, List<String>?>{};

  final type = resourceToValidate['resourceType'];
  if (type == null) {
    return {
      'resource': ['No resourceType was found']
    };
  }

  // Extract profiles from the resource
  final profiles = extractProfiles(resourceToValidate);
  List<Map<String, dynamic>> profileDefinitions = [];

  // Retrieve profile definitions if they exist
  for (var profile in profiles) {
    try {
      final profileDef = await getProfile(profile);
      if (profileDef != null) {
        profileDefinitions.add(profileDef);
      }
    } catch (e) {
      return {
        'resource': ['Failed to retrieve profile definition: $profile']
      };
    }
  }

  // If no profiles are found, use the regular structure definition
  if (profileDefinitions.isEmpty) {
    if (structureDefinition == null) {
      final definitionMap = await getStructureDefinition(type);
      if (definitionMap == null) {
        returnMap[type] = [
          'No StructureDefinition was found for this Resource, which is a resourceType of: $type'
        ];
      } else {
        structureDefinition = StructureDefinition.fromJson(definitionMap);
      }
    }
    if (structureDefinition == null) {
      if (returnMap[type] == null || returnMap[type]!.isEmpty) {
        returnMap[type] = [
          'No StructureDefinition was found for this Resource, which is a resourceType of: $type'
        ];
      } else {
        returnMap[type]!.add(
            'No StructureDefinition was found for this Resource, which is a resourceType of: $type');
      }
    } else {
      returnMap = combineMaps(
        returnMap,
        await validateFhirMaps(
          mapToValidate: resourceToValidate,
          structureDefinition: structureDefinition,
          type: type,
          startPath: type,
        ),
      );
    }
  } else {
    // Validate against profiles
    for (var profileDef in profileDefinitions) {
      returnMap = combineMaps(
        returnMap,
        await validateFhirMaps(
          mapToValidate: resourceToValidate,
          structureDefinition: StructureDefinition.fromJson(profileDef),
          type: type,
          startPath: type,
        ),
      );
    }
  }

  return returnMap;
}
