Map<String, List<String>?> combineMaps(
    Map<String, List<String>?> map1, Map<String, List<String>?> map2) {
  for (var key in map2.keys) {
    if (map1.keys.contains(key) && map1[key] != null && map1[key]!.isNotEmpty) {
      map1[key]!.addAll(map2[key] ?? []);
    } else {
      map1[key] = map2[key];
    }
  }
  return map1;
}
