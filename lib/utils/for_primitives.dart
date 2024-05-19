import 'package:fhir_primitives/fhir_primitives.dart';

bool isPrimitiveType(String type) => (<String>[
      'base64binary',
      'boolean',
      'canonical',
      'code',
      'date',
      'decimal',
      'datetime',
      'uri',
      'url',
      'id',
      'instant',
      'integer',
      'integer64',
      'markdown',
      'xhtml',
      'oid',
      'positiveint',
      'time',
      'unsignedint',
      'uuid',
      'string',
      'http://hl7.org/fhirpath/system.string'
    ].contains(type.toLowerCase()));

bool isComparablePrimitive(String type) => (<String>[
      'date',
      'decimal',
      'datetime',
      'instant',
      'integer',
      'integer64',
      'positiveint',
      'time',
      'unsignedint',
    ].contains(type.toLowerCase()));

String fhirPrimitiveToDartPrimitive(String primitiveClass) {
  primitiveClass = primitiveClass.toLowerCase();
  switch (primitiveClass) {
    case 'base64binary':
      return 'string';
    case 'boolean':
      return 'bool';
    case 'canonical':
      return 'string';
    case 'code':
      return 'string';
    case 'date':
      return 'string';
    case 'decimal':
      return 'double';
    case 'datetime':
      return 'string';
    case 'uri':
      return 'string';
    case 'url':
      return 'string';
    case 'id':
      return 'string';
    case 'instant':
      return 'string';
    case 'integer':
      return 'int';
    case 'integer64':
      return 'string';
    case 'markdown':
      return 'string';
    case 'xhtml':
      return 'string';
    case 'oid':
      return 'string';
    case 'positiveint':
      return 'int';
    case 'time':
      return 'string';
    case 'unsignedint':
      return 'int';
    case 'uuid':
      return 'string';
    case 'http://hl7.org/fhirpath/system.string':
    case 'string':
      return 'string';
    default:
      return 'not defined';
  }
}

bool isValueAValidPrimitive(String primitiveClass, dynamic value) {
  primitiveClass = primitiveClass.toLowerCase();
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
        return value is String ? FhirDate.fromJson(value).isValid : false;
      case 'decimal':
        return FhirDecimal.fromJson(value).isValid;
      case 'datetime':
        return value is String ? FhirDateTime.fromJson(value).isValid : false;
      case 'uri':
        return FhirUri.fromJson(value).isValid;
      case 'url':
        return FhirUrl.fromJson(value).isValid;
      case 'id':
        return FhirId.fromJson(value).isValid;
      case 'instant':
        return value is String ? FhirInstant.fromJson(value).isValid : false;
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
      case 'positiveint':
        return FhirPositiveInt.fromJson(value).isValid;
      case 'time':
        return FhirTime.fromJson(value).isValid;
      case 'unsignedint':
        return FhirUnsignedInt.fromJson(value).isValid;
      case 'uuid':
        return FhirUuid.fromJson(value).isValid;
      case 'http://hl7.org/fhirpath/system.string':
      case 'string':
        return value is String;
      default:
        return false;
    }
  } catch (e) {
    return false;
  }
}
