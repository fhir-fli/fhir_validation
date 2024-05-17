import 'dart:convert';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';

import 'fhir_validator_utils.dart';

class FhirValidator {
  var results = ValidationResults();

  ValidationResults _results() {
    final newResults = results.copyWith();
    results = ValidationResults();
    return newResults;
  }

  Future<ValidationResults> validateFhirResource({
    required Resource resourceToValidate,
    StructureDefinition? structureDefinition,
  }) {
    return validateFhirMap(
      resourceToValidate: resourceToValidate.toJson(),
      structureDefinition: structureDefinition,
    );
  }

  Future<ValidationResults> validateFhirString({
    required String resourceToValidate,
    StructureDefinition? structureDefinition,
  }) async {
    final resourceMap = json.decode(resourceToValidate) as Map<String, dynamic>;
    return validateFhirMap(
      resourceToValidate: resourceMap,
      structureDefinition: structureDefinition,
    );
  }

  Future<ValidationResults> validateFhirMap({
    required Map<String, dynamic> resourceToValidate,
    StructureDefinition? structureDefinition,
  }) async {
    final type = resourceToValidate['resourceType'] as String?;
    if (type == null) {
      results.addResult(
        null,
        'ResourceType is missing',
        Severity.error,
      );
      return _results();
    }
    // PrettyPrinting makes lines and columns correct
    final String resourceString = prettyPrintJson(resourceToValidate);

    // Parse the JSON with position information
    final node = parse(resourceString, Settings(), type);

    final FhirValidatorUtils utils = FhirValidatorUtils();

    if (structureDefinition != null) {
      // If structure definition is found, validate the resource against it
      results.combineResults(
        await utils.evaluateFromPaths(
          mapToValidate: resourceToValidate,
          structureDefinition: structureDefinition,
          type: type,
          startPath: type,
          node: node,
        ),
      );
      return _results();
    }

    // Retrieve profiles for the resource
    List<Map<String, dynamic>> profiles = await getProfiles(node);

    if (profiles.isNotEmpty) {
      // If profiles are found, validate the resource against each profile
      for (var profile in profiles) {
        results.combineResults(
          await utils.evaluateFromPaths(
            mapToValidate: resourceToValidate,
            structureDefinition: StructureDefinition.fromJson(profile),
            type: type,
            startPath: type,
            node: node,
          ),
        );
      }
      return _results();
    }

    // So we don't have profiles or a StructureDefinition, so we just go with
    // a generic StructureDefinition
    final definitionMap = await getStructureDefinition(type);
    if (definitionMap == null) {
      // If no structure definition is found, return an error
      results.addResult(
        null,
        'No StructureDefinition was found for this Resource, which is a resourceType of: $type',
        Severity.error,
      );
      return _results();
    } else {
      // Parse the structure definition from JSON
      structureDefinition = StructureDefinition.fromJson(definitionMap);
      results.combineResults(
        await utils.evaluateFromPaths(
          mapToValidate: resourceToValidate,
          structureDefinition: structureDefinition,
          type: type,
          startPath: type,
          node: node,
        ),
      );
      return _results();
    }
  }

  Future<List<Map<String, dynamic>>> getProfiles(Node node) async {
    // List to hold profile definitions retrieved
    List<Map<String, dynamic>> profileDefinitions = [];
    if (node is ObjectNode) {
      // Extract profiles from the resource if any are specified in the meta section
      final profiles = node.extractProfileNodes();

      // Retrieve profile definitions for each profile URL
      for (var profile in profiles) {
        try {
          final profileDef = await getProfile(profile.value);
          if (profileDef != null) {
            profileDefinitions.add(profileDef);
          }
        } catch (e) {
          // If there is an error retrieving a profile, return an error message
          results.addResult(
            null,
            'Failed to retrieve profile definition: $profile',
            Severity.error,
          );
        }
      }
    }

    return profileDefinitions;
  }
}
