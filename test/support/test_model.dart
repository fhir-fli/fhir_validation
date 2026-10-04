import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';
import 'package:fhir_validation/fhir_validation.dart';

/// The test model: JSON in and out over [JsonNode], primitive rules from the
/// JSON scalar's type, FHIRPath contexts as plain nodes. It has no
/// fhir_path binding: invariant evaluation needs a version's value factory
/// and is tested through the bindings (fhir_r4_validation and siblings).
class TestModel extends ValidationModel<JsonNode> {
  const TestModel();

  @override
  String get fhirVersion => 'test';

  @override
  Set<String> get resourceTypeNames => const {
    'Bundle',
    'CodeSystem',
    'Observation',
    'OperationOutcome',
    'Patient',
    'Questionnaire',
    'QuestionnaireResponse',
    'StructureDefinition',
    'ValueSet',
  };

  @override
  JsonNode fromJson(Map<String, dynamic> json) => JsonNode.resource(json);

  @override
  Map<String, dynamic> toJson(JsonNode resource) => resource.json;

  @override
  FhirModelBinding get pathBinding =>
      throw UnimplementedError('invariants are tested through a binding');

  @override
  bool isValidPrimitive(String type, Object? value) => switch (type
      .toLowerCase()) {
    'boolean' => value is bool,
    'integer' || 'positiveint' || 'unsignedint' => value is int,
    'decimal' => value is num,
    'date' ||
    'datetime' ||
    'instant' => value is String && DateTime.tryParse(value) != null,
    _ => value is String,
  };

  @override
  FhirNode? fromType(Object? value, String type) =>
      value == null ? null : JsonNode(value, type);
}

const testModel = TestModel();

/// An ElementDefinition from its JSON, as the core's view.
ElementNode element(Map<String, dynamic> json) =>
    ElementNode(JsonNode(json, 'ElementDefinition'));

/// An ElementDefinition of [path] with one [type] and optional parts.
ElementNode typed(
  String path,
  String type, {
  int? min,
  String? max,
  Map<String, dynamic>? binding,
  List<Map<String, dynamic>>? constraint,
  List<String>? profile,
}) => element({
  'path': path,
  if (min != null) 'min': min,
  if (max != null) 'max': max,
  'type': [
    {
      'code': type,
      if (profile != null) 'profile': profile,
    },
  ],
  if (binding != null) 'binding': binding,
  if (constraint != null) 'constraint': constraint,
});

/// A resource from JSON.
JsonNode resource(Map<String, dynamic> json) => testModel.fromJson(json);

/// The Patient StructureDefinition the seam tests use: a resource with an
/// id of the System String type.
final JsonNode patientDefinition = resource({
  'resourceType': 'StructureDefinition',
  'id': 'Patient',
  'url': 'http://hl7.org/fhir/StructureDefinition/Patient',
  'name': 'Patient',
  'status': 'active',
  'kind': 'resource',
  'abstract': false,
  'type': 'Patient',
  'baseDefinition': 'http://hl7.org/fhir/StructureDefinition/DomainResource',
  'derivation': 'specialization',
  'snapshot': {
    'element': [
      {'id': 'Patient', 'path': 'Patient', 'min': 0, 'max': '*'},
      {
        'id': 'Patient.id',
        'path': 'Patient.id',
        'min': 0,
        'max': '1',
        'type': [
          {'code': 'http://hl7.org/fhirpath/System.String'},
        ],
      },
    ],
  },
});
