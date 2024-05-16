import 'dart:convert';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/validator_utils.dart';

import 'json_ast/json_ast.dart';
import 'models/validation_results.dart';
import 'systems/system_loader.dart'; // Ensure you have this package in your pubspec.yaml

class FhirValidator {
  var results = ValidationResults();

  ValidationResults _results() {
    final newResults = results.copyWith();
    results = ValidationResults();
    return newResults;
  }

  Future<ValidationResults> validateFhirResource({
    required Resource resource,
    StructureDefinition? structureDefinition,
  }) =>
      validateFhirMap(
          map: resource.toJson(), structureDefinition: structureDefinition);

  Future<ValidationResults> validateFhirJson({
    required String json,
    StructureDefinition? structureDefinition,
  }) =>
      validateFhirMap(
          map: jsonDecode(json), structureDefinition: structureDefinition);

  Future<ValidationResults> validateFhirMap({
    required Map<String, dynamic> map,
    StructureDefinition? structureDefinition,
  }) async {
    final String resourceString = json.encode(map);

    // Parse the JSON with position information
    final Node node = parse(resourceString, Settings());

    // Extract the resourceType from the resource
    final typeNode = node.getPropertyNode('resourceType');

    // This validator only works on full resources. So without a type, we can't
    // do anything
    if (typeNode == null ||
        typeNode is! LiteralNode ||
        typeNode.value == null) {
      results.addResult(
        '',
        '',
        'ResourceType is missing',
        Severity.error,
        line: typeNode?.loc?.start.line,
        column: typeNode?.loc?.start.column,
      );
      return _results();
    }

    // Extract resourceType from the map
    final type = typeNode.value;
    final util = FhirValidatorUtils();

    // If a structure definition is provided, we preferentially use it
    if (structureDefinition != null) {
      results.combineResults(await util.evaluateFromPaths(
        mapToValidate: map,
        structureDefinition: structureDefinition,
        type: type,
        startPath: type,
        node: node,
      ));
      return _results();
    } else {
      // Without a structureMap, we look and see if the resource has a profile
      final List<LiteralNode> profileNodes = node.extractProfileNodes();
      final profiles = await getProfiles(profileNodes);
      // as long as we have at least one profile, we use that
      if (profiles.isNotEmpty) {
        for (var profile in profiles) {
          results.combineResults(
            await util.evaluateFromPaths(
              mapToValidate: map,
              structureDefinition: StructureDefinition.fromJson(profile),
              type: type,
              startPath: type,
              node: node,
            ),
          );
        }
        return _results();
      } else {
        // So if we have no profiles, and no structure definition, we try to
        // get the structure definition
        // Retrieve the structure definition for the resource type
        final definitionMap = await getStructureDefinition(type);
        if (definitionMap == null) {
          // If no structure definition is found, return an error, and we're done
          results.addResult(
            '',
            '',
            'No StructureDefinition was found for this Resource, which is a resourceType of: $type',
            Severity.error,
          );
          return _results();
        } else {
          // Parse the structure definition from JSON
          structureDefinition = StructureDefinition.fromJson(definitionMap);
          // If structure definition is found, validate the resource against it
          results.combineResults(
            await util.evaluateFromPaths(
              mapToValidate: map,
              structureDefinition: structureDefinition,
              type: type,
              startPath: type,
              node: node,
            ),
          );
          return _results();
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> getProfiles(
      List<LiteralNode> nodes) async {
    // List to hold profile definitions retrieved
    List<Map<String, dynamic>> profileDefinitions = [];

    // Retrieve profile definitions for each profile URL
    for (var profileNode in nodes) {
      try {
        final profileDef = await getProfile(profileNode.value);
        if (profileDef != null) {
          profileDefinitions.add(profileDef);
        }
      } catch (e) {
        // If there is an error retrieving a profile, return an error message
        results.addResult(
          '',
          '',
          'Failed to retrieve profile definition: ${profileNode.value}',
          Severity.error,
          line: profileNode.loc?.start.line,
          column: profileNode.loc?.start.column,
        );
      }
    }
    return profileDefinitions;
  }
}
