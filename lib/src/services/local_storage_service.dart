import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  Future<void> cacheResourceLocally(
      String canonical, Map<String, dynamic> resource) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/fhir_cache.json';
    final file = File(filePath);

    Map<String, dynamic> cache = {};
    if (await file.exists()) {
      final contents = await file.readAsString();
      cache = jsonDecode(contents);
    }
    cache[canonical] = resource;
    await file.writeAsString(jsonEncode(cache));
  }

  Future<Map<String, dynamic>> loadCachedResources() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/fhir_cache.json';
    final file = File(filePath);

    if (await file.exists()) {
      final contents = await file.readAsString();
      return jsonDecode(contents);
    }
    return {};
  }
}
