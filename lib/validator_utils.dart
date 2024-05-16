import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';

import 'json_ast/json_ast.dart';
import 'models/validation_results.dart';

class FhirValidatorUtils {
  Future<ValidationResults> evaluateFromPaths({
    required Map<String, dynamic> mapToValidate,
    required StructureDefinition structureDefinition,
    required String type,
    required String startPath,
    required Node node,
  }) async {
    var results = ValidationResults();

    // Extract elements from the structure definition
    final elements = extractElements(structureDefinition);

    // Validate the structure
    validateStructure(node, type, elements, results);

    return results;
  }

  List<ElementDefinition> extractElements(
      StructureDefinition structureDefinition) {
    return structureDefinition.snapshot?.element ?? [];
  }

  void validateStructure(Node node, String type,
      List<ElementDefinition> elements, ValidationResults results) {
    _traverseAst(node, type, elements, results);
  }

  void _traverseAst(Node node, String path, List<ElementDefinition> elements,
      ValidationResults results) {
    if (node is ObjectNode) {
      for (var property in node.children) {
        final newPath =
            path.isEmpty ? property.key?.value : '$path.${property.key?.value}';
        if (newPath != null) {
          final matchingElement =
              elements.firstWhereOrNull((element) => element.path == newPath);
          if (matchingElement?.path == null) {
            results.addResult(
              '',
              newPath,
              'Unexpected element found: $newPath',
              Severity.error,
              line: property.key?.loc?.start.line,
              column: property.key?.loc?.start.column,
            );
          } else {
            _traverseAst(property.value!, newPath, elements, results);
          }
        }
      }
    } else if (node is ArrayNode) {
      for (var i = 0; i < node.children.length; i++) {
        final newPath = '$path[$i]';
        _traverseAst(node.children[i], newPath, elements, results);
      }
    }
  }
}
