import '../firely.dart';

/// Interface implemented by assertions that work on a single [IScopedNode].
abstract class IValidatable implements IAssertion {
  /// Validates a single instance.
  ResultReport validateSingle(
      IScopedNode input, ValidationSettings vc, ValidationState state);
}
