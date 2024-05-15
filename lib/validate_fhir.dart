import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';

// Main validation function
Future<Map<String, dynamic>> validateFhir({
  required Map<String, dynamic> resourceToValidate,
  StructureDefinition? structureDefinition,
}) async {
  // Initialize a return map to store validation results
  var returnMap = <String, dynamic>{};

  // Extract the resourceType from the resource
  final type = resourceToValidate['resourceType'];
  if (type == null) {
    // If the resourceType is not found, return an error
    return {
      'resource': ['No resourceType was found']
    };
  }

  // Extract profiles from the resource if any are specified in the meta section
  final profiles = extractProfiles(resourceToValidate);
  // List to hold profile definitions retrieved
  List<Map<String, dynamic>> profileDefinitions = [];

  // Retrieve profile definitions for each profile URL
  for (var profile in profiles) {
    try {
      final profileDef = await getProfile(profile);
      if (profileDef != null) {
        profileDefinitions.add(profileDef);
      }
    } catch (e) {
      // If there is an error retrieving a profile, return an error message
      return {
        'resource': ['Failed to retrieve profile definition: $profile']
      };
    }
  }

  // If no profiles are found, use the regular structure definition
  if (profileDefinitions.isEmpty) {
    if (structureDefinition == null) {
      // Retrieve the structure definition for the resource type
      final definitionMap = await getStructureDefinition(type);
      if (definitionMap == null) {
        // If no structure definition is found, return an error
        returnMap[type] = [
          'No StructureDefinition was found for this Resource, which is a resourceType of: $type'
        ];
      } else {
        // Parse the structure definition from JSON
        structureDefinition = StructureDefinition.fromJson(definitionMap);
      }
    }
    if (structureDefinition == null) {
      // If structure definition is still null, add an error message to returnMap
      if (returnMap[type] == null || returnMap[type]!.isEmpty) {
        returnMap[type] = [
          'No StructureDefinition was found for this Resource, which is a resourceType of: $type'
        ];
      } else {
        returnMap[type]!.add(
            'No StructureDefinition was found for this Resource, which is a resourceType of: $type');
      }
    } else {
      // If structure definition is found, validate the resource against it
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
    // If profiles are found, validate the resource against each profile
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

  // Return the final map with validation results
  return returnMap;
}
