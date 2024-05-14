import 'fhir_validation.dart';

Map<String, dynamic> addToMap(
  Map<String, dynamic> map,
  String startPath,
  String currentPath,
  String newItem,
  Severity severity,
) {
  final path = fullPathFromStartAndCurrent(startPath, currentPath);
  if (map.containsKey(path)) {
    if (map[path][severity] != null) {
      map[path][severity]!.add(newItem);
    } else {
      map[path][severity] = [newItem];
    }
  } else {
    map[path] = {
      'errors': [],
      'warnings': [],
      'information': [],
    };
    map[path][severity] = [newItem];
  }
  return map;
}

enum Severity {
  error,
  warning,
  information,
}
