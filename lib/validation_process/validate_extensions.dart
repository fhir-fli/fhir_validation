import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:http/http.dart';

/// Validates the extensions of a [Node] against the corresponding
/// [ElementDefinition].
Future<ValidationResults> validateExtensions(
  Node node,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  var newResults = results.copyWith();
  for (final element in elements) {
    if (element.type != null &&
        element.type!.any(
          (ElementDefinitionType t) => t.code.toString() == 'Extension',
        )) {
      final extensionUrl = element.type
          ?.firstWhere(
            (ElementDefinitionType t) => t.code.toString() == 'Extension',
          )
          .profile
          ?.first;
      final extensionDefinition =
          await getResource(extensionUrl.toString(), client);
      final structureDefinition = extensionDefinition != null &&
              extensionDefinition['resourceType'] == 'StructureDefinition'
          ? StructureDefinition.fromJson(extensionDefinition)
          : null;
      if (structureDefinition != null) {
        final extensionElements = extractElements(structureDefinition);
        final extensionNode = node.getPropertyNode('_${element.path.value!}');
        if (extensionNode != null) {
          newResults = await validateStructure(
            node: extensionNode,
            elements: extensionElements,
            type: 'Extension',
            client: client,
          );
        }
      }
    }
  }
  return newResults;
}
