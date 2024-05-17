import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

class FhirValidatorUtils {
  Future<ValidationResults> evaluateFromPaths({
    required Map<String, dynamic> mapToValidate,
    required StructureDefinition structureDefinition,
    required String type,
    required String startPath,
    required Node node,
  }) async {
    var results = ValidationResults();

    // Extract elements from the main structure definition
    final elements = extractElements(structureDefinition);

    // Validate the structure
    await validateStructure(node, type, elements, results);

    return results;
  }

  List<ElementDefinition> extractElements(
      StructureDefinition structureDefinition) {
    return structureDefinition.snapshot?.element ?? [];
  }

  Future<void> validateStructure(Node node, String type,
      List<ElementDefinition> elements, ValidationResults results) async {
    await _traverseAst(node, type, elements, results);
  }

  Future<void> _traverseAst(Node node, String path,
      List<ElementDefinition> elements, ValidationResults results) async {
    print('node path : ${node.path}');
    if (node is ObjectNode) {
      for (var property in node.children) {
        _traverseAst(property, path, elements, results);
      }
    } else if (node is ArrayNode) {
      for (var i = 0; i < node.children.length; i++) {
        await _traverseAst(node.children[i], '$path[$i]', elements, results);
      }
    } else if (node is LiteralNode) {
      // print('literalValue ${node.value} ${node.path}');
    } else if (node is PropertyNode) {
      if (node.value != null) {
        _traverseAst(node.value!, path, elements, results);
      }
      for (final child in node.children) {
        throw Exception('child node ${child.runtimeType}');
      }
    } else {
      throw Exception('runtimeType: ${node.runtimeType}');
    }
    // for (final element in elements) {}

    // if (node is ObjectNode) {
    //   String base = path;
    //   for (var property in node.children) {
    //     final propertyKey = property.key?.value;
    //     if (propertyKey != null) {
    //       final newPath = path.isEmpty ? propertyKey : '$path.$propertyKey';
    //       var matchingElement =
    //           elements.firstWhereOrNull((element) => element.path == newPath);

    //       if (matchingElement == null) {
    //         // Try resolving profiles if element is not directly matched
    //         matchingElement =
    //             await _resolveSubObject(property, newPath, elements, results);
    //       }
    //     }
    //   }
    // } else if (node is ArrayNode) {
    //   for (var i = 0; i < node.children.length; i++) {
    //     final newPath = '$path[$i]';
    //     await _traverseAst(node.children[i], newPath, elements, results);
    //   }
    // }
  }

  bool _isPrimitive(ElementDefinition element) {
    if (element.type == null || element.type!.isEmpty) return false;
    final primitiveType = element.type!.first.code?.toString().toLowerCase();
    return primitiveType != null &&
        fhirPrimitiveToDartPrimitive(primitiveType) != 'not defined';
  }

  void _validatePrimitive(PropertyNode property, ElementDefinition element,
      ValidationResults results) {
    final primitiveClass = element.type!.first.code!;
    final value = (property.value as LiteralNode?)?.value;

    if (value != null &&
        !isValueAValidPrimitive(primitiveClass.toString(), value)) {
      results.addResult(
        '',
        property.key!.value,
        'Invalid value for primitive type: $primitiveClass',
        Severity.error,
        line: property.key?.loc?.start.line,
        column: property.key?.loc?.start.column,
      );
    }
  }

  Future<ElementDefinition?> _resolveSubObject(
      PropertyNode property,
      String path,
      List<ElementDefinition> elements,
      ValidationResults results) async {
    for (var element in elements) {
      if (element.path == path) continue;
      if (element.type != null) {
        for (var typeRef in element.type!) {
          if (typeRef.profile != null) {
            for (var profileUrl in typeRef.profile!) {
              final profileElements =
                  await _fetchProfileElements(profileUrl.toString());
              if (profileElements != null) {
                final matchingElement = profileElements.firstWhereOrNull(
                    (profileElement) => profileElement.path == path);
                if (matchingElement != null) return matchingElement;
              }
            }
          }
        }
      }
    }
    return null;
  }

  Future<List<ElementDefinition>?> _fetchProfileElements(
      String profileUrl) async {
    // Implement logic to fetch and resolve the profile's StructureDefinition
    // For example, you might fetch the profile from a server or cache
    final structureDefinition = await _fetchStructureDefinition(profileUrl);
    return structureDefinition?.snapshot?.element;
  }

  Future<StructureDefinition?> _fetchStructureDefinition(
      String profileUrl) async {
    // Implement the actual fetching logic here
    // This is a placeholder for your implementation
    // Example: return await myStructureDefinitionService.fetch(profileUrl);
    return null;
  }
}
