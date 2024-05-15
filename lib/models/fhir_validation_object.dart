import 'package:fhir_r4/fhir_r4.dart';

/// Class to represent the FHIR validation object.
/// This object stores information about the paths in the FHIR resource that are being validated.
class FhirValidationObject {
  FhirValidationObject({
    required this.noIndex, // Path without index
    this.fullMatch = '', // Full match path
    this.partialMatch = '', // Partial match path
    this.type = '', // Type of the element
    this.binding, // Binding information for the element
    this.constraint, // Constraints on the element
  });

  String noIndex;
  String? fullMatch;
  String? partialMatch;
  String? type;
  ElementDefinitionBinding? binding;
  List<ElementDefinitionConstraint>? constraint;

  // Convert the FhirValidationObject to a JSON map.
  Map<String, dynamic> toJson() => {
        'noIndex': noIndex,
        'fullMatch': fullMatch,
        'partialMatch': partialMatch,
        'type': type,
        'binding': binding?.toJson(),
        'constraint': constraint?.map((e) => e.toJson()).toList(),
      };

  // Override toString to provide a string representation of the FhirValidationObject.
  @override
  String toString() {
    return toJson().toString();
  }
}

/// Function to add or update the FHIR path matches in the map.
/// This function helps in maintaining the validation information for each FHIR path.
Map<String, FhirValidationObject> addToFhirPathMatches({
  required Map<String, FhirValidationObject>
      fhirPathMatches, // Existing map of FHIR path matches
  required String key, // Key for the FHIR path
  required String noIndex, // Path without index
  String? fullMatch, // Full match path
  String? partialMatch, // Partial match path
  required List<ElementDefinitionType>? type, // Type of the element
  required ElementDefinitionBinding?
      binding, // Binding information for the element
  required List<ElementDefinitionConstraint>?
      constraint, // Constraints on the element
}) {
  // Check if the key already exists in the map
  if (fhirPathMatches.containsKey(key)) {
    // Update the existing FhirValidationObject
    fhirPathMatches[key]!.noIndex = noIndex;
    fhirPathMatches[key]!.fullMatch =
        fullMatch ?? fhirPathMatches[key]!.fullMatch;
    fhirPathMatches[key]!.partialMatch =
        partialMatch ?? fhirPathMatches[key]!.partialMatch;
    // Update constraints
    if (fhirPathMatches[key]!.constraint == null) {
      fhirPathMatches[key]!.constraint = constraint;
    } else if (constraint != null) {
      fhirPathMatches[key]!.constraint = [
        ...fhirPathMatches[key]!.constraint!,
        ...constraint
      ];
    }
  } else {
    // Add a new FhirValidationObject to the map
    fhirPathMatches[key] = FhirValidationObject(
      noIndex: noIndex,
      fullMatch: fullMatch,
      partialMatch: partialMatch,
      constraint: constraint,
    );
  }
  // Set the type and binding if fullMatch is not null
  if (fullMatch != null) {
    if (type != null && type.isNotEmpty) {
      if (type.length == 1) {
        fhirPathMatches[key]!.type =
            canonicalToPrimitiveType[type.first.code.toString()] ??
                type.first.code.toString();
      }
    }
    if (binding != null) {
      fhirPathMatches[key]!.binding = binding;
    }
  }
  return fhirPathMatches;
}

// Map to convert canonical URLs to primitive types.
const canonicalToPrimitiveType = {
  'http://hl7.org/fhirpath/System.Boolean': 'boolean',
  'http://hl7.org/fhirpath/System.Date': 'date',
  'http://hl7.org/fhirpath/System.DateTime': 'dateTime',
  'http://hl7.org/fhirpath/System.Decimal': 'decimal',
  'http://hl7.org/fhirpath/System.Integer': 'integer',
  'http://hl7.org/fhirpath/System.Time': 'time',
  'http://hl7.org/fhirpath/System.String': 'string',
};
