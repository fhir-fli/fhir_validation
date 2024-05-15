class ResourceCache {
  // Static variable that holds the single instance of ResourceCache
  static final ResourceCache _instance = ResourceCache._internal();

  // A map to store cached resources
  final Map<String, Map<String, dynamic>> _cache = {};

  // Factory constructor that returns the existing instance
  factory ResourceCache() {
    return _instance;
  }

  // Private constructor to prevent external instantiation
  ResourceCache._internal();

  // Method to retrieve a resource from the cache
  Map<String, dynamic>? get(String url) {
    return _cache[url];
  }

  // Method to add a resource to the cache
  void set(String url, Map<String, dynamic> resource) {
    _cache[url] = resource;
  }
}
