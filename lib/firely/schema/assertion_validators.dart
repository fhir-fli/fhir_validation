import '../firely.dart';

/// Extension methods for IAssertion to enable uniform validation method calls.
extension AssertionValidators on IAssertion {
  /// Validates a set of instance elements against an assertion.
  ResultReport validate(List<IScopedNode> input, ValidationSettings vc) =>
      validateMany(input, vc, ValidationState());

  /// Validates a set of instance elements against an assertion.
  ResultReport validateTyped(
          List<ITypedElement> input, ValidationSettings vc) =>
      validateMany(
          input.map((i) => i?.asScopedNode()).toList(), vc, ValidationState());

  /// Validates a single instance element against an assertion.
  ResultReport validateSingle(IScopedNode input, ValidationSettings vc) =>
      validateOne(input, vc, ValidationState());

  /// Validates a single instance element against an assertion.
  ResultReport validateTypedSingle(
          ITypedElement input, ValidationSettings vc) =>
      validateOne(input.asScopedNode(), vc, ValidationState());

  /// Validates a group of instance elements using an assertion.
  ResultReport validateMany(
      List<IScopedNode> input, ValidationSettings vc, ValidationState state) {
    if (this is IGroupValidatable) {
      return (this as IGroupValidatable).validate(input, vc, state);
    } else if (this is IValidatable) {
      return _repeatValidation(this as IValidatable, input, vc, state);
    } else {
      return ResultReport.success;
    }
  }

  /// Validates a single instance element using an assertion.
  ResultReport validateOne(
      IScopedNode input, ValidationSettings vc, ValidationState state) {
    if (this is IValidatable) {
      return (this as IValidatable).validate([input], vc, state);
    } else {
      return ResultReport.success;
    }
  }

  /// Determines if the given assertion always results in a specified [ValidationResult].
  bool isAlways(ValidationResult result) =>
      this is IFixedResult && (this as IFixedResult).fixedResult == result;

  /// Helper method to perform repetitive validation and combine the results.
  ResultReport _repeatValidation(IValidatable assertion,
      List<IScopedNode> input, ValidationSettings vc, ValidationState state) {
    if (input.isEmpty) return ResultReport.success;

    var results = input.asMap().entries.map((entry) {
      var index = entry.key;
      var node = entry.value;
      return assertion.validate(node, vc,
          state.updateInstanceLocation((path) => path.toIndex(index)));
    }).toList();

    return ResultReport.combine(results);
  }
}
