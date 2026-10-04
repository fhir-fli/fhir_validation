import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_validation/fhir_validation.dart';
import 'package:test/test.dart';

import 'support/test_model.dart';

void main() {
  JsonNode response(
    List<Map<String, dynamic>>? items, {
    bool reference = true,
  }) => resource({
    'resourceType': 'QuestionnaireResponse',
    'id': 'example',
    'status': 'completed',
    if (reference) 'questionnaire': 'http://example.org/Questionnaire/q',
    if (items != null) 'item': items,
  });

  final questionnaire = resource({
    'resourceType': 'Questionnaire',
    'url': 'http://example.org/Questionnaire/q',
    'status': 'active',
    'item': [
      {'linkId': 'q1', 'type': 'string', 'required': true},
      {
        'linkId': 'group1',
        'type': 'group',
        'item': [
          {'linkId': 'g1', 'type': 'string', 'required': true},
        ],
      },
    ],
  });

  group('validateQuestionnaireResponse', () {
    test('reports error when the Questionnaire cannot be retrieved', () async {
      final results = await validateQuestionnaireResponse(
        questionnaireResponse: response([]),
        resourceCache: CanonicalResourceCache(),
      );

      expect(
        results.results.map((r) => r.diagnostics),
        ['Failed to retrieve Questionnaire: http://example.org/Questionnaire/q'],
      );
    });

    test('reports error when QuestionnaireResponse has no questionnaire '
        'reference', () async {
      final results = await validateQuestionnaireResponse(
        questionnaireResponse: response(null, reference: false),
        resourceCache: CanonicalResourceCache(),
      );

      expect(results.hasErrors, isTrue);
      expect(
        results.results.any(
          (r) => r.diagnostics.contains('does not reference a Questionnaire'),
        ),
        isTrue,
      );
    });

    test('reports a resource at the URL that is not a Questionnaire', () async {
      final cache =
          CanonicalResourceCache()..see(
            resource({
              'resourceType': 'ValueSet',
              'url': 'http://example.org/Questionnaire/q',
            }),
          );
      final results = await validateQuestionnaireResponse(
        questionnaireResponse: response([]),
        resourceCache: cache,
      );
      expect(
        results.results.single.diagnostics,
        'Resource at http://example.org/Questionnaire/q is not a Questionnaire',
      );
    });

    test('a complete response has no findings', () async {
      final cache = CanonicalResourceCache()..see(questionnaire);
      final results = await validateQuestionnaireResponse(
        questionnaireResponse: response([
          {
            'linkId': 'q1',
            'answer': [
              {'valueString': 'John Doe'},
            ],
          },
          {
            'linkId': 'group1',
            'item': [
              {
                'linkId': 'g1',
                'answer': [
                  {'valueString': 'yes'},
                ],
              },
            ],
          },
        ]),
        resourceCache: cache,
      );
      expect(results.results, isEmpty);
    });

    test('validates required response items, top level and nested', () async {
      final cache = CanonicalResourceCache()..see(questionnaire);
      final results = await validateQuestionnaireResponse(
        questionnaireResponse: response([
          {'linkId': 'q1'},
          {
            'linkId': 'group1',
            'item': [
              {'linkId': 'g1'},
            ],
          },
        ]),
        resourceCache: cache,
      );
      expect(results.results.map((r) => r.diagnostics), [
        'Required response item with linkId q1 is missing',
        'Required response item with linkId g1 is missing',
      ]);
    });

    test('reports response items not found in the Questionnaire', () async {
      final cache = CanonicalResourceCache()..see(questionnaire);
      final results = await validateQuestionnaireResponse(
        questionnaireResponse: response([
          {
            'linkId': 'q2',
            'answer': [
              {'valueString': 'Answer'},
            ],
          },
          {
            'linkId': 'group1',
            'item': [
              {'linkId': 'g9'},
            ],
          },
        ]),
        resourceCache: cache,
      );
      expect(results.results.map((r) => r.diagnostics), [
        'Response item with linkId q2 not found in Questionnaire',
        'Nested response item with linkId g9 not found in Questionnaire',
      ]);
    });

    test('handles QuestionnaireResponse with empty items', () async {
      final cache = CanonicalResourceCache()..see(questionnaire);
      final results = await validateQuestionnaireResponse(
        questionnaireResponse: response([]),
        resourceCache: cache,
      );
      expect(results.results, isEmpty);
    });
  });
}
