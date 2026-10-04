import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_validation/fhir_validation.dart';

/// Validates the extensions of a [Node] against the corresponding
/// [ElementNode].
///
/// This function ensures that extensions within the FHIR resource comply with
/// the rules defined in the StructureDefinition for the extension type.
///
/// - Fetches the StructureDefinition for the extension.
/// - Validates the structure of the extension node against the fetched
/// elements.
///
/// [node] - The node being validated.
/// [elements] - Map of element definitions that describe the resource.
/// [results] - Existing validation results to which new results will be added.
/// [client] - HTTP client used to fetch external resources.
Future<ValidationResults> validateExtensions({
  required ValidationModel<FhirNode> model,
  required Node node,
  required Map<String, ElementNode> elements,
  required ValidationResults results,
  required ResourceCache resourceCache,
}) async {
  var newResults = results.copyWith();

  // Iterate over each element to find and validate extensions.
  for (final element in elements.values) {
    // Check if the element's type includes "Extension".
    final extensionType =
        element.types.where((t) => t.code == 'Extension').firstOrNull;
    if (extensionType != null) {
      // Retrieve the profile URL for the extension.
      final extensionUrl = extensionType.profiles.firstOrNull;

      // Locate the extension node within the parent node.
      // Extract just the property name from the path
      // (e.g., 'extension' from 'Patient.extension').
      final pathParts = element.path.split('.');
      final propertyName = pathParts.last;
      // Check both with underscore prefix (for primitive extensions)
      // and without.
      final extensionNodeWithUnderscore = node.getPropertyNode(
        '_$propertyName',
      );
      final extensionNodeWithoutUnderscore = node.getPropertyNode(propertyName);
      final extensionNode =
          extensionNodeWithUnderscore ?? extensionNodeWithoutUnderscore;

      // Validate the structure of the extension node.
      if (extensionNode != null) {
        if (extensionNode is! ObjectNode) {
          // Add an error if the extension node is not an ObjectNode.
          newResults.addResult(
            node,
            'Extension must be an ObjectNode: $extensionNode',
            Severity.error,
          );
        } else {
          // Fetch the StructureDefinition for the extension if the
          // profile URL exists.
          final structureDefinition =
              extensionUrl != null
                  ? await resourceCache.getStructureDefinition(extensionUrl)
                  : null;

          if (structureDefinition != null) {
            // Extract elements from the fetched StructureDefinition.
            final extensionElements = extractElements(structureDefinition);

            // Recursively validate the structure of the extension node.
            newResults = await validateStructure(
              model: model,
              node: extensionNode,
              elements: extensionElements,
              type: 'Extension',
              resourceCache: resourceCache,
            );
          }
        }
      }
    }
  }

  return newResults;
}
