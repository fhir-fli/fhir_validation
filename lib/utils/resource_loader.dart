import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';

import 'resource_cache.dart';

// Singleton cache instance
final ResourceCache resourceCache = ResourceCache();

/// Utility method to retrieve a resource from the given URL, checking online
/// first and then locally if not found.
Future<Map<String, dynamic>?> getResource(
  String url,
  Client? client,
) async {
  // Check cache first
  final Map<String, dynamic>? cachedResource = resourceCache.get(url) ??
      resourceCache.get('http://hl7.org/fhir/StructureDefinition/$url');
  if (cachedResource != null) {
    return cachedResource;
  } else {
    final Map<String, dynamic>? result =
        await _requestFromCanonical(url, client);
    if (result != null) {
      resourceCache.set(url, result);
      if (result['url'] != null) {
        resourceCache.set(result['url'] as String, result);
      }
      return result;
    }
  }
  // Normalize URL
  final String normalizedUrl = url.contains('|') ? url.split('|')[0] : url;
  if (normalizedUrl != url) {
    getResource(normalizedUrl, client);
  }
  return null;
}

/// Function to request a resource from a canonical URL.
Future<Map<String, dynamic>?> _requestFromCanonical(
    String canonical, Client? client) async {
  try {
    final Response response = await (client?.get(Uri.parse(canonical),
            headers: <String, String>{'Accept': 'application/fhir+json'}) ??
        get(Uri.parse(canonical),
            headers: <String, String>{'Accept': 'application/fhir+json'}));
    if (response.statusCode == 200) {
      final Map<String, dynamic> result =
          jsonDecode(response.body) as Map<String, dynamic>;
      resourceCache.set(canonical, result);
      return result;
    }
  } catch (e) {
    log('Error requesting from canonical: $canonical, error: $e');
    // Handle exception or logging.
  }
  return null;
}
