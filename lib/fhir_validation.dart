/// FHIR resource validation for every FHIR version: a resource (as JSON) is
/// checked against its StructureDefinition for structure, cardinality,
/// bindings, extensions and invariants, and a QuestionnaireResponse against
/// its Questionnaire.
///
/// Definitions (StructureDefinition, ValueSet, CodeSystem, Questionnaire)
/// are read by element name through the `fhir_node` contract from a
/// `fhir_path` [ResourceCache]; what a version has to supply is a
/// [ValidationModel] (`fhir_r4_validation`, `fhir_r5_validation`,
/// `fhir_r6_validation`): its primitive-value rules, how a JSON value
/// becomes a typed FHIRPath context, and the fhir_path binding.
library;

export 'package:fhir_path/fhir_path.dart'
    show
        CanonicalResourceCache,
        ElementBinding,
        ElementConstraint,
        ElementNode,
        ElementType,
        OnlineResourceCache,
        ResourceCache;

export 'src/utils/definitions.dart';
export 'src/utils/for_primitives.dart';
export 'src/utils/json_to_ast.dart';
export 'src/validation/fhir_validation_engine.dart';
export 'src/validation/validate_binding.dart';
export 'src/validation/validate_cardinality.dart';
export 'src/validation/validate_extensions.dart';
export 'src/validation/validate_invariant.dart';
export 'src/validation/validate_questionnaire_response.dart';
export 'src/validation/validate_structure.dart';
export 'src/validation/validation_results.dart';
export 'src/validation_model.dart';
