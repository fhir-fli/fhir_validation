import 'dart:convert';
import 'dart:io';

import 'package:fhir_r4/fhir_r4.dart';

Future<void> main() async {
  final dir = Directory('naming_systems');
  final Map<String, String> uniqueOids = {};
  final Map<String, String> uniqueUris = {};

  String mapFile = "import 'naming_systems/naming_systems.dart';\n\n"
      "const namingSystemMaps = <String, Map<String, dynamic>>{\n";
  String exportFile = '';

  for (final file in dir.listSync()) {
    if (file is File && file.path.endsWith('.json')) {
      final fileString = file.readAsStringSync();
      final namingSystem = NamingSystem.fromJsonString(fileString);
      final name = 'namingSystem${namingSystem.id ?? ''}'
          .replaceAll('.', '_')
          .replaceAll('-', '_');
      final contents = 'const $name = ${jsonEncode(namingSystem.toJson())};';
      final fileName = 'naming_systems/$name.dart';
      await File(fileName).writeAsString(contents);
      exportFile +=
          'export \'${fileName.replaceAll("naming_systems/", "")}\';\n';

      // Processing unique IDs for OIDs
      for (final uniqueId in namingSystem.uniqueId) {
        final value = uniqueId.value ?? '';
        final type = uniqueId.type?.value?.toLowerCase();
        if (type == 'oid' && !uniqueOids.containsKey(value)) {
          uniqueOids[value] = name;
        } else if (type == 'uri' && !uniqueUris.containsKey(value)) {
          uniqueUris[value] = name;
        }
      }
    }
  }

  // Adding unique OIDs and URIs to the mapFile
  uniqueOids.forEach((key, value) {
    mapFile += '  "$key": $value,\n';
  });
  uniqueUris.forEach((key, value) {
    mapFile += '  "$key": $value,\n';
  });

  mapFile += '};\n';
  await File('naming_system_maps.dart').writeAsString(mapFile);
  await File('naming_systems/naming_systems.dart').writeAsString(exportFile);
}
