/// The base interface for navigating elements in a hierarchical data model.
///
/// This interface is intended for internal API usage exclusively but is exposed
/// due to its derivation by public interfaces.
abstract class BaseElementNavigator<T> {
  /// Name of the node, e.g., "active", "value".
  String get name;

  /// Type of the node. If a FHIR type, this is a simple string; otherwise, a URL to a StructureDefinition
  /// for a type defined as a logical model.
  String? get instanceType;

  /// The value of the node if it represents a primitive FHIR value.
  ///
  /// FHIR primitives are mapped to underlying Dart types:
  /// - instant: DateTime
  /// - time: TimeOfDay (custom type)
  /// - date: DateTime
  /// - dateTime: DateTime
  /// - decimal: double
  /// - boolean: bool
  /// - integer, unsignedInt, positiveInt, long/integer64: int
  /// - string, code, id, uri, oid, uuid, canonical, url, markdown, base64Binary, xhtml: String
  dynamic get value;

  /// Enumerate the child nodes present in the source representation, if any.
  ///
  /// Optionally filter the children by a given name.
  Iterable<T> children({String? name});
  // Define navigation-related methods that would allow moving through the FHIR data structure.
  T? firstChild();
  T? nextSibling();
  T? moveToChild(int index);
  // Other navigational methods as required.
}
