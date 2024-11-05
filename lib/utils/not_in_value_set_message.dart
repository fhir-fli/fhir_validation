import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:http/http.dart';

/// Returns a message indicating that the value is not in the value set.
Future<String> notInValueSetMessage(
  dynamic value,
  FhirCanonical? valueSetCanonical,
  String message,
  Client? client,
) async {
  if (valueSetCanonical == null) {
    return 'There was an error in our software evaluating the value ($value), '
        'please let us know.';
  }
  final valueSetMap = await getResource(valueSetCanonical.toString(), client);

  if (valueSetMap != null && valueSetMap['resourceType'] == 'ValueSet') {
    final valueSet = ValueSet.fromJson(valueSetMap);
    if (valueSet.title != null) {
      return 'The value provided ($value) is not from the ValueSet '
          '${valueSet.title} ($valueSetCanonical), $message.';
    } else if (valueSet.name != null) {
      return 'The value provided ($value) is not from the ValueSet '
          '${valueSet.name}} ($valueSetCanonical), $message.';
    }
  }
  return 'The value provided ($value) is not from the ValueSet '
      '($valueSetCanonical), $message.';
}
