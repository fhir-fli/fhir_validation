import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import 'package:collection/collection.dart';

import 'package:fhir_validation/fhir_validation.dart';

Future<ValidationResults> validateQuestionnaireResponse({
  required QuestionnaireResponse questionnaireResponse,
  required Client? client,
}) async {
  final results = ValidationResults();

  // Extract the questionnaire URL
  final questionnaireUrl = questionnaireResponse.questionnaire?.toString();
  if (questionnaireUrl == null) {
    return results
      ..addResult(
        null,
        'QuestionnaireResponse does not reference a Questionnaire',
        Severity.error,
      );
  }

  // Retrieve the Questionnaire
  final questionnaireDef = await getResource(questionnaireUrl, client);
  if (questionnaireDef == null) {
    return results
      ..addResult(
        null,
        'Failed to retrieve Questionnaire: $questionnaireUrl',
        Severity.error,
      );
  }
  final questionnaire = Questionnaire.fromJson(questionnaireDef);

  // Validate the QuestionnaireResponse against the Questionnaire
  results.combineResults(
    await _validateResponseItems(
      questionnaire: questionnaire,
      response: questionnaireResponse,
    ),
  );

  return results;
}

Future<ValidationResults> _validateResponseItems({
  required Questionnaire questionnaire,
  required QuestionnaireResponse response,
}) async {
  final results = ValidationResults();

  // Compare each item in the QuestionnaireResponse with the corresponding item in the Questionnaire
  for (final responseItem in response.item ?? <QuestionnaireResponseItem>[]) {
    final questionnaireItem = questionnaire.item?.firstWhereOrNull(
      (QuestionnaireItem item) => item.linkId == responseItem.linkId,
    );

    if (questionnaireItem == null) {
      results.addResult(
        null,
        'Response item with linkId ${responseItem.linkId} not found in Questionnaire',
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
  required QuestionnaireItem questionnaireItem,
  required QuestionnaireResponseItem responseItem,
}) {
  final results = ValidationResults();

  // Validate type and constraints
  // Example: Check if the response type matches the questionnaire item type
  // Add additional checks as necessary
  if (questionnaireItem.required_?.value == true &&
      (responseItem.answer == null || responseItem.answer!.isEmpty)) {
    results.addResult(
      null,
      'Required response item with linkId ${responseItem.linkId} is missing',
      Severity.error,
    );
  }

  // Validate nested items
  for (final nestedResponseItem
      in responseItem.item ?? <QuestionnaireResponseItem>[]) {
    final nestedQuestionnaireItem = questionnaireItem.item?.firstWhereOrNull(
      (QuestionnaireItem item) => item.linkId == nestedResponseItem.linkId,
    );

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
        'Nested response item with linkId ${nestedResponseItem.linkId} not found in Questionnaire',
        Severity.error,
      );
    }
  }

  return results;
}
