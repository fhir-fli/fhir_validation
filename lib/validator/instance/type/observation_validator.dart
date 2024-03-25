import 'package:fhir/r5.dart';

import '../../validation.dart';

class ObservationValidator extends BaseValidator {
  ObservationValidator(BaseValidator parent) : super.fromParent(parent);

  bool validateObservation({
    required ValidationContext valContext,
    required List<ValidationMessage> errors,
    required Element element,
    required NodeStack stack,
    required double pct,
    required ValidationMode mode,
  }) {
    bool ok = true;

    // Assuming similar logic for best practice check (bpCheck) exists in Dart.
    ok &= bpCheck(
      errors: errors,
      issueType: IssueType.invalid,
      line: element.line,
      col: element.col,
      path: stack.literalPath,
      condition: element.getNamedChild('subject') != null,
      message: I18nConstants.allObservationsShouldHaveASubject,
    );

    final performers = element.getNamedChildren('performer');
    ok &= bpCheck(
      errors: errors,
      issueType: IssueType.invalid,
      line: element.line,
      col: element.col,
      path: stack.literalPath,
      condition: performers.isNotEmpty,
      message: I18nConstants.allObservationsShouldHaveAPerformer,
    );

    final hasEffectiveDateTime =
        element.getNamedChild('effectiveDateTime') != null;
    final hasEffectivePeriod = element.getNamedChild('effectivePeriod') != null;
    final hasEffectiveTiming = element.getNamedChild('effectiveTiming') != null;
    final hasEffectiveInstant =
        element.getNamedChild('effectiveInstant') != null;
    ok &= bpCheck(
      errors: errors,
      issueType: IssueType.invalid,
      line: element.line,
      col: element.col,
      path: stack.literalPath,
      condition: hasEffectiveDateTime ||
          hasEffectivePeriod ||
          hasEffectiveTiming ||
          hasEffectiveInstant,
      message: I18nConstants
          .allObservationsShouldHaveAnEffectiveDateTimeOrAnEffectivePeriod,
    );

    // Example for handling codes against profiles
    final code = element.getNamedChild('code');
    final codes = <String>[];
    if (hasLoincCode(code: code, codes: codes, values: ['85353-1'])) {
      ok &= checkObservationAgainstProfile(
        valContext: valContext,
        errors: errors,
        element: element,
        stack: stack,
        url: 'http://hl7.org/fhir/StructureDefinition/vitalspanel',
        name: 'Vital Signs Panel',
        sys: 'LOINC',
        loinc: codes,
        pct: pct,
        mode: mode,
      );
    }

    return ok;
  }

  bool hasLoincCode(
      {Element? code,
      required List<String> codes,
      required List<String> values}) {
    // This is a simplified assumption of how you would implement this check.
    // You need to adapt it based on how your FHIR library in Dart represents resources and elements.
    if (code != null) {
      final codings = code.getChildrenByName('coding');
      for (final coding in codings) {
        if (coding.getField('system').valueString == 'http://loinc.org' &&
            values.contains(coding.getField('code').valueString)) {
          codes.add(coding.getField('code').valueString);
          return true;
        }
      }
    }
    return false;
  }

  bool checkObservationAgainstProfile({
    required ValidationContext valContext,
    required List<ValidationMessage> errors,
    required Element element,
    required NodeStack stack,
    required String url,
    required String name,
    required String sys,
    required List<String> codes,
    required double pct,
    required ValidationMode mode,
  }) {
    // Signpost for information
    errors.add(ValidationMessage(
      type: IssueType.informational,
      path: stack.literalPath,
      message:
          "Checking observation against the profile: $name with code from $sys: ${codes.first}",
    ));

    // Fetch the StructureDefinition for the specified profile URL
    final StructureDefinition? sd = fetchStructureDefinition(url);

    if (sd == null) {
      errors.add(ValidationMessage(
        type: IssueType.error,
        path: stack.literalPath,
        message: "Failed to fetch StructureDefinition for profile $url",
      ));
      return false;
    } else {
      // Assuming a method that starts validation against a profile
      return startValidationWithProfile(
        valContext: valContext,
        errors: errors,
        element: element,
        structureDefinition: sd,
        stack: stack,
        pct: pct,
        mode: mode,
      );
    }
  }

  bool hasSctCode({
    required Element? code,
    required List<String> codes,
    required List<String> values,
  }) {
    if (code != null) {
      final List<Element> codings = code.getChildrenByName('coding');
      for (final coding in codings) {
        if (coding.getField('system').valueString == 'http://snomed.info/sct' &&
            values.contains(coding.getField('code').valueString)) {
          codes.add(coding.getField('code').valueString);
          return true;
        }
      }
    }
    return false;
  }

  StructureDefinition? fetchStructureDefinition(String url) {
    // Implement fetching of StructureDefinition from the FHIR server or local cache
    return null;
  }

  bool startValidationWithProfile({
    required ValidationContext valContext,
    required List<ValidationMessage> errors,
    required Element element,
    required StructureDefinition structureDefinition,
    required NodeStack stack,
    required double pct,
    required ValidationMode mode,
  }) {
    // Implement validation logic here, possibly leveraging InstanceValidator or similar
    return true;
  }
}
