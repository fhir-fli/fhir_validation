import 'dart:convert';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:http/http.dart';

/// [FhirValidator]
class FhirValidator {
  /// validate a FHIR resource from a Dart FHIR class
  Future<ValidationResults> validateFhirResource({
    required Resource resourceToValidate,
    StructureDefinition? structureDefinition,
    Client? client,
  }) {
    return validateFhirMap(
      resourceToValidate: resourceToValidate.toJson(),
      structureDefinition: structureDefinition,
      client: client,
    );
  }

  /// validate a FHIR resource from a JSON string
  Future<ValidationResults> validateFhirString({
    required String resourceToValidate,
    required Client? client,
    StructureDefinition? structureDefinition,
  }) async {
    final resourceMap = json.decode(resourceToValidate) as Map<String, dynamic>;
    return validateFhirMap(
      resourceToValidate: resourceMap,
      structureDefinition: structureDefinition,
      client: client,
    );
  }

  /// validate a FHIR resource from a JSON map
  Future<ValidationResults> validateFhirMap({
    required Map<String, dynamic> resourceToValidate,
    required Client? client,
    StructureDefinition? structureDefinition,
  }) async {
    final type = resourceToValidate['resourceType'] as String?;
    if (type == null) {
      return ValidationResults()
        ..addResult(
          null,
          'ResourceType is missing',
          Severity.error,
        );
    }
    // PrettyPrinting makes lines and columns correct
    final resourceString = prettyPrintJson(resourceToValidate);

    // Parse the JSON with position information
    final node = parse(resourceString, Settings(), type);

    if (structureDefinition != null) {
      // If structure definition is found, validate the resource against it
      return evaluate(
        resourceToValidate,
        structureDefinition,
        type,
        type,
        node,
        client,
      );
    }

    // Retrieve profiles for the resource
    final profiles = <Map<String, dynamic>>[];
    final results = await _getProfiles(node, client, profiles);

    if (profiles.isNotEmpty) {
      // If profiles are found, validate the resource against each profile
      for (final profile in profiles) {
        results.combineResults(
          await evaluate(
            resourceToValidate,
            StructureDefinition.fromJson(profile),
            type,
            type,
            node,
            client,
          ),
        );
      }
      print(results.toJson());
      return results;
    }

    // So we don't have profiles or a StructureDefinition, so we just go with
    // a generic StructureDefinition
    final definitionMap = await getResource(type, client);
    if (definitionMap == null) {
      // If no structure definition is found, return an error
      return results
        ..addResult(
          null,
          'No StructureDefinition was found for this Resource, '
          'which is a resourceType of: $type',
          Severity.error,
        );
    } else if (definitionMap['resourceType'] == 'StructureDefinition') {
      // Parse the structure definition from JSON
      structureDefinition = StructureDefinition.fromJson(definitionMap);
      return results
        ..combineResults(
          await evaluate(
            resourceToValidate,
            structureDefinition,
            type,
            type,
            node,
            client,
          ),
        );
    } else {
      return results
        ..addResult(
          null,
          'The StructureDefinition for this Resource is not a '
          'StructureDefinition, which is a resourceType of: $type',
          Severity.error,
        );
    }
  }

  /// the function to actually evaluate the resource
  Future<ValidationResults> evaluate(
    Map<String, dynamic> mapToValidate,
    StructureDefinition structureDefinition,
    String type,
    String startPath,
    Node node,
    Client? client,
  ) async {
    final url = structureDefinition.getUrl();
    var results = ValidationResults();
    final elements = extractElements(structureDefinition);

    results = await validateStructure(
      url: url,
      node: node,
      elements: elements,
      type: type,
      client: client,
    );

    print('After validate structure');
    print(results.toJson());

    results = await validateCardinality(
      structureDefinition.getUrl(),
      node as ObjectNode,
      type,
      type,
      elements,
      results,
      client,
    );

    print('After validate cardinality');
    print(results.toJson());

    results = await validateBindings(
      node: node,
      elements: elements,
      results: results,
      client: client,
    );

    print('After validate bindings');
    print(results.toJson());

    // Validate Extensions
    results = await validateExtensions(node, elements, results, client);


    print('After validate extensions');
    print(results.toJson());

    if (type == 'QuestionnaireResponse' &&
        mapToValidate['resourceType'] == 'QuestionnaireResponse') {
      final questionnaireResponse =
          QuestionnaireResponse.fromJson(mapToValidate);
      results = await validateQuestionnaireResponse(
        questionnaireResponse: questionnaireResponse,
        client: client,
      );
    }

    print('After validate questionnaire response');
    print(results.toJson());
    return results;
  }

  Future<ValidationResults> _getProfiles(
    Node node,
    Client? client,
    List<Map<String, dynamic>> profiles,
  ) async {
    final results = ValidationResults();
    if (node is ObjectNode) {
      // Extract profiles from the resource if any are specified in the 
      // meta section
      final profileNodes = node.extractProfileNodes();

      // Retrieve profile definitions for each profile URL
      for (final profile in profileNodes) {
        try {
          final profileDef = await getResource(profile.value as String, client);
          if (profileDef != null) {
            profiles.add(profileDef);
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
    return results;
  }
}
