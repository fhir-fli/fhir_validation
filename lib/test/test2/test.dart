import 'package:fhir_r4/fhir_r4.dart';

import 'package:flutter/services.dart' show rootBundle;

const String path = 'lib/test/test2';

Future<String> getFileData(String path) async {
  return rootBundle.loadString(path);
}

Future<Resource> resource() async =>
    Resource.fromJsonString(await getFileData('$path/resource.json'));
// Resource.fromJsonString(await File('$path/resource.json').readAsString());

Future<Resource> supportResource1() async =>
    Resource.fromJsonString(await getFileData('$path/support_resource1.json'));
// Resource.fromJsonString(
//     await File('$path/support_resource1.json').readAsString());

Future<Resource> supportResource2() async =>
    Resource.fromJsonString(await getFileData('$path/support_resource2.json'));
// Resource.fromJsonString(
// await File('$path/support_resource2.json').readAsString());

Future<Resource> response() async =>
    Resource.fromJsonString(await getFileData('$path/response.json'));
// Resource.fromJsonString(await File('$path/response.json').readAsString());

Future<List<Resource>> supportResources() async => <Resource>[
      await supportResource1(),
      await supportResource2(),
    ];
