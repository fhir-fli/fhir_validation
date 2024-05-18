import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart';

import 'resource_cache.dart';
import 'code_system_maps/code_system_maps.dart';
import 'naming_system_maps/naming_system_maps.dart';
import 'structure_definition_maps/structure_definition_maps.dart';
import 'value_set_maps/value_set_maps.dart';

// Singleton cache instance
final ResourceCache resourceCache = ResourceCache();

/// Retrieves a ValueSet from the given URL. Checks online first and if not
/// found, then checks locally.
Future<Map<String, dynamic>?> getValueSet(String url, Client? client) async {
  return await _getResource(url, 'ValueSet', valueSetMaps, client);
}

/// Retrieves a CodeSystem from the given URL. Checks online first and if not
/// found, then checks locally.
Future<Map<String, dynamic>?> getCodeSystem(String url, Client? client) async {
  return await _getResource(url, 'CodeSystem', codeSystemMaps, client);
}

/// Retrieves a StructureDefinition from the given URL. Checks online first
/// and if not found, then checks locally.
Future<Map<String, dynamic>?> getStructureDefinition(
    String url, Client? client) async {
  return await _getResource(
      url, 'StructureDefinition', structureDefinitionMaps, client);
}

/// Retrieves a NamingSystem from the given URL. Checks online first and if
/// not found, then checks locally.
Future<Map<String, dynamic>?> getNamingSystem(
    String url, Client? client) async {
  return await _getResource(url, 'NamingSystem', namingSystemMaps, client);
}

Future<Map<String, dynamic>?> getProfile(String url, Client? client) async {
  return await _getResource(
      url, 'StructureDefinition', structureDefinitionMaps, client);
}

Future<Map<String, dynamic>?> getAnyResource(String url, Client? client) async {
  return await _getResource(url, '', structureDefinitionMaps, client);
}

/// Utility method to retrieve a resource from the given URL, checking online
/// first and then locally if not found.
Future<Map<String, dynamic>?> _getResource(
  String url,
  String resourceType,
  Map<String, Map<String, dynamic>> localMap,
  Client? client,
) async {
  // Check cache first
  final cachedResource = resourceCache.get(url);
  if (cachedResource != null) {
    return cachedResource;
  }

  final result = localMap[url];
  if (result != null) {
    resourceCache.set(url, result);
    if (result['url'] != null) {
      resourceCache.set(result['url'], result);
    }
    return result;
  } else {
    final Map<String, dynamic>? result =
        await _requestFromCanonical(url, client);
    if (result != null &&
        (resourceType == '' || result['resourceType'] == resourceType)) {
      resourceCache.set(url, result);
      if (result['url'] != null) {
        resourceCache.set(result['url'], result);
      }
      return result;
    }
  }
  // Normalize URL
  final normalizedUrl = url.contains('|') ? url.split('|')[0] : url;
  if (normalizedUrl != url) {
    _getResource(normalizedUrl, resourceType, localMap, client);
  }
  return null;
}

/// Function to request a resource from a canonical URL.
Future<Map<String, dynamic>?> _requestFromCanonical(
    String canonical, Client? client) async {
  try {
    final response = await (client?.get(Uri.parse(canonical),
            headers: {'Accept': 'application/fhir+json'}) ??
        get(Uri.parse(canonical),
            headers: {'Accept': 'application/fhir+json'}));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      resourceCache.set(canonical, result);
      return result;
    }
  } catch (e) {
    log('Error requesting from canonical: $canonical, error: $e');
    // Handle exception or logging.
  }
  return null;
}
