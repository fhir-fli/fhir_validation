import 'dart:io';
import 'dart:typed_data';

import 'validation.dart';

class ValidatorUtils {
  // Assuming ByteProvider can be represented with Uint8List in Dart
  static void grabNatives(Map<String, Uint8List> source,
      Map<String, Uint8List> binaries, String prefix) {
    source.forEach((key, value) {
      if (key.endsWith('.zip')) {
        binaries['$prefix#$key'] = value;
      }
    });
  }

  static dynamic loaderForVersion(String version, [dynamic loader]) {
    // Assuming `loader` is an optional parameter that defaults to null
    // This method's implementation will vary significantly based on how you've implemented or wrapped FHIR loaders in Dart
    // The following is a placeholder implementation
    if (version.isEmpty) return null;

    switch (version) {
      case 'R2':
        return 'R2ToR5Loader'; // Placeholder return value
      case 'R3':
        return 'R3ToR5Loader'; // Placeholder return value
      // Add other cases as necessary
      default:
        return null;
    }
  }

  static List<dynamic> filterMessages(List<dynamic> messages) {
    // Assuming ValidationMessage is a class you've adapted in Dart
    // This implementation assumes you can convert it directly
    var filteredValidation = <dynamic>[];
    for (var message in messages) {
      if (!filteredValidation.contains(message))
        filteredValidation.add(message);
    }
    filteredValidation
        .sort((a, b) => 0); // Placeholder for actual sorting logic
    return filteredValidation;
  }

  // Assuming OperationOutcome, SimpleWorkerContext, and FHIRPathEngine have Dart equivalents or placeholders
  static dynamic messagesToOutcome(
      List<dynamic> messages, dynamic context, dynamic fpe) {
    // Placeholder for actual implementation
    var op = 'OperationOutcome'; // Placeholder
    // Implementation depends on how you've adapted these classes and methods in Dart
    return op;
  }

  static bool extractReferences(
      String name, List<SourceFile> refs, dynamic context) {
    // This needs to be adapted based on your file handling and context usage in Dart
    // Placeholder logic
    var file = File(name);
    if (!file.existsSync()) {
      print('File does not exist: $name');
      return false;
    }

    if (file.statSync().type == FileSystemEntityType.file) {
      refs.add(
          SourceFile(ref: name, date: file.lastModifiedSync(), process: true));
    } else {
      // Directory handling or additional logic here
    }
    return refs.length > 1;
  }
}
