import 'dart:async';

import '../firely.dart';

/// Dependencies and settings used by the validator across all invocations.
class ValidationSettings {
  IElementSchemaResolver elementSchemaResolver;
  ICodeValidationTerminologyService? validateCodeService;
  TypeNameMapper? typeNameMapper;
  ValidateCodeServiceFailureHandler? handleValidateCodeServiceFailure;
  ExternalReferenceResolver? resolveExternalReference;
  FhirPathCompiler? fhirPathCompiler;
  ValidateBestPracticesSeverity constraintBestPractices;
  MetaProfileSelector? selectMetaProfiles;
  ExtensionUrlFollower? followExtensionUrl;
  List<Predicate<IAssertion>> includeFilters;
  List<Predicate<IAssertion>> excludeFilters;
  bool traceEnabled;

  ValidationSettings({
    required this.elementSchemaResolver,
    required this.validateCodeService,
    this.typeNameMapper,
    this.handleValidateCodeServiceFailure,
    this.resolveExternalReference,
    this.fhirPathCompiler,
    this.constraintBestPractices = ValidateBestPracticesSeverity.warning,
    this.selectMetaProfiles,
    this.followExtensionUrl,
    this.includeFilters = const [],
    this.excludeFilters = const [],
    this.traceEnabled = false,
  });

  /// This method determines whether a given assertion is included in the validation.
  bool filter(IAssertion assertion) =>
      (includeFilters.isEmpty ||
          includeFilters.any((filter) => filter(assertion))) &&
      !excludeFilters.any((filter) => filter(assertion));

  /// Invokes a factory method for assertions only when tracing is on.
  ResultReport traceResult(ResultReport Function() p) =>
      traceEnabled ? p() : ResultReport.success();
}

/// Interfaces and enums to be defined based on the types used in the provided C# code.

enum ValidateBestPracticesSeverity { warning, error }

enum TerminologyServiceExceptionResult { warning, error }

enum ExtensionUrlHandling { dontResolve, warnIfMissing, errorIfMissing }

abstract class ICodeValidationTerminologyService {
  Future<Parameters> subsumes(Parameters parameters,
      {String? id, bool useGet = false});
  Future<Parameters> validateCode(Parameters parameters,
      {String? id, bool useGet = false});
}

typedef TypeNameMapper = String Function(String typeName);
typedef ValidateCodeServiceFailureHandler
    = TerminologyServiceExceptionResult Function(
        ValidateCodeParameters parameters, FhirOperationException exception);
typedef ExternalReferenceResolver = ITypedElement? Function(
    String reference, String location);
typedef MetaProfileSelector = List<Canonical> Function(
    String location, List<Canonical> originalProfiles);
typedef ExtensionUrlFollower = ExtensionUrlHandling Function(
    String location, Canonical? url);

class FhirOperationException implements Exception {
  final String message;

  FhirOperationException(this.message);
}

class Canonical {
  final String uri;

  Canonical(this.uri);
}
