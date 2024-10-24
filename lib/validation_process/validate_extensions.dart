import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';

import '../fhir_validation.dart';

Future<ValidationResults> validateExtensions(
  Node node,
  List<ElementDefinition> elements,
  ValidationResults results,
  Client? client,
) async {
  for (ElementDefinition element in elements) {
    if (element.type != null &&
        element.type!.any((ElementDefinitionType t) => t.code == 'Extension')) {
      final FhirCanonical? extensionUrl = element.type
          ?.firstWhere((ElementDefinitionType t) => t.code == 'Extension')
          .profile
          ?.first;
      final Map<String, dynamic>? extensionDefinition =
          await getResource(extensionUrl.toString(), client);
      final StructureDefinition? structureDefinition =
          extensionDefinition != null &&
                  extensionDefinition['resourceType'] == 'StructureDefinition'
              ? StructureDefinition.fromJson(extensionDefinition)
              : null;
      if (structureDefinition != null) {
        final List<ElementDefinition> extensionElements =
            extractElements(structureDefinition);
        final Node? extensionNode =
            node.getPropertyNode('_' + element.path.value!);
        if (extensionNode != null) {
          results = await validateStructure(
            node: extensionNode,
            elements: extensionElements,
            type: 'Extension',
            client: client,
          );
        }
      }
    }
  }
  return results;
}
