import 'package:fhir_primitives/fhir_primitives.dart';

bool isValueAValidPrimitive(String primitiveClass, dynamic value) {
  try {
    switch (primitiveClass) {
      case 'base64binary':
        return FhirBase64Binary.fromJson(value).isValid;
      case 'boolean':
        return FhirBoolean.fromJson(value).isValid;
      case 'canonical':
        return FhirCanonical.fromJson(value).isValid;
      case 'code':
        return FhirCode.fromJson(value).isValid;
      case 'date':
        return FhirDate.fromJson(value).isValid;
      case 'decimal':
        return FhirDecimal.fromJson(value).isValid;
      case 'dateTime':
        return FhirDateTime.fromJson(value).isValid;
      case 'uri':
        return FhirUri.fromJson(value).isValid;
      case 'url':
        return FhirUrl.fromJson(value).isValid;
      case 'id':
        return FhirId.fromJson(value).isValid;
      case 'instant':
        return FhirInstant.fromJson(value).isValid;
      case 'integer':
        return FhirInteger.fromJson(value).isValid;
      case 'integer64':
        return FhirInteger64.fromJson(value).isValid;
      case 'markdown':
        return FhirMarkdown.fromJson(value).isValid;
      case 'xhtml':
        return FhirMarkdown.fromJson(value).isValid;
      case 'oid':
        return FhirOid.fromJson(value).isValid;
      case 'positiveInt':
        return FhirPositiveInt.fromJson(value).isValid;
      case 'time':
        return FhirTime.fromJson(value).isValid;
      case 'unsignedInt':
        return FhirUnsignedInt.fromJson(value).isValid;
      case 'uuid':
        return FhirUuid.fromJson(value).isValid;
      case 'string':
        return true;
      default:
        return false;
    }
  } catch (e) {
    return false;
  }
}
