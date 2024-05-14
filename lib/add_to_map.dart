import 'fhir_validation.dart';

Map<String, List<String>?> addToMap(
  Map<String, List<String>?> map,
  String startPath,
  String currentPath,
  String newItem,
) {
  final path = fullPathFromStartAndCurrent(startPath, currentPath);
  if (map.keys.contains(path) && map[path] != null && map[path]!.isNotEmpty) {
    map[path]!.add(newItem);
  } else {
    map[path] = [newItem];
  }
  return map;
}
