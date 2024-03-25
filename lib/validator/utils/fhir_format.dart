// Define the FhirFormat enum with lowercase identifiers
enum FhirFormat {
  xml,
  json,
  turtle,
  text,
  vbar,
  shc,
  shl,
  fml,
  none,
}

// Extension on FhirFormat to add methods
extension FhirFormatExtension on FhirFormat {
  // Method to get the file extension for each FhirFormat
  String get extension {
    switch (this) {
      case FhirFormat.json:
        return 'json';
      case FhirFormat.turtle:
        return 'ttl';
      case FhirFormat.xml:
        return 'xml';
      case FhirFormat.text:
        return 'txt';
      case FhirFormat.vbar:
        return 'hl7';
      case FhirFormat.shc:
        return 'shc';
      case FhirFormat.shl:
        return 'shl';
      case FhirFormat.fml:
        return 'fml';
      case FhirFormat.none:
        return '';
      default:
        return '';
    }
  }

  // Static method to parse a code string into a FhirFormat enum
  static FhirFormat? fromCode(String code) {
    switch (code) {
      case 'json':
        return FhirFormat.json;
      case 'ttl':
        return FhirFormat.turtle;
      case 'xml':
        return FhirFormat.xml;
      case 'txt':
        return FhirFormat.text;
      case 'hl7':
        return FhirFormat.vbar;
      case 'shc':
        return FhirFormat.shc;
      case 'shl':
        return FhirFormat.shl;
      case 'fml':
        return FhirFormat.fml;
      case 'none':
        return FhirFormat.none;
      case '':
        return FhirFormat.none;
      default:
        return null;
    }
  }

  // Static method to read a MIME type string and determine the FhirFormat
  static FhirFormat? fromMimeType(String? mt) {
    if (mt == null) return null;
    if (mt.contains('/xml') || mt.contains('+xml')) {
      return FhirFormat.xml;
    }
    if (mt.contains('/json') || mt.contains('+json')) {
      return FhirFormat.json;
    }
    return null;
  }
}
