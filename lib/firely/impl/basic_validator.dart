import '../firely.dart';

/// Base class for simple validators that have only a single property to configure.
abstract class BasicValidator implements IValidatable {
  /// Convert the validator state to JSON.
  Map<String, dynamic> toJson() => {key: value};

  /// Validate the input based on validation settings and state, returns a result report.
  @override
  ResultReport validateSingle(
          IScopedNode input, ValidationSettings vc, ValidationState state) =>
      validateMultiple([input], vc, state);

  /// Perform the basic validation.
  ResultReport validateMultiple(
      List<IScopedNode> input, ValidationSettings vc, ValidationState state);

  /// The name of the property used in the json serialization for this validator.
  String get key;

  /// The value of the property used in the json serialization for this validator.
  dynamic get value;
}
