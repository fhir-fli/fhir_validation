import 'dart:convert';

class SpecialExtensions {
  // Example JSON strings for MUST_SUPPORT_SOURCE and INSTANCE_NAME_SOURCE.
  // You should include all your JSON strings here similarly.
  static const String mustSupportSource =
      '{"resourceType": "StructureDefinition", ...}';
  static const String instanceNameSource =
      '{"resourceType": "StructureDefinition", ...}';
  // Add the rest of your JSON strings here

  // Using a Map for known extensions for easier lookup.
  static const Map<String, String> knownExtensions = {
    "http://hl7.org/fhir/StructureDefinition/elementdefinition-type-must-support":
        mustSupportSource,
    "http://hl7.org/fhir/StructureDefinition/instance-name": instanceNameSource,
    // Add the rest of your extension URLs and their corresponding JSON strings here
  };

  // Assuming you have a function to deserialize JSON string to your StructureDefinition class
  static StructureDefinition? getDefinition(String url) {
    String? src = knownExtensions[url];
    if (src != null) {
      return parseStructureDefinition(src);
    }
    return null;
  }

  // Dummy implementation of parseStructureDefinition.
  // You need to implement this based on your StructureDefinition class.
  static StructureDefinition parseStructureDefinition(String src) {
    // You should implement JSON parsing logic here.
    // This is just a placeholder implementation.
    return StructureDefinition.fromJson(json.decode(src));
  }
}
