import 'fhir_validation.dart';

Map<String, dynamic> addToMap(
  Map<String, dynamic> map,
  String startPath,
  String currentPath,
  String newItem,
  Severity severity,
) {
  final String path = fullPathFromStartAndCurrent(startPath, currentPath);
  if (map.containsKey(path)) {
    if (map[path][severity] != null) {
      map[path][severity]!.add(newItem);
    } else {
      map[path][severity] = [newItem];
    }
  } else {
    map[path] = {
      Severity.error: [],
      Severity.warning: [],
      Severity.information: [],
    };
    map[path][severity] = [newItem];
  }
  return map;
}

enum Severity {
  error,
  warning,
  information;

  @override
  String toString() {
    switch (this) {
      case Severity.error:
        return 'error';
      case Severity.warning:
        return 'warning';
      case Severity.information:
        return 'information';
    }
  }

  static Severity fromString(String severity) {
    switch (severity) {
      case 'error':
        return Severity.error;
      case 'warning':
        return Severity.warning;
      case 'information':
        return Severity.information;
      default:
        throw ArgumentError('Invalid severity: $severity');
    }
  }

  static Severity fromJson(dynamic json) {
    if (json is String) {
      return fromString(json);
    } else {
      throw ArgumentError('Invalid severity: $json');
    }
  }

  static String toJson(Severity severity) {
    return severity.toString();
  }
}

Map<String, dynamic> organizeValidationOutput(
    Map<String, dynamic> validationOutput) {
  final List<Map<String, String>> errors = [];
  final List<Map<String, String>> warnings = [];
  final List<Map<String, String>> information = [];
  for (var key in validationOutput.keys) {
    for (var severity in validationOutput[key].keys) {
      for (var message in validationOutput[key][severity]) {
        switch (severity) {
          case Severity.error:
            errors.add({key: message});
            break;
          case Severity.warning:
            warnings.add({key: message});
            break;
          case Severity.information:
            information.add({key: message});
            break;
          default:
            throw ArgumentError('Invalid severity: $severity');
        }
      }
    }
  }

  return {
    'Validation Errors': errors.isEmpty ? 'none were found' : errors,
    'Validation Warnings': warnings.isEmpty ? 'none were found' : warnings,
    'Validation Information':
        information.isEmpty ? 'none were found' : information,
  };
}
