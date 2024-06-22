import 'dart:io';
import 'dart:convert';
import 'package:fhir_r4/fhir_r4.dart';

Future<void> main() async {
  final Directory dir = Directory('assets');
  for (final FileSystemEntity file in dir.listSync()) {
    if (file.path.endsWith('.json')) {
      final Resource resource =
          Resource.fromJsonString(File(file.path).readAsStringSync());

      final String variableName =
          file.path.split('/').last.split('.').first.replaceAll('-', '');

      // Initial conversion to triple double quotes
      String newFile = "import 'package:fhir_r4/fhir_r4.dart';\n\n"
          "final ${resource.resourceType} $variableName = "
          "${resource.resourceType}.fromJson(${jsonPrettyPrint(resource.toJson())});";

      // First pass: Convert to triple double quotes
      final RegExp regExp1 =
          RegExp(r'"([^"]*)"\s*:\s*"(.*?)",*\n', dotAll: true);
      newFile = newFile.replaceAllMapped(regExp1, (Match match) {
        final String? key = match.group(1);
        final String? value = match.group(2);
        return '"$key" : """$value""",\n';
      });

      // Second pass: Convert values with $ to raw triple single quotes
      final RegExp regExp2 =
          RegExp(r'"([^"]*)"\s*:\s*"""([^"]*\$[^"]*)""",*\n', dotAll: true);
      newFile = newFile.replaceAllMapped(regExp2, (Match match) {
        final String? key = match.group(1);
        final String? value = match.group(2);
        return '"$key" : r\'\'\'$value\'\'\',\n';
      });

      // Third pass: Handle complex escape sequences and nested quotes
      final RegExp regExp3 =
          RegExp(r'"([^"]*)"\s*:\s*"""((?:[^"]|\\")*)""",*\n', dotAll: true);
      newFile = newFile.replaceAllMapped(regExp3, (Match match) {
        final String? key = match.group(1);
        final String? value = match.group(2);
        // Convert the value to a raw string if it contains backslashes or special characters
        if (value!.contains(r'\') || value.contains(r'$')) {
          return '"$key" : r\'\'\'$value\'\'\',\n';
        } else {
          return '"$key" : """$value""",\n';
        }
      });

      await File(file.path
              .replaceAll('.json', '.dart')
              .replaceAll('assets', 'lib'))
          .writeAsString(newFile);
    }
  }
  print('done');
}

const JsonEncoder jsonEncoder = JsonEncoder.withIndent('    ');

String jsonPrettyPrint(Map<String, dynamic> map) => jsonEncoder.convert(map);
