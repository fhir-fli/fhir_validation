import 'package:fhir_r4/fhir_r4.dart';

import 'fhir_validation.dart';

String notArrayMessage(FhirValidationObject? fhirValidationObject,
        ElementDefinition elementDefinition) =>
    'This property must be a ${fhirValidationObject?.type}, not an Array. '
    'Cardinality: ${elementDefinition.min ?? "none defined"}..${elementDefinition.max ?? "none defined"}';
