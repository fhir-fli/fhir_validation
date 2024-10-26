import 'package:fhir_r4/fhir_r4.dart';

/// List of the Strings for the primitive types
bool isPrimitiveType(String type) => <String>[
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
    ].contains(type.toLowerCase());

/// Tells if the primitive in question is comparable
bool isComparablePrimitive(String type) => <String>[
      'date',
      'decimal',
      'datetime',
      'instant',
      'integer',
      'integer64',
      'positiveint',
      'time',
      'unsignedint',
    ].contains(type.toLowerCase());

/// Converts a FHIR primitive into an appropriate Dart primitive
String fhirPrimitiveToDartPrimitive(String primitiveClass) {
  switch (primitiveClass.toLowerCase()) {
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

/// Assesses if a value is a valid Primitive of the type specificed
bool isValueAValidPrimitive(String primitiveClass, dynamic value) {
  try {
    switch (primitiveClass.toLowerCase()) {
      case 'base64binary':
        if (value is! String) {
          return false;
        } else {
          FhirBase64Binary(value);
        }
      case 'boolean':
        if (value is! bool) {
          return false;
        } else {
          FhirBoolean(value);
        }
      case 'canonical':
        if (value is! String) {
          return false;
        } else {
          FhirCanonical(value);
        }
      case 'code':
        if (value is! String) {
          return false;
        } else {
          FhirCode(value);
        }
      case 'date':
        if (value is String) {
          FhirDate.fromString(value);
        } else {
          return false;
        }
      case 'decimal':
        if (value is! num) {
          return false;
        } else {
          FhirDecimal(value);
        }
      case 'datetime':
        if (value is String) {
          FhirDateTime.fromString(value);
        } else {
          return false;
        }
      case 'uri':
        if (value is! String) {
          return false;
        } else {
          FhirUri(value);
        }
      case 'url':
        if (value is! String) {
          return false;
        } else {
          FhirUrl(value);
        }
      case 'id':
        if (value is! String) {
          return false;
        } else {
          FhirId(value);
        }
      case 'instant':
        if (value is String) {
          FhirInstant.fromString(value);
        } else {
          return false;
        }
      case 'integer':
        if (value is! int) {
          return false;
        } else {
          FhirInteger(value);
        }
      case 'integer64':
        if (value is! String && value is! BigInt) {
          return false;
        } else if (value is BigInt) {
          FhirInteger64(value);
        } else {
          final bigInt = BigInt.tryParse(value as String);
          if (bigInt == null) {
            return false;
          } else {
            FhirInteger64(bigInt);
          }
        }
      case 'markdown':
        if (value is! String) {
          return false;
        } else {
          FhirMarkdown(value);
        }
      case 'xhtml':
        if (value is! String) {
          return false;
        } else {
          FhirMarkdown(value);
        }
      case 'oid':
        if (value is! String) {
          return false;
        } else {
          FhirOid(value);
        }
      case 'positiveint':
        if (value is! int) {
          return false;
        } else {
          FhirPositiveInt(value);
        }
      case 'time':
        if (value is! String) {
          return false;
        } else {
          FhirTime(value);
        }
      case 'unsignedint':
        if (value is! int) {
          return false;
        } else {
          FhirUnsignedInt(value);
        }
      case 'uuid':
        if (value is! String) {
          return false;
        } else {
          FhirUuid(value);
        }
      case 'http://hl7.org/fhirpath/system.string':
      case 'string':
        return value is String;
    }
    return true;
  } catch (e) {
    return false;
  }
}
