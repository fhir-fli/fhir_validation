import 'dart:io';

import 'package:fhir_r4/fhir_r4.dart';

const path = 'test/test1';

Future<Resource> resource() async =>
    Resource.fromJsonString(await File('$path/resource.json').readAsString());

Future<Resource> supportResource1() async => Resource.fromJsonString(
    await File('$path/support_resource1.json').readAsString());

Future<Resource> supportResource2() async => Resource.fromJsonString(
    await File('$path/support_resource2.json').readAsString());

Future<Resource> supportResource3() async => Resource.fromJsonString(
    await File('$path/support_resource3.json').readAsString());

Future<Resource> supportResource4() async => Resource.fromJsonString(
    await File('$path/support_resource4.json').readAsString());

Future<Resource> response() async =>
    Resource.fromJsonString(await File('$path/response.json').readAsString());

Future<List<Resource>> supportResources() async => [
      await supportResource1(),
      await supportResource2(),
      await supportResource3(),
      await supportResource4(),
    ];
