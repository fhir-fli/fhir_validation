# fhir_validation

[![pub package](https://img.shields.io/pub/v/fhir_validation.svg)](https://pub.dev/packages/fhir_validation)

Validation of FHIR resources against their StructureDefinitions, for every
FHIR version: structure, cardinality, bindings, extensions and invariants
(FHIRPath constraints), plus a QuestionnaireResponse against its
Questionnaire.

FHIR® is the registered trademark of HL7 and is used with the permission of
HL7. Use of the FHIR trademark does not constitute endorsement of this product
by HL7.

## How it is version-free

The resource under validation is JSON. Definitions (StructureDefinition,
ValueSet, CodeSystem, Questionnaire) come from a `fhir_path` `ResourceCache`
and are read by element name through the
[`fhir_node`](https://pub.dev/packages/fhir_node) contract. A version's
binding (`fhir_r4_validation`, `fhir_r5_validation`, `fhir_r6_validation`)
supplies a `ValidationModel`: its primitive-value rules, how a JSON value
becomes a typed FHIRPath context, and its fhir_path binding.

## Usage with a binding

```dart
import 'package:fhir_r4_validation/fhir_r4_validation.dart';

final cache = CanonicalResourceCache()..see(patientStructureDefinition);
final results = await const FhirValidationEngine().validateFhirMap(
  structureToValidate: {'resourceType': 'Patient', 'id': 'p1'},
  resourceCache: cache,
);
if (results.hasErrors) print(results.toOperationOutcome().toJson());
```

Supply a cache. The default `CanonicalResourceCache` is empty, so without
one the engine answers "No StructureDefinition found for resourceType".

## Usage without a binding

Implement `ValidationModel` for whatever implements `FhirNode` and pass it:

```dart
final engine = FhirValidationEngine(myModel);
```
