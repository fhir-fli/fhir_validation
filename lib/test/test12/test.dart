import 'package:fhir_r4/fhir_r4.dart';

import 'package:flutter/services.dart' show rootBundle;

/// Path to the test resources
const String path = 'lib/test/test2';

/// Get the data from the file
Future<String> getFileData(String path) async {
  return rootBundle.loadString(path);
}

/// Get the data from the file
Future<Resource> resource() async =>
    Resource.fromJsonString(await getFileData('$path/resource.json'));
// Resource.fromJsonString(await File('$path/resource.json').readAsString());

/// Get the data from the file
Future<Resource> supportResource1() async =>
    Resource.fromJsonString(await getFileData('$path/support_resource1.json'));
// Resource.fromJsonString(
//     await File('$path/support_resource1.json').readAsString());

/// Get the data from the file
Future<Resource> supportResource2() async =>
    Resource.fromJsonString(await getFileData('$path/support_resource2.json'));
// Resource.fromJsonString(
// await File('$path/support_resource2.json').readAsString());

/// Get the data from the file
Future<Resource> response() async =>
    Resource.fromJsonString(await getFileData('$path/response.json'));
// Resource.fromJsonString(await File('$path/response.json').readAsString());

/// Get the data from the file
Future<List<Resource>> supportResources() async => <Resource>[
      await supportResource1(),
      await supportResource2(),
    ];
