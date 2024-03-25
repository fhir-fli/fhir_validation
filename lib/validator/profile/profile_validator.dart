import 'package:fhir/r5.dart'; // Assuming an existing FHIR R5 Dart package
import 'validation_message.dart'; // A custom class to handle validation messages

class ProfileValidator {
  bool checkAggregation = false;
  bool checkMustSupport = false;
  bool allowDoubleQuotesInFHIRPath = false;
  late FHIRPathEngine
      fpe; // Assuming an existing FHIRPath engine implementation in Dart

  ProfileValidator(IWorkerContext context, XVerExtensionManager xverManager) {
    // Initialization code here
    fpe = FHIRPathEngine(context);
    fpe.allowDoubleQuotes = allowDoubleQuotesInFHIRPath;
  }

  // Example of a validation rule method in Dart
  bool rule(List<ValidationMessage> errors, IssueType type, String path,
      bool condition, String msg) {
    // Implementation of rule checking and error collection
    return condition;
  }

  // Method to validate a StructureDefinition (profile)
  List<ValidationMessage> validate(StructureDefinition profile, bool forBuild) {
    List<ValidationMessage> errors = [];

    // Validation logic here

    return errors;
  }

  bool checkExtensions(StructureDefinition profile,
      List<ValidationMessage> errors, String kind, ElementDefinition ec) {
    if (ec.types.isNotEmpty &&
        ec.types.first.code == 'Extension' &&
        ec.types.first.profile.isNotEmpty) {
      String url = ec.types.first.profile.first;
      var defn = context.fetchResource(StructureDefinition, url);
      if (defn == null) {
        // Assuming getXverExt is a function that tries to fetch the extension in some other way
        defn = getXverExt(profile, errors, url);
      }
      return rule(errors, IssueType.businessRule, profile.id, defn != null,
          "Unable to find Extension '$url' referenced at ${profile.url} $kind ${ec.path} (${ec.sliceName})");
    } else {
      return true;
    }
  }
}
