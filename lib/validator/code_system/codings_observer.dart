import 'package:fhir/r5.dart';

import '../validation.dart';

class CodingsObserver extends BaseValidator {
  late IWorkerContext context;
  List<CodingUsage> list = [];
  bool checkIPSCodes = false;

  CodingsObserver(this.context, XVerExtensionManager xverManager, bool debug)
      : super(context, xverManager, debug);

  void seeCode(NodeStack stack,
      {required String system,
      required String version,
      required String code,
      required String display}) {
    seeCodeCoding(
        stack,
        Coding(
            system: FhirUri(system),
            code: FhirCode(code),
            version: version,
            display: display));
  }

  void seeCodeCodeableConcept(NodeStack stack, {required CodeableConcept cc}) {
    for (var c in cc.coding!) {
      seeCodeCoding(stack, c);
    }
  }

  void seeCodeCoding(NodeStack stack, Coding c) {
    list.add(CodingUsage(stack, c));
  }

  void finish(List<ValidationMessage> errors, NodeStack rootStack) {
    if (checkIPSCodes) {
      print("Checking SCT codes for IPS");

      var snomedCTCodes = <String>{};
      for (var c in list) {
        if (c.c.system!.toString() == "http://snomed.info/sct" &&
            c.c.code != null) {
          snomedCTCodes.add(c.c.code!.toString());
        }
      }
      if (snomedCTCodes.isNotEmpty) {
        var nonIPSCodes = checkSCTCodes(snomedCTCodes);
        if (nonIPSCodes.isNotEmpty) {
          for (var s in nonIPSCodes.keys) {
            if (nonIPSCodes[s] != null) {
              hintNodeStack(
                  errors,
                  "2023-07-25",
                  IssueType.businessRule,
                  rootStack,
                  false,
                  "SCT code $s not compliant with IPS",
                  [s, nonIPSCodes[s]!]);
            } else {
              hintNodeStack(errors, "2023-07-25", IssueType.businessRule,
                  rootStack, false, "SCT code $s not compliant with IPS", []);
            }
          }
        }
      }
      print("Done Checking SCT codes for IPS");
    }
  }

  Map<String, String> checkSCTCodes(Set<String> codes) {
    // Implement code validation against IPS value set here. This will likely involve calling an external service or using local validation logic.
    // Return a map of codes to error messages for codes that do not comply with IPS.
    var results = <String, String>{};
    // Example: results['12345'] = 'Not a valid IPS code';
    return results;
  }
}

class CodingUsage {
  NodeStack stack;
  Coding c;

  CodingUsage(this.stack, this.c);
}
