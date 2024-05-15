import 'dart:io';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_validation/fhir_validation.dart';

Future<void> main() async {
  final Directory dir = Directory('test/resources');
  for (final file in dir.listSync()) {
    if (file is File) {
      final String path = file.path;
      if (path.endsWith('.json')) {
        final resource =
            Resource.fromJsonString(await File(path).readAsString());
        final result =
            await validateFhir(resourceToValidate: resource.toJson());
        print(jsonPrettyPrint(result.organizeValidationOutput()));
      }
    }
  }
}
