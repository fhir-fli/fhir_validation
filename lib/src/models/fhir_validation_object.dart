import 'package:fhir_r4/fhir_r4.dart';

class FhirValidationObject {
  FhirValidationObject({
    required this.noIndex,
    this.fullMatch = '',
    this.partialMatch = '',
    this.type = '',
    this.binding,
    this.constraint,
  });

  String noIndex;
  String? fullMatch;
  String? partialMatch;
  String? type;
  ElementDefinitionBinding? binding;
  List<ElementDefinitionConstraint>? constraint;

  Map<String, dynamic> toJson() => {
        'noIndex': noIndex,
        'fullMatch': fullMatch,
        'partialMatch': partialMatch,
        'type': type,
        'binding': binding?.toJson(),
        'constraint': constraint?.map((e) => e.toJson()).toList(),
      };
}

Map<String, FhirValidationObject> addToFhirPathMatches({
  required Map<String, FhirValidationObject> fhirPathMatches,
  required String key,
  required String noIndex,
  String? fullMatch,
  String? partialMatch,
  required List<ElementDefinitionType>? type,
  required ElementDefinitionBinding? binding,
  required List<ElementDefinitionConstraint>? constraint,
}) {
  if (fhirPathMatches.containsKey(key)) {
    fhirPathMatches[key]!.noIndex = noIndex;
    fhirPathMatches[key]!.fullMatch =
        fullMatch ?? fhirPathMatches[key]!.fullMatch;
    fhirPathMatches[key]!.partialMatch =
        partialMatch ?? fhirPathMatches[key]!.partialMatch;
    if (fhirPathMatches[key]!.constraint == null) {
      fhirPathMatches[key]!.constraint = constraint;
    } else if (constraint != null) {
      fhirPathMatches[key]!.constraint = [
        ...fhirPathMatches[key]!.constraint!,
        ...constraint
      ];
    }
  } else {
    fhirPathMatches[key] = FhirValidationObject(
      noIndex: noIndex,
      fullMatch: fullMatch,
      partialMatch: partialMatch,
      constraint: constraint,
    );
  }
  if (fullMatch != null) {
    if (type != null && type.isNotEmpty) {
      if (type.length == 1) {
        fhirPathMatches[key]!.type =
            primitiveTypes[type.first.code.toString()] ??
                type.first.code.toString();
      }
    }
    if (binding != null) {
      fhirPathMatches[key]!.binding = binding;
    }
  }
  return fhirPathMatches;
}

const primitiveTypes = {
  'http://hl7.org/fhirpath/System.Boolean': 'boolean',
  'http://hl7.org/fhirpath/System.Date': 'date',
  'http://hl7.org/fhirpath/System.DateTime': 'dateTime',
  'http://hl7.org/fhirpath/System.Decimal': 'decimal',
  'http://hl7.org/fhirpath/System.Integer': 'integer',
  'http://hl7.org/fhirpath/System.Time': 'time',
  'http://hl7.org/fhirpath/System.String': 'string',
};
