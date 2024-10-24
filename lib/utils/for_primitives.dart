import 'package:fhir_r4/fhir_r4.dart';

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
      'http://hl7.org/fhirpath/system.string',
      'backboneelement',
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
        FhirBase64Binary.fromJson(value);
      case 'boolean':
        FhirBoolean.fromJson(value);
      case 'canonical':
        FhirCanonical.fromJson(value);
      case 'code':
        FhirCode.fromJson(value);
      case 'date':
        if (value is String) {
          FhirDate.fromString(value);
        } else {
          return false;
        }
      case 'decimal':
        FhirDecimal.fromJson(value);
      case 'datetime':
        if (value is String) {
          FhirDateTime.fromString(value);
        } else {
          return false;
        }
      case 'uri':
        FhirUri.fromJson(value);
      case 'url':
        FhirUrl.fromJson(value);
      case 'id':
        FhirId.fromJson(value);
      case 'instant':
        if (value is String) {
          FhirInstant.fromString(value);
        } else {
          return false;
        }
      case 'integer':
        FhirInteger.fromJson(value);
      case 'integer64':
        FhirInteger64.fromJson(value);
      case 'markdown':
        FhirMarkdown.fromJson(value);
      case 'xhtml':
        FhirMarkdown.fromJson(value);
      case 'oid':
        FhirOid.fromJson(value);
      case 'positiveint':
        FhirPositiveInt.fromJson(value);
      case 'time':
        FhirTime.fromJson(value);
      case 'unsignedint':
        FhirUnsignedInt.fromJson(value);
      case 'uuid':
        FhirUuid.fromJson(value);
      case 'http://hl7.org/fhirpath/system.string':
      case 'string':
        return value is String;
    }
    return true;
  } catch (e) {
    return false;
  }
}
