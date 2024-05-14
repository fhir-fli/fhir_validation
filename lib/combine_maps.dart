Map<String, dynamic> combineMaps(
    Map<String, dynamic> map1, Map<String, dynamic> map2) {
  for (var key in map2.keys) {
    if (map1.keys.contains(key) && map1[key] != null && map1[key]!.isNotEmpty) {
      map1[key]!.addAll(map2[key] ?? []);
    } else {
      map1[key] = map2[key];
    }
  }
  return map1;
}
