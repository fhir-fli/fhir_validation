/// The base interface for an assertion.
///
/// Assertions are both input to the validator (in the form of [IValidatable] assertions) and output
/// of the validator ([ResultReport]).
abstract class IAssertion {
  Map<String, dynamic> toJson();
  // Add any additional methods or properties necessary for the implementations of assertions.
}
