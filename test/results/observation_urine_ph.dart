import 'package:fhir_validation/validation_result.dart';

final observationUrinePh = ValidationResult(warnings: [
  'Observation: Best Practice Recommendation: In general, all observations should have a performer on line 1. Jump to error.',
  "Observation.code: None of the codings provided are in the value set 'US Core Laboratory Test Codes' (http://hl7.org/fhir/us/core/ValueSet/us-core-laboratory-test-codes|6.1.0), and a coding should come from this value set unless it has no suitable code (note that the validator cannot judge what is suitable) (codes = http://loinc.org#5803-2) on line 28. Jump to error."
], information: [
  'Observation.category[0]: Reference to draft CodeSystem http://terminology.hl7.org/CodeSystem/observation-category|1.0.0 on line 17. Jump to error.'
]);
