import 'package:fhir/r5.dart';

import '../validation.dart';

class SnomedCTChecker extends CodeSystemChecker {
  bool noTag = false;
  List<String> noTags = [];
  bool hasTag = false;
  List<String> tags = [];

  SnomedCTChecker(IWorkerContext context, XVerExtensionManager xverManager,
      bool debug, List<ValidationMessage> errors)
      : super(context, xverManager, debug, errors);

  @override
  void checkConcept(String code, String display) {
    super.checkConcept(code, display);
    if (display.isNotEmpty) {
      int s = display.lastIndexOf("(");
      int e = display.lastIndexOf(")");
      bool tagged =
          e == display.length - 1 && s > -1 && s > display.length - 20;
      if (tagged) {
        hasTag = true;
        if (tags.length < 5) {
          tags.add(display);
        }
      } else {
        noTag = true;
        if (noTags.length < 5) {
          noTags.add(display);
        }
      }
    }
  }

  @override
  void finish(Element inc, NodeStack stack) {
    super.finish(inc, stack);
    hint(
      errors,
      "2023-07-21",
      IssueType.businessRule,
      inc.line ?? 0,
      inc.col ?? 0,
      stack.literalPath,
      !(noTag && hasTag),
      "Mixed use of SNOMED CT concept displays with and without tags is not recommended.", // Example message, replace with appropriate i18n message.
      [tags.toString(), noTags.toString()],
    );
  }
}
