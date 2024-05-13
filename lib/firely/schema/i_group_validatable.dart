import '../firely.dart';

/// The interface for a validation assertion that validates a rule about a set of elements.
/// A rule that validates cardinality is a great example of this kind of assertion.
abstract class IGroupValidatable implements IAssertion, IValidatable {
  /// Validates a set of instances, given a location representative for the group.
  ResultReport validateMultiple(
      List<IScopedNode> input, ValidationSettings vc, ValidationState state);
}
