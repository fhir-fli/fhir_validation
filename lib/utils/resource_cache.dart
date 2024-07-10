import 'package:fhir_r4/fhir_r4.dart';
import '../resources/resources.dart';

class ResourceCache {
  static final ResourceCache _instance = ResourceCache._internal();
  final Map<String, Map<String, dynamic>> _cache =
      <String, Map<String, dynamic>>{};

  factory ResourceCache() {
    return _instance;
  }

  bool containsKey(String key) {
    return _cache.containsKey(key);
  }

  ResourceCache._internal() {
    _initializeCache();
  }

  Map<String, dynamic>? get(String url) {
    return _cache[url] ??
        (!url.contains('http')
            ? _cache['http://hl7.org/fhir/StructureDefinition/$url']
            : null);
  }

  void set(String url, Map<String, dynamic> resource) {
    _cache[url] = resource;
  }

  void _initializeCache() {
    _loadInitialData();
  }

  void _loadInitialData() {
    getResources().forEach((Resource element) {
      if (element.toJson()['url'] != null) {
        _cache[element.toJson()['url'] as String] = element.toJson();
      }
    });
  }

  List<String> listKeys() {
    return _cache.keys.toList();
  }
}
