import 'dart:convert';
import 'dart:typed_data';

import 'validation.dart';

class ResourceChecker {
  static FhirFormat checkIsResource(
      Uint8List cnt, String filename, bool guessFromExtension) {
    print("   ..Detect format for $filename");
    if (cnt.isEmpty) {
      print("Loader: $filename is empty");
      return FhirFormat.none;
    }

    if (guessFromExtension) {
      String ext = filename.split('.').last.toLowerCase();
      switch (ext) {
        case 'xml':
          return FhirFormat.xml;
        case 'ttl':
          return FhirFormat.turtle;
        case 'map':
        case 'fml':
          return FhirFormat.fml;
        case 'jwt':
        case 'jws':
          return FhirFormat.shc;
        case 'json':
          // Additional JSON content checking can be implemented here
          return FhirFormat.json;
        case 'txt':
          // Additional TXT content checking can be implemented here
          return FhirFormat.text;
        default:
          break;
      }
    }

    // Attempt to parse the content based on different formats
    try {
      // Example of parsing JSON, similar logic can be applied for other formats
      json.decode(utf8.decode(cnt));
      return FhirFormat.json;
    } catch (e) {
      print("Not JSON: $e");
    }

    // Additional parsing attempts for XML, Turtle, SHC, etc., go here

    print("     .. not a resource: $filename");
    return FhirFormat.none;
  }
}
