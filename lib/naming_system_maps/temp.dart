import 'dart:convert';
import 'dart:io';

import 'package:fhir_r4/fhir_r4.dart';

Future<void> main() async {
  final dir = Directory('naming_systems');
  String mapFile = "import 'naming_systems/naming_systems.dart';\n\n"
      "const namingSystemMaps = <String, Map<String, dynamic>>{\n";
  String exportFile = '';
  for (final file in dir.listSync()) {
    if (file is File && file.path.endsWith('.json')) {
      final fileString = file.readAsStringSync();
      final namingSystem = NamingSystem.fromJsonString(fileString);
      final name = 'namingSystem${namingSystem.id ?? ''}'.replaceAll('.', '_');
      final contents = 'const $name = ${jsonEncode(namingSystem.toJson())};';
      final fileName = 'naming_systems/$name.dart';
      await File(fileName).writeAsString(contents);
      exportFile +=
          'export \'${fileName.replaceAll("naming_systems/", "")}\';\n';
      final oidIndex = namingSystem.uniqueId
          .indexWhere((e) => e.type?.value?.toLowerCase() == 'oid');
      final oid = oidIndex != -1 ? namingSystem.uniqueId[oidIndex].value : null;
      if (oid != null) {
        mapFile += '  "$oid": $name,\n';
      }
      final uriIndex = namingSystem.uniqueId
          .indexWhere((e) => e.type?.value?.toLowerCase() == 'uri');
      final uri = uriIndex != -1 ? namingSystem.uniqueId[uriIndex].value : null;
      if (uri != null) {
        mapFile += '  "$uri": $name,\n';
      }
    }
  }
  mapFile += '};\n';
  await File('naming_system_maps.dart').writeAsString(mapFile);
  await File('naming_systems/naming_systems.dart').writeAsString(exportFile);
}
