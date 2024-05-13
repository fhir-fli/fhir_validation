import 'package:fhir_r4/fhir_r4.dart';

import '../firely.dart';

/// Base class for validation of terminology binding requirements for a coded element.
abstract class BindingValidator implements IValidatable {
  /// Uri for the valueset to validate the code in the instance against.
  final String valueSetUri;

  /// Binding strength for the binding - determines whether an incorrect code is an error.
  final BindingStrength? strength;

  /// Whether abstract codes (that exist mostly for subsumption queries) may be used in an instance.
  final bool abstractAllowed;

  /// The context of the value set, so that the server can resolve this to a value set to validate against.
  final String? context;

  BindingValidator({
    required this.valueSetUri,
    this.strength,
    this.abstractAllowed = true,
    this.context,
  });

  @override
  ResultReport validateSingle(
      IScopedNode? input, ValidationSettings vc, ValidationState state) {
    if (input == null) {
      throw ArgumentError.notNull('input');
    }
    if (input.instanceType == null) {
      throw ArgumentError.value(input, 'input',
          'Binding validation requires input to have an instance type.');
    }
    if (vc.validateCodeService == null) {
      throw StateError(
          'ValidationSettings does not have its validateCodeService set.');
    }

    if (!isBindable(input.instanceType)) {
      return ResultReport.success;
    }

    final bindable = parseBindable(input);
    if (bindable == null) {
      return ResultReport.success;
    }

    var contentVerification = verifyContentRequirements(input, bindable, state);
    if (!contentVerification.isSuccessful) {
      return contentVerification;
    }

    return validateCode(bindable, vc, state);
  }

  bool isBindable(Type? instanceType);

  Element? parseBindable(IScopedNode input);

  ResultReport verifyContentRequirements(
      IScopedNode source, Element bindable, ValidationState state);

  ResultReport validateCode(
      Element bindable, ValidationSettings vc, ValidationState state);
}

/// Represents the binding strength of a validation requirement.
enum BindingStrength {
  required,
  extensible,
  preferred,
  example,
}
