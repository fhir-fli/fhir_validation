import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import '../fhir_validation.dart';

String? findCode(ElementDefinition element, String path) {
  if (element.type?.length == 1) {
    return element.type?.first.code?.toString();
  } else if ((element.type?.length ?? 0) > 1) {
    if (element.path?.endsWith('[x]') ?? false) {
      final String type = path
          .split('.')
          .last
          .replaceAll(
              element.path?.split('.').last.replaceAll('[x]', '') ?? '', '')
          .toLowerCase();
      return element.type!
          .firstWhereOrNull((ElementDefinitionType t) =>
              t.code?.toString().toLowerCase() == type)
          ?.code
          ?.toString();
    }
  }
  return null;
}

String cleanLocalPath(
    String originalPath, String replacePath, String childPath) {
  childPath = childPath.replaceAll(originalPath, replacePath);
  return _stripIndexes(childPath);
}

String _stripIndexes(String path) {
  RegExp regex = RegExp(r'\[\d+\]');
  return path.replaceAll(regex, '');
}

List<ElementDefinition> extractElements(
    StructureDefinition structureDefinition) {
  return structureDefinition.snapshot?.element ?? <ElementDefinition>[];
}

extension GetUrl on StructureDefinition {
  String? getUrl() {
    String? sdUrl = url?.toString();
    if (sdUrl != null && version != null) {
      sdUrl += '|$version';
    }
    return sdUrl;
  }
}

Future<Set<String>> getValueSetCodes(String valueSetUrl, Client? client) async {
  // Fetch the initial value set or code system from the URL
  final Map<String, dynamic>? resourceJson =
      await getResource(valueSetUrl, client);
  if (resourceJson == null) {
    throw Exception('Resource not found at $valueSetUrl');
  }

  final String? resourceType = resourceJson['resourceType'] as String?;
  final Set<String> codes = <String>{};

  if (resourceType == 'ValueSet') {
    final ValueSet valueSet = ValueSet.fromJson(resourceJson);
    // Extract codes from the ValueSet.compose.include section
    if (valueSet.compose != null) {
      for (ValueSetInclude include in valueSet.compose!.include) {
        // Fetch and process included ValueSet or CodeSystem URLs
        if (include.valueSet != null) {
          for (FhirCanonical includedValueSetUrl in include.valueSet!) {
            final Set<String> includedCodes = await _fetchIncludedValueSetCodes(
                includedValueSetUrl.toString(), client);
            codes.addAll(includedCodes);
          }
        }
        if (include.system != null) {
          final Set<String> includedCodes = await _fetchIncludedValueSetCodes(
              include.system.toString(), client);
          codes.addAll(includedCodes);
        }
        // Extract codes from the concepts directly defined in the include section
        for (ValueSetConcept concept
            in include.concept ?? <ValueSetConcept>[]) {
          if (concept.code != null) {
            codes.add(concept.code!.toString());
          }
        }
      }
    }

    // Extract codes from the ValueSet.expansion.contains section
    if (valueSet.expansion != null) {
      for (ValueSetContains contains
          in valueSet.expansion!.contains ?? <ValueSetContains>[]) {
        if (contains.code != null) {
          codes.add(contains.code!.toString());
        }
      }
    }
  } else if (resourceType == 'CodeSystem') {
    final CodeSystem codeSystem = CodeSystem.fromJson(resourceJson);
    // Extract codes from the CodeSystem.concept section
    for (CodeSystemConcept concept
        in codeSystem.concept ?? <CodeSystemConcept>[]) {
      if (concept.code != null) {
        codes.add(concept.code!.toString());
      }
      // Recursively extract codes from nested concepts
      codes.addAll(_extractCodesFromConcept(concept));
    }
  } else {
    throw Exception('Unexpected resource type: $resourceType');
  }

  return codes;
}

Future<Set<String>> _fetchIncludedValueSetCodes(
    String includedValueSetUrl, Client? client) async {
  // Fetch the included ValueSet or CodeSystem
  final Map<String, dynamic>? resourceJson =
      await getResource(includedValueSetUrl, client);
  if (resourceJson == null) {
    return <String>{};
  }

  final String? resourceType = resourceJson['resourceType'] as String?;
  final Set<String> includedCodes = <String>{};

  if (resourceType == 'ValueSet') {
    final ValueSet includedValueSet = ValueSet.fromJson(resourceJson);
    // Extract codes from the included ValueSet's compose.include section
    if (includedValueSet.compose != null) {
      for (ValueSetInclude include in includedValueSet.compose!.include) {
        // Do not recurse further if the included ValueSet references other ValueSets
        for (ValueSetConcept concept
            in include.concept ?? <ValueSetConcept>[]) {
          if (concept.code != null) {
            includedCodes.add(concept.code!.toString());
          }
        }
      }
    }

    // Extract codes from the included ValueSet's expansion.contains section
    if (includedValueSet.expansion != null) {
      for (ValueSetContains contains
          in includedValueSet.expansion!.contains ?? <ValueSetContains>[]) {
        if (contains.code != null) {
          includedCodes.add(contains.code!.toString());
        }
      }
    }
  } else if (resourceType == 'CodeSystem') {
    final CodeSystem includedCodeSystem = CodeSystem.fromJson(resourceJson);
    // Extract codes from the CodeSystem.concept section
    for (CodeSystemConcept concept
        in includedCodeSystem.concept ?? <CodeSystemConcept>[]) {
      if (concept.code != null) {
        includedCodes.add(concept.code!.toString());
      }
      // Recursively extract codes from nested concepts
      includedCodes.addAll(_extractCodesFromConcept(concept));
    }
  }

  return includedCodes;
}

Set<String> _extractCodesFromConcept(CodeSystemConcept concept) {
  final Set<String> codes = <String>{};
  if (concept.code != null) {
    codes.add(concept.code!.toString());
  }
  for (CodeSystemConcept subConcept
      in concept.concept ?? <CodeSystemConcept>[]) {
    codes.addAll(_extractCodesFromConcept(subConcept));
  }
  return codes;
}
