import 'package:collection/collection.dart';
import 'package:fhir_node/fhir_node.dart';
import 'package:fhir_path/fhir_path.dart';

/// Determines the appropriate FHIR type code for an element.
/// For polymorphic elements (ending in `[x]`), the code is derived
/// from the specific type indicated in the path.
String? findCode(ElementNode element, String path) {
  final types = element.types;
  if (types.length == 1) {
    // Return the single type code if the element is not polymorphic
    return types.first.code;
  } else if (types.length > 1) {
    // Handle polymorphic types
    final elementPath = element.path;
    if (elementPath.endsWith('[x]')) {
      final type =
          path
              .split('.')
              .last
              .replaceAll(elementPath.split('.').last.replaceAll('[x]', ''), '')
              .toLowerCase();
      return types.firstWhereOrNull((t) => t.code.toLowerCase() == type)?.code;
    }
  }
  return null;
}

/// Cleans and standardizes paths by replacing the `originalPath`
/// with `replacePath` and removing array indices (e.g., `[0]`).
String cleanLocalPath(
  String originalPath,
  String replacePath,
  String childPath,
) {
  return _stripIndexes(childPath.replaceAll(originalPath, replacePath));
}

/// Removes array indices (e.g., `[0]`) from the provided path.
String _stripIndexes(String path) {
  final regex = RegExp(r'\[\d+\]');
  return path.replaceAll(regex, '');
}

/// Extracts all ElementDefinition entries from a StructureDefinition,
/// merging elements from both the `snapshot` and `differential` components,
/// keyed by path.
Map<String, ElementNode> extractElements(FhirNode structureDefinition) {
  final map = <String, ElementNode>{};
  for (final part in ['snapshot', 'differential']) {
    final elements =
        structureDefinition
            .getChildByName(part)
            ?.getChildrenByName('element') ??
        const <FhirNode>[];
    for (final element in elements) {
      final node = ElementNode(element);
      map[node.path] = node;
    }
  }
  return map;
}

/// The fully qualified URL of a StructureDefinition, with its version
/// appended (`url|version`) when it has one.
String? structureDefinitionUrl(FhirNode structureDefinition) {
  final url = structureDefinition.getChildByName('url')?.primitiveValue;
  if (url == null) return null;
  final version = structureDefinition.getChildByName('version')?.primitiveValue;
  return version == null ? url : '$url|$version';
}

/// Fetches and extracts all codes from a ValueSet or CodeSystem URL.
/// Handles recursive includes for ValueSets and hierarchical concepts
/// within CodeSystems.
Future<Set<String>> getValueSetCodes(
  String valueSetUrl,
  ResourceCache resourceCache,
) async {
  final resource = await resourceCache.getCanonicalResource(valueSetUrl);
  if (resource == null) {
    throw Exception('Resource not found at $valueSetUrl');
  }

  final codes = <String>{};

  if (resource.fhirType == 'ValueSet') {
    // Extract codes from ValueSet.compose.include
    for (final include in _includes(resource)) {
      // Process external ValueSets and CodeSystems
      for (final includedValueSet in include.getChildrenByName('valueSet')) {
        final url = includedValueSet.primitiveValue;
        if (url != null) {
          codes.addAll(await _fetchIncludedValueSetCodes(url, resourceCache));
        }
      }
      final system = include.getChildByName('system')?.primitiveValue;
      if (system != null) {
        codes.addAll(await _fetchIncludedValueSetCodes(system, resourceCache));
      }

      // Process directly defined concepts
      codes.addAll(_conceptCodes(include));
    }

    // Extract codes from ValueSet.expansion.contains
    codes.addAll(_expansionCodes(resource));
  } else if (resource.fhirType == 'CodeSystem') {
    // Extract codes and sub-concepts recursively
    for (final concept in resource.getChildrenByName('concept')) {
      codes.addAll(_extractCodesFromConcept(concept));
    }
  } else {
    throw Exception('Unexpected resource type: ${resource.fhirType}');
  }

  return codes;
}

/// Recursively fetches and extracts codes from an included ValueSet or
/// CodeSystem.
Future<Set<String>> _fetchIncludedValueSetCodes(
  String includedValueSetUrl,
  ResourceCache resourceCache,
) async {
  final resource = await resourceCache.getCanonicalResource(
    includedValueSetUrl,
  );
  if (resource == null) {
    return <String>{};
  }

  final includedCodes = <String>{};

  if (resource.fhirType == 'ValueSet') {
    // Process compose.include concepts
    for (final include in _includes(resource)) {
      includedCodes.addAll(_conceptCodes(include));
    }
    // Process expansion.contains concepts
    includedCodes.addAll(_expansionCodes(resource));
  } else if (resource.fhirType == 'CodeSystem') {
    for (final concept in resource.getChildrenByName('concept')) {
      includedCodes.addAll(_extractCodesFromConcept(concept));
    }
  }

  return includedCodes;
}

List<FhirNode> _includes(FhirNode valueSet) =>
    valueSet.getChildByName('compose')?.getChildrenByName('include') ??
    const <FhirNode>[];

/// The `code` of each `concept` directly under [include].
Iterable<String> _conceptCodes(FhirNode include) => [
  for (final concept in include.getChildrenByName('concept'))
    if (concept.getChildByName('code')?.primitiveValue case final String c) c,
];

/// The `code` of each `expansion.contains` of [valueSet].
Iterable<String> _expansionCodes(FhirNode valueSet) => [
  for (final contains
      in valueSet.getChildByName('expansion')?.getChildrenByName('contains') ??
          const <FhirNode>[])
    if (contains.getChildByName('code')?.primitiveValue case final String c) c,
];

/// Recursively extracts codes from a hierarchical CodeSystem concept.
Set<String> _extractCodesFromConcept(FhirNode concept) {
  final codes = <String>{};
  final code = concept.getChildByName('code')?.primitiveValue;
  if (code != null) codes.add(code);
  for (final subConcept in concept.getChildrenByName('concept')) {
    codes.addAll(_extractCodesFromConcept(subConcept));
  }
  return codes;
}

/// Appends the URL to a message if the URL is provided.
String withUrlIfExists(String string, String? url) {
  return url != null ? '$string (from $url)' : string;
}
