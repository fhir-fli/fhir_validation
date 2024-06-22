import 'package:fhir_r4/fhir_r4.dart';

import '../resources/resources.dart';

class ResourceCache {
  // Static variable that holds the single instance of ResourceCache
  static final ResourceCache _instance = ResourceCache._internal();

  // A map to store cached resources
  final Map<String, Map<String, dynamic>> _cache =
      <String, Map<String, dynamic>>{};

  // Factory constructor that returns the existing instance
  factory ResourceCache() {
    return _instance;
  }

  bool containsKey(String key) {
    return _cache.containsKey(key);
  }

  // Private constructor to prevent external instantiation
  ResourceCache._internal() {
    _initializeCache(); // Initialize the cache when the instance is created
  }

  // Method to retrieve a resource from the cache
  Map<String, dynamic>? get(String url) {
    return _cache[url];
  }

  // Method to add a resource to the cache
  void set(String url, Map<String, dynamic> resource) {
    _cache[url] = resource;
  }

  // Private method to initialize the cache with data
  void _initializeCache() {
    // Your logic to pull in data and populate the cache
    // For example:
    // _cache['example'] = {'key': 'value'};

    // If this operation is asynchronous, you can use the following approach:
    _loadInitialData();
  }

  // If the initialization involves asynchronous operations
  void _loadInitialData() {
    getResources().forEach((Resource element) {
      if (element.toJson()['url'] != null) {
        _cache[element.toJson()['url'] as String] = element.toJson();
      }
    });
  }
}
