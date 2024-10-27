import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart';
import 'package:fhir_validation/fhir_validation.dart';

String? findCode(ElementDefinition element, String path) {
  if (element.type?.length == 1) {
    return element.type?.first.code.toString();
  } else if ((element.type?.length ?? 0) > 1) {
    if (element.path.value?.endsWith('[x]') ?? false) {
      final type = path
          .split('.')
          .last
          .replaceAll(
            element.path.value?.split('.').last.replaceAll('[x]', '') ?? '',
            '',
          )
          .toLowerCase();
      return element.type!
          .firstWhereOrNull(
            (ElementDefinitionType t) =>
                t.code.toString().toLowerCase() == type,
          )
          ?.code
          .toString();
    }
  }
  return null;
}

String cleanLocalPath(
  String originalPath,
  String replacePath,
  String childPath,
) {
  childPath = childPath.replaceAll(originalPath, replacePath);
  return _stripIndexes(childPath);
}

String _stripIndexes(String path) {
  var regex = RegExp(r'\[\d+\]');
  return path.replaceAll(regex, '');
}

List<ElementDefinition> extractElements(
  StructureDefinition structureDefinition,
) {
  return structureDefinition.snapshot?.element ?? <ElementDefinition>[];
}

extension GetUrl on StructureDefinition {
  String? getUrl() {
    String? sdUrl = url.toString();
    if (version != null) {
      sdUrl += '|$version';
    }
    return sdUrl;
  }
}

Future<Set<String>> getValueSetCodes(String valueSetUrl, Client? client) async {
  // Fetch the initial value set or code system from the URL
  final resourceJson = await getResource(valueSetUrl, client);
  if (resourceJson == null) {
    throw Exception('Resource not found at $valueSetUrl');
  }

  final resourceType = resourceJson['resourceType'] as String?;
  final codes = <String>{};

  if (resourceType == 'ValueSet') {
    final valueSet = ValueSet.fromJson(resourceJson);
    // Extract codes from the ValueSet.compose.include section
    if (valueSet.compose != null) {
      for (var include in valueSet.compose!.include) {
        // Fetch and process included ValueSet or CodeSystem URLs
        if (include.valueSet != null) {
          for (var includedValueSetUrl in include.valueSet!) {
            final includedCodes = await _fetchIncludedValueSetCodes(
              includedValueSetUrl.toString(),
              client,
            );
            codes.addAll(includedCodes);
          }
        }
        if (include.system != null) {
          final includedCodes = await _fetchIncludedValueSetCodes(
            include.system.toString(),
            client,
          );
          codes.addAll(includedCodes);
        }
        // Extract codes from the concepts directly defined in the include section
        for (var concept in include.concept ?? <ValueSetConcept>[]) {
          codes.add(concept.code.toString());
        }
      }
    }

    // Extract codes from the ValueSet.expansion.contains section
    if (valueSet.expansion != null) {
      for (var contains
          in valueSet.expansion!.contains ?? <ValueSetContains>[]) {
        if (contains.code != null) {
          codes.add(contains.code!.toString());
        }
      }
    }
  } else if (resourceType == 'CodeSystem') {
    final codeSystem = CodeSystem.fromJson(resourceJson);
    // Extract codes from the CodeSystem.concept section
    for (var concept in codeSystem.concept ?? <CodeSystemConcept>[]) {
      codes.add(concept.code.toString());
      // Recursively extract codes from nested concepts
      codes.addAll(_extractCodesFromConcept(concept));
    }
  } else {
    throw Exception('Unexpected resource type: $resourceType');
  }

  return codes;
}

Future<Set<String>> _fetchIncludedValueSetCodes(
  String includedValueSetUrl,
  Client? client,
) async {
  // Fetch the included ValueSet or CodeSystem
  final resourceJson = await getResource(includedValueSetUrl, client);
  if (resourceJson == null) {
    return <String>{};
  }

  final resourceType = resourceJson['resourceType'] as String?;
  final includedCodes = <String>{};

  if (resourceType == 'ValueSet') {
    final includedValueSet = ValueSet.fromJson(resourceJson);
    // Extract codes from the included ValueSet's compose.include section
    if (includedValueSet.compose != null) {
      for (var include in includedValueSet.compose!.include) {
        // Do not recurse further if the included ValueSet references other ValueSets
        for (var concept in include.concept ?? <ValueSetConcept>[]) {
          includedCodes.add(concept.code.toString());
        }
      }
    }

    // Extract codes from the included ValueSet's expansion.contains section
    if (includedValueSet.expansion != null) {
      for (var contains
          in includedValueSet.expansion!.contains ?? <ValueSetContains>[]) {
        if (contains.code != null) {
          includedCodes.add(contains.code!.toString());
        }
      }
    }
  } else if (resourceType == 'CodeSystem') {
    final includedCodeSystem = CodeSystem.fromJson(resourceJson);
    // Extract codes from the CodeSystem.concept section
    for (var concept in includedCodeSystem.concept ?? <CodeSystemConcept>[]) {
      includedCodes.add(concept.code.toString());
      // Recursively extract codes from nested concepts
      includedCodes.addAll(_extractCodesFromConcept(concept));
    }
  }

  return includedCodes;
}

Set<String> _extractCodesFromConcept(CodeSystemConcept concept) {
  final codes = <String>{};
  codes.add(concept.code.toString());
  for (var subConcept in concept.concept ?? <CodeSystemConcept>[]) {
    codes.addAll(_extractCodesFromConcept(subConcept));
  }
  return codes;
}

String withUrlIfExists(String string, String? url) {
  return url != null ? '$string (from $url)' : string;
}
