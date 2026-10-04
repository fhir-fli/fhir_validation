import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

/// What the validator needs from a FHIR version, supplied by a binding
/// (`fhir_r4_validation`, `fhir_r5_validation`, `fhir_r6_validation`).
///
/// Beyond [ResourceModel] (version, resource type names, resources from
/// and to JSON): the version's rules for a primitive value, a typed node
/// from a JSON value for FHIRPath evaluation, and the fhir_path binding the
/// invariant engine runs over.
abstract class ValidationModel<R extends FhirNode> extends ResourceModel<R> {
  /// Creates a model.
  const ValidationModel();

  /// The fhir_path binding of this version, for the invariant engine.
  FhirModelBinding get pathBinding;

  /// Whether [value] (a decoded JSON scalar) is a valid instance of the
  /// primitive [type] (`date`, `positiveInt`, `uuid`, ...), by this
  /// version's rules.
  bool isValidPrimitive(String type, Object? value);

  /// A node of [type] built from [value] (a decoded JSON scalar or map),
  /// or null when the version cannot build one; the context an invariant's
  /// FHIRPath expression is evaluated against.
  FhirNode? fromType(Object? value, String type);
}
