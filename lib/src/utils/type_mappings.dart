// /// This function runs through the current Resource and creates a single-level
// /// map where everything is a String : primitive pair. The String in this case
// /// is the fhirPath to the object (including indexes) and the primitive is the
// /// actual value of that object.
// Map<String, dynamic> fhirPathsFromMap({
//   required dynamic value,
//   required String path,
// }) {
//   final returnMap = <String, dynamic>{};

//   if (value is Map) {
//     // Iterate over each key-value pair in the Map.
//     for (var key in value.keys) {
//       if (value[key] is Map) {
//         // If the value is a Map, recursively process it.
//         returnMap
//             .addAll(fhirPathsFromMap(value: value[key], path: '$path.$key'));
//       } else if (value[key] is List) {
//         // If the value is a List, process each element with its index.
//         for (var i = 0; i < value[key].length; i++) {
//           returnMap.addAll(
//               fhirPathsFromMap(value: value[key][i], path: '$path.$key[$i]'));
//         }
//       } else {
//         // Otherwise, add the key-value pair to the returnMap.
//         returnMap['$path.$key'] = value[key];
//       }
//     }
//   } else if (value is List) {
//     // If the value is a List, process each element with its index.
//     for (var i = 0; i < value.length; i++) {
//       returnMap.addAll(fhirPathsFromMap(value: value[i], path: '$path[$i]'));
//     }
//   } else {
//     // If the value is a primitive, add it directly to the returnMap.
//     returnMap[path] = value.toString();
//   }

//   return returnMap;
// }

// /// This function combines the startPath with the currentPath to generate a full path.
// /// It removes the first segment from the currentPath and appends the remaining
// /// segments to the startPath.
// String fullPathFromStartAndCurrent(String startPath, String currentPath) {
//   var pathList = currentPath.split('.');
//   pathList.removeAt(0);
//   pathList = [startPath, ...pathList];
//   return pathList.join('.');
// }

// /// This function checks if the provided path ends with an index in square brackets.
// /// If it does, it returns the index as an integer. Otherwise, it returns null.
// int? pathIndexIfAvailable(String path) {
//   // Check if the path ends with an index enclosed in square brackets.
//   final lastOpenBracket = path.lastIndexOf('[') + 1;
//   final lastClosedBracket = path.lastIndexOf(']');
//   if (lastOpenBracket == 0 ||
//       lastClosedBracket == -1 ||
//       lastClosedBracket != path.length - 1) {
//     return null;
//   } else {
//     return int.tryParse(path.substring(lastOpenBracket, lastClosedBracket));
//   }
// }
