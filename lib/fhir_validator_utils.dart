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

    return await validateStructure(node, type, elements, results);
  }

  List<ElementDefinition> extractElements(
      StructureDefinition structureDefinition) {
    return structureDefinition.snapshot?.element ?? [];
  }

  Future<ValidationResults> validateStructure(Node node, String type,
      List<ElementDefinition> elements, ValidationResults results) async {
    // Validate the structure
    if (node is! ObjectNode) {
      throw Exception('Root node must be an ObjectNode');
    }
    return await _objectNode(node, type, elements, results);
  }

  Future<ValidationResults> _objectNode(ObjectNode node, String path,
      List<ElementDefinition> elements, ValidationResults results) async {
    for (var property in node.children) {
      results = await _propertyNode(property, path, elements, results);
    }
    return results;
  }

  Future<ValidationResults> _propertyNode(PropertyNode node, String path,
      List<ElementDefinition> elements, ValidationResults results) async {
    final currentPath = node.path;
    final element = elements.firstWhereOrNull(
        (element) => element.path == _cleanLocalPath(path, node.path));
    if (element != null) {
      // We get the code from the StructureDefinition to determine if it's
      // a primitive type

      final code = element.type?.first.code?.toString().toLowerCase();
      if (code != null && _isPrimitive(element)) {
        results = _validatePrimitive(node, element, results);
      } else if (code != null) {
        // If not, then it's not a primitive structure, and we will need
        // to find a separate StructureDefinition or Profile to validate
        // the object.
        final structureDefinitionMap = await getStructureDefinition(code);
        final StructureDefinition? structureDefinition =
            structureDefinitionMap != null
                ? StructureDefinition.fromJson(structureDefinitionMap)
                : null;
        final newElements = extractElements(structureDefinition!);
        // If we find the StructureDefinition, we should traverse the AST
        if (newElements.isNotEmpty) {
          if (node.value != null) {
            _traverseAst(node.value!, path, newElements, results);
          } else {
            throw Exception('node is ${node.runtimeType} with null node.value');
          }
        } else {
          results.addResult(
            path,
            node.key!.value,
            'No StructureDefinition or Profile found for Element type $code',
            Severity.error,
            line: node.key?.loc?.start.line,
            column: node.key?.loc?.start.column,
          );
        }
      }
      // return results;
      // if (node is ObjectNode) {
      //   for (var property in node.children) {
      //     print(property.path);
      //     // results = await _perPropertyNode(property, element, path, results);
      //     _traverseAst(property, path, elements, results);
      //   }
      // } else if (node is ArrayNode) {
      //   for (var i = 0; i < node.children.length; i++) {
      //     await _traverseAst(node.children[i], '$path[$i]', elements, results);
      //   }
      // } else if (node.value != null) {
      //   _traverseAst(node.value!, path, elements, results);
      // } else {
      //   throw Exception('node is ${node.runtimeType} with null node.value');
      // }
      // for (final child in node.children) {
      //   throw Exception('child node ${child.runtimeType}');
      // }
    }
    // if we aren't able to find it in the elements, we should add it to the
    // ValidationResults as an error, and won't go looking for anything else
    else {
      return results
        ..addResult(
          '',
          currentPath,
          'Element not found in StructureDefinition',
          Severity.error,
          line: node.loc?.start.line,
          column: node.loc?.start.column,
        );
    }
    return results;
  }

  // Future<ValidationResults> _perPropertyNode(PropertyNode node,
  //     ElementDefinition element, String path, ValidationResults results) async {
  //   // If it's a primitive type, we should validate the value
  //   if (code != null && _isPrimitive(element)) {
  //     results = _validatePrimitive(node, element, results);
  //   } else if (code != null) {
  //     // If not, then it's not a primitive structure, and we will need
  //     // to find a separate StructureDefinition or Profile to validate
  //     // the object.
  //     final structureDefinitionMap = await getStructureDefinition(code);
  //     final StructureDefinition? structureDefinition =
  //         structureDefinitionMap != null
  //             ? StructureDefinition.fromJson(structureDefinitionMap)
  //             : null;
  //     final newElements = extractElements(structureDefinition!);
  //     // If we find the StructureDefinition, we should traverse the AST
  //     if (newElements.isNotEmpty) {
  //       if (node.value != null) {
  //         _traverseAst(node.value!, path, newElements, results);
  //       } else {
  //         throw Exception('node is ${node.runtimeType} with null node.value');
  //       }
  //     } else {
  //       results.addResult(
  //         path,
  //         node.key!.value,
  //         'No StructureDefinition or Profile found for Element type $code',
  //         Severity.error,
  //         line: node.key?.loc?.start.line,
  //         column: node.key?.loc?.start.column,
  //       );
  //     }
  //   }
  //   return results;
  // }

  String _cleanLocalPath(String parentPath, String childPath) {
    childPath = childPath.replaceAll('$parentPath.', '');
    return _stripIndexes(childPath);
  }

  String _stripIndexes(String path) {
    // Regular expression to match [index] patterns
    RegExp regex = RegExp(r'\[\d+\]');
    // Replace all matches with an empty string
    return path.replaceAll(regex, '');
  }

  bool _isPrimitive(ElementDefinition element) {
    if (element.type == null || element.type!.isEmpty) return false;
    final primitiveType = element.type!.first.code?.toString().toLowerCase();
    return primitiveType != null && isPrimitiveType(primitiveType);
  }

  ValidationResults _validatePrimitive(PropertyNode property,
      ElementDefinition element, ValidationResults results) {
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
    return results;
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
