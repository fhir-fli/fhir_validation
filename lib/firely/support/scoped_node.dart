import '../firely.dart';

/// An element within a tree of typed FHIR data with also a parent element.
///
/// This interface represents FHIR data as a tree of elements, including type information
/// either present in the instance or derived from fully aware of the FHIR definitions and types.
abstract class ScopedNode implements BaseElementNavigator<ScopedNode> {
  // In Dart, the parent property can be defined if needed. Here it's commented out to match the C# example's indications.
  // IScopedNode? get parent;
}
