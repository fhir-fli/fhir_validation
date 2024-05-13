import 'package:json_annotation/json_annotation.dart';

import '../firely.dart';

part 'any_validator.g.dart';

/// An assertion that expresses that any of its member assertions should hold.
@JsonSerializable()
class AnyValidator implements IGroupValidatable {
  /// The member assertions of which at least one should hold.
  final List<IAssertion> members;

  /// If set, this error will be added to the ResultReport before the
  /// results of all members when the Any fails (= when all members fail).
  final IssueAssertion? summaryError;

  /// Construct an AnyValidator based on its members.
  AnyValidator(List<IAssertion> members, {this.summaryError})
      : members = List.unmodifiable(members);

  @override
  ResultReport validateSingle(
          IScopedNode input, ValidationSettings vc, ValidationState state) =>
      validateMultiple([input], vc, state);

  /// Validate the input based on validation settings and state, returns a result report.
  @override
  ResultReport validateMultiple(
      List<IScopedNode> input, ValidationSettings vc, ValidationState state) {
    if (members.isEmpty) return ResultReport.success;

    // To not pollute the output if there's just a single input, just add it to the output
    if (members.length == 1)
      return members.first.validateMany(input, vc, state);

    var results = <ResultReport>[];

    for (var member in members) {
      var result = member.validateMany(input, vc, state);
      if (result.isSuccessful) {
        // A successful validation exits early with that result.
        return result;
      }
      results.add(result);
    }

    if (summaryError != null) {
      results.insert(0, summaryError!.validateMany(input, vc, state));
    }

    return ResultReport.combine(results);
  }

  /// Convert the validator state to JSON.
  Map<String, dynamic> toJson() => {
        'anyOf': summaryError == null
            ? members.map((m) => m.toJson()).toList()
            : {
                'members': members.map((m) => m.toJson()).toList(),
                'summaryError': summaryError!.toJson(),
              },
      };

  /// Generate an AnyValidator from JSON.
  factory AnyValidator.fromJson(Map<String, dynamic> json) =>
      _$AnyValidatorFromJson(json);
}
