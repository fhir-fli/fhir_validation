String fhirPrimitiveToDartPrimitive(String primitiveClass) {
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
    case 'dateTime':
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
    case 'positiveInt':
      return 'int';
    case 'time':
      return 'string';
    case 'unsignedInt':
      return 'int';
    case 'uuid':
      return 'string';
    case 'string':
      return 'string';
    default:
      return 'not defined';
  }
}
