import 'package:fhir/r5.dart';

import '../validation.dart';

class CodeSystemChecker extends BaseValidator {
  bool noDisplay = false;
  bool hasDisplay = false;
  List<ValidationMessage> errors;

  CodeSystemChecker(super.context, super.xverManager, super.debug, this.errors);

  void checkConcept(String code, String display) {
    if (display == '') {
      noDisplay = true;
    } else {
      hasDisplay = true;
    }
  }

  void finish(Element inc, NodeStack stack) {
    hint(
        errors,
        "2023-07-21",
        IssueType.businessRule,
        inc.line ?? 0,
        inc.col ?? 0,
        stack.getLiteralPath(),
        !(noDisplay && hasDisplay),
        I18nConstants.VALUESET_CONCEPT_DISPLAY_PRESENCE_MIXED);
  }
}
