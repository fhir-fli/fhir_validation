/// This function runs through the current Resource and creates a single level
/// map where everything is a String : primitive pair. The String in this case
/// is the fhirPath to the object (including indexes) and the primitive is the
/// actual value of that object
Map<String, dynamic> fhirPathsFromMap({
  required dynamic value,
  required String path,
}) {
  final returnMap = <String, dynamic>{};
  if (value is Map) {
    for (var key in value.keys) {
      if (value[key] is Map) {
        returnMap
            .addAll(fhirPathsFromMap(value: value[key], path: '$path.$key'));
      } else if (value[key] is List) {
        for (var i = 0; i < value[key].length; i++) {
          returnMap.addAll(
              fhirPathsFromMap(value: value[key][i], path: '$path.$key[$i]'));
        }
      } else {
        returnMap.addAll({'$path.$key': value[key]});
      }
    }
  } else if (value is List) {
    for (var i = 0; i < value.length; i++) {
      returnMap.addAll(fhirPathsFromMap(value: value[i], path: '$path[$i]'));
    }
  } else {
    returnMap.addAll({path: value.toString()});
  }
  return returnMap;
}
