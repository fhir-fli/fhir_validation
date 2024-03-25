import 'element.dart'; // Assuming you have an Element class for FHIR elements
import 'validation_message.dart'; // Assuming you have a ValidationMessage class

class ValidationContext {
  dynamic appContext; // Dart uses dynamic for general types
  String? version;
  Element? resource;
  Element? rootResource;
  Element? groupingResource;
  StructureDefinition? profile; // Assuming you have a StructureDefinition class
  bool checkSpecials = true;
  Map<String, List<ValidationMessage>>? sliceRecords;
  Set<String>? internalRefs;

  ValidationContext(this.appContext,
      {this.resource, this.rootResource, this.groupingResource, this.profile}) {
    internalRefs = _setupInternalRefs(resource);
    _check();
    _dump("creating");
  }

  Set<String> _setupInternalRefs(Element? element) {
    // Assuming Element class has getUserData and setUserData methods or equivalent
    var res = element?.getUserData(ValidationContext.internalReferencesName)
        as Set<String>?;
    res ??= <String>{};
    element?.setUserData(ValidationContext.internalReferencesName, res);
    return res;
  }

  void _check() {
    if (rootResource?.parentForValidator == null) {
      throw Exception("No parent on root resource");
    }
  }

  void _dump(String ctxt) {
    // Dart doesn't have a direct equivalent to Java's System.out.println for console logging.
    // You can use print for debugging. For production, consider a logging package.
    // print("** app = ${appContext ?? '(null)'}, res = ${resource.toString()}, root = ${rootResource.toString()} ($ctxt)");
  }

  static const internalReferencesName = "internal.references";

  ValidationContext forContained(Element element) {
    return ValidationContext(
      appContext,
      resource: element,
      rootResource: resource,
      profile: profile,
      groupingResource: groupingResource,
    ).._dump("forContained");
  }

  // Additional 'forXXX' methods would follow a similar pattern,
  // adapting parameters and properties as needed for your validation context's requirements.

  // Getter and setter methods from Java are not directly translated,
  // as Dart allows direct access to public properties or uses more concise methods.
}
