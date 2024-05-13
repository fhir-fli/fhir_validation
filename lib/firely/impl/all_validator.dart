import 'package:json_annotation/json_annotation.dart';

import '../firely.dart';

part 'all_validator.g.dart';

/// An assertion that expresses that all member assertions should hold.
@JsonSerializable()
class AllValidator implements IGroupValidatable {
  /// The member assertions the instance should be validated against.
  final List<IAssertion> members;

  /// When set to true, the validation of all the Members stops as soon as a single member validates to not Success.
  /// When set to false (default) all Members will be validated.
  final bool shortcircuitEvaluation;

  /// Construct an AllValidator based on its members.
  AllValidator(List<IAssertion> members, {this.shortcircuitEvaluation = false})
      : members = List.unmodifiable(members);

  @override
  ResultReport validateSingle(
          IScopedNode input, ValidationSettings vc, ValidationState state) =>
      validateMultiple([input], vc, state);

  /// Validate the input based on validation settings and state, returns a result report.
  @override
  ResultReport validateMultiple(
      List<IScopedNode> input, ValidationSettings vc, ValidationState state) {
    var evidence = <ResultReport>[];
    for (var member in members) {
      var result = member.validateMany(input, vc, state);
      evidence.add(result);
      if (shortcircuitEvaluation && !result.isSuccessful) break;
    }
    return ResultReport.combine(evidence);
  }

  /// Convert the validator state to JSON.
  Map<String, dynamic> toJson() => {
        'allOf': shortcircuitEvaluation
            ? {
                'shortcircuitEvaluation': shortcircuitEvaluation,
                'members': members.map((m) => m.toJson()).toList(),
              }
            : members.map((m) => m.toJson()).toList(),
      };

  /// Generate an AllValidator from JSON.
  factory AllValidator.fromJson(Map<String, dynamic> json) =>
      _$AllValidatorFromJson(json);
}
