import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import 'fhir_validation.dart';

class FhirValidatorUtils {
  Future<ValidationResults> evaluateFromPaths({
    required Map<String, dynamic> mapToValidate,
    required StructureDefinition structureDefinition,
    required String type,
    required String startPath,
    required Node node,
    Client? client,
  }) async {
    var results = ValidationResults();

    // Extract elements from the main structure definition
    final elements = extractElements(structureDefinition);

    results = await validateStructure(
        node: node, elements: elements, type: type, client: client);

    // Check for missing required fields and extra fields
    results = await validateCardinality(structureDefinition.getUrl(),
        node as ObjectNode, type, type, elements, results, client);

    // Validate Coding/CodeableConcept bindings
    results = await validateBindings(
      node: node,
      elements: elements,
      results: results,
      client: client,
    );

    return results;
  }
}
