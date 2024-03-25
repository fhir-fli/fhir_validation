import 'dart:async';

import 'package:fhir/r5.dart';

import '../../validation.dart';

class CodeSystemValidator extends BaseValidator {
  CodeSystemValidator(BaseValidator parent) : super.fromParent(parent);

  Future<bool> validateCodeSystem(List<ValidationMessage> errors, Element cs,
      NodeStack stack, ValidationOptions options) async {
    bool ok = true;
    String url = cs.getNamedChildValue("url");
    String content = cs.getNamedChildValue("content");
    String caseSensitive = cs.getNamedChildValue("caseSensitive");
    String hierarchyMeaning = cs.getNamedChildValue("hierarchyMeaning");
    String supp = cs.getNamedChildValue("supplements");
    int count = await countConcepts(cs);

    await metaChecks(errors, cs, stack, url, content, caseSensitive,
        hierarchyMeaning, supp.isNotEmpty, count, supp);

    String vsu = cs.getNamedChildValue("valueSet");
    if (vsu.isNotEmpty) {
      // Hint, rule, and further validation logic goes here...
      // This section requires access to FHIR resources and might involve complex logic
    }

    // Assuming context.supportsSystem is a method you have available to check system support
    if (await context.supportsSystem(supp, options.fhirVersion)) {
      // Validation logic specific to supplements goes here...
      // This might involve validating concepts against a supplementary code system
    }

    if (!stack.isContained) {
      ok = await checkShareableCodeSystem(errors, cs, stack) && ok;
    }
    return ok;
  }

  // Implementation for other methods like metaChecks, checkShareableCodeSystem, validateSupplementConcept, countConcepts
  // You would need to adapt these methods based on your actual FHIR library usage in Dart
}
