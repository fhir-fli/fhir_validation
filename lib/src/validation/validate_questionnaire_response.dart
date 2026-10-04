import 'package:collection/collection.dart';
import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_validation/fhir_validation.dart';

/// Validates a QuestionnaireResponse against the corresponding
/// Questionnaire, both read by element name.
Future<ValidationResults> validateQuestionnaireResponse({
  required FhirNode questionnaireResponse,
  required ResourceCache resourceCache,
}) async {
  final results = ValidationResults();

  // Extract the questionnaire URL
  final questionnaireUrl =
      questionnaireResponse.getChildByName('questionnaire')?.primitiveValue;
  if (questionnaireUrl == null) {
    return results..addResult(
      null,
      'QuestionnaireResponse does not reference a Questionnaire',
      Severity.error,
    );
  }

  // Retrieve the Questionnaire
  final questionnaireDef = await resourceCache.getCanonicalResource(
    questionnaireUrl,
  );
  if (questionnaireDef == null) {
    return results..addResult(
      null,
      'Failed to retrieve Questionnaire: $questionnaireUrl',
      Severity.error,
    );
  } else if (questionnaireDef.fhirType != 'Questionnaire') {
    return results..addResult(
      null,
      'Resource at $questionnaireUrl is not a Questionnaire',
      Severity.error,
    );
  }

  // Validate the QuestionnaireResponse against the Questionnaire
  results.combineResults(
    await _validateResponseItems(
      questionnaire: questionnaireDef,
      response: questionnaireResponse,
    ),
  );

  return results;
}

String? _linkId(FhirNode item) => item.getChildByName('linkId')?.primitiveValue;

Future<ValidationResults> _validateResponseItems({
  required FhirNode questionnaire,
  required FhirNode response,
}) async {
  final results = ValidationResults();

  // Compare each item in the QuestionnaireResponse with the corresponding
  //item in the Questionnaire
  for (final responseItem in response.getChildrenByName('item')) {
    final linkId = _linkId(responseItem);
    final questionnaireItem = questionnaire
        .getChildrenByName('item')
        .firstWhereOrNull((item) => _linkId(item) == linkId);

    if (questionnaireItem == null) {
      results.addResult(
        null,
        'Response item with linkId $linkId not found in Questionnaire',
        Severity.error,
      );
      continue;
    }

    // Validate item type, constraints, and required fields
    results.combineResults(
      _validateResponseItem(
        questionnaireItem: questionnaireItem,
        responseItem: responseItem,
      ),
    );
  }

  return results;
}

ValidationResults _validateResponseItem({
  required FhirNode questionnaireItem,
  required FhirNode responseItem,
}) {
  final results = ValidationResults();

  // Validate type and constraints
  // Example: Check if the response type matches the questionnaire item type
  // Add additional checks as necessary
  final required =
      questionnaireItem.getChildByName('required')?.primitiveValue == 'true';
  if (required && responseItem.getChildrenByName('answer').isEmpty) {
    results.addResult(
      null,
      'Required response item with linkId ${_linkId(responseItem)} is missing',
      Severity.error,
    );
  }

  // Validate nested items
  for (final nestedResponseItem in responseItem.getChildrenByName('item')) {
    final nestedLinkId = _linkId(nestedResponseItem);
    final nestedQuestionnaireItem = questionnaireItem
        .getChildrenByName('item')
        .firstWhereOrNull((item) => _linkId(item) == nestedLinkId);

    if (nestedQuestionnaireItem != null) {
      results.combineResults(
        _validateResponseItem(
          questionnaireItem: nestedQuestionnaireItem,
          responseItem: nestedResponseItem,
        ),
      );
    } else {
      results.addResult(
        null,
        'Nested response item with linkId $nestedLinkId '
        'not found in Questionnaire',
        Severity.error,
      );
    }
  }

  return results;
}
