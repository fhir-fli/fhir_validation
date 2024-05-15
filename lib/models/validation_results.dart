class ValidationResults {
  final Map<Severity, List<ValidationNotification>> results = {
    Severity.error: [],
    Severity.warning: [],
    Severity.information: [],
  };

  void addResult(
      String startPath, String currentPath, String newItem, Severity severity) {
    final String path = fullPathFromStartAndCurrent(startPath, currentPath);
    results[severity]!.add(ValidationNotification(path, newItem));
  }

  void combineResults(ValidationResults other) {
    for (var severity in results.keys) {
      results[severity]!.addAll(other.results[severity]!);
    }
  }

  String fullPathFromStartAndCurrent(String startPath, String currentPath) {
    var pathList = currentPath.split('.');
    pathList.removeAt(0);
    pathList = [startPath, ...pathList];
    final path = pathList.join('.');
    return path;
  }

  Map<String, dynamic> toJson() {
    return results.map((severity, notifications) => MapEntry(
        severity.toString(), notifications.map((e) => e.toJson()).toList()));
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> organizeValidationOutput() {
    return {
      'Validation Errors': results[Severity.error]!.isEmpty
          ? 'none were found'
          : results[Severity.error]!,
      'Validation Warnings': results[Severity.warning]!.isEmpty
          ? 'none were found'
          : results[Severity.warning]!,
      'Validation Information': results[Severity.information]!.isEmpty
          ? 'none were found'
          : results[Severity.information]!,
    };
  }
}

class ValidationNotification {
  final String path;
  final String notification;

  ValidationNotification(this.path, this.notification);

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'notification': notification,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
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
