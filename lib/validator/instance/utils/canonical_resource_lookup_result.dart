import 'package:fhir/r5.dart';

class CanonicalResourceLookupResult {
  Resource? resource;
  String? error;

  CanonicalResourceLookupResult({this.resource, this.error});
}
