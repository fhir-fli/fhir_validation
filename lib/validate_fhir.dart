import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';

Future<Map<String, List<String>?>> validateFhir({
  required Map<String, dynamic> resourceToValidate,
  StructureDefinition? structureDefinition,
}) async {
  var returnMap = <String, List<String>?>{};
  if (structureDefinition == null) {
    final definitionMap =
        await getStructureDefinition(resourceToValidate['resourceType']);
    if (definitionMap == null) {
      returnMap[resourceToValidate['resourceType']] = [
        'No StructureDefinition was found for this Resource, which is '
            'as a resourceType of: ${resourceToValidate['resourceType']}'
      ];
    } else {
      structureDefinition = StructureDefinition.fromJson(definitionMap);
    }
  }
  if (structureDefinition == null) {
    if (returnMap[resourceToValidate['resourceType']] == null ||
        returnMap[resourceToValidate['resourceType']]!.isEmpty) {
      returnMap[resourceToValidate['resourceType']] = [
        'No StructureDefinition was found for this Resource, which is '
            'a resourceType of: ${resourceToValidate['resourceType']}'
      ];
    } else {
      returnMap[resourceToValidate['resourceType']]!
          .add('No StructureDefinition was found for this Resource, which is '
              'a resourceType of: ${resourceToValidate['resourceType']}');
    }
  } else {
    returnMap = combineMaps(
      returnMap,
      await validateFhirMaps(
        mapToValidate: resourceToValidate,
        structureDefinition: structureDefinition,
        type: resourceToValidate['resourceType'],
        startPath: resourceToValidate['resourceType'],
      ),
    );
  }
  return returnMap;
}
