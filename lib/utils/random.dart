import 'package:collection/collection.dart';
import 'package:fhir_r4/fhir_r4.dart';

import '../fhir_validation.dart';

bool isAResourceType(PropertyNode node, ElementDefinition? element) =>
    element == null &&
    node.value is LiteralNode &&
    node.key?.value == 'resourceType' &&
    R4ResourceType.typesAsStrings.contains((node.value as LiteralNode).value);

ElementDefinition? polymorphicElement(
    String path, List<ElementDefinition> elements) {
  return elements.firstWhereOrNull((element) =>
      element.path != null &&
      element.path!.endsWith('[x]') &&
      path.startsWith(element.path!.replaceFirst('[x]', '')));
}

bool isAPolymorphicElement(ElementDefinition element) =>
    element.path != null && element.path!.endsWith('[x]');

String? findCode(ElementDefinition element, String path) {
  if (element.type?.length == 1) {
    return element.type?.first.code?.toString();
  } else if ((element.type?.length ?? 0) > 1) {
    if (element.path?.endsWith('[x]') ?? false) {
      final type = path
          .split('.')
          .last
          .replaceAll(
              element.path?.split('.').last.replaceAll('[x]', '') ?? '', '')
          .toLowerCase();
      return element.type!
          .firstWhereOrNull((t) => t.code?.toString().toLowerCase() == type)
          ?.code
          ?.toString();
    }
  }
  return null;
}

String cleanLocalPath(
    String originalPath, String replacePath, String childPath) {
  childPath = childPath.replaceAll(originalPath, replacePath);
  return stripIndexes(childPath);
}

String stripIndexes(String path) {
  RegExp regex = RegExp(r'\[\d+\]');
  return path.replaceAll(regex, '');
}

String? sdUrl(StructureDefinition structureDefinition) {
  String? sdUrl = structureDefinition.url?.toString();
  if (sdUrl != null && structureDefinition.version != null) {
    sdUrl += '|${structureDefinition.version}';
  }
  return sdUrl;
}

Node? checkForPolymorphism(ObjectNode node, ElementDefinition element,
    String currentPath, String originalPath, String replacePath) {
  if (isAPolymorphicElement(element)) {
    return node.children.firstWhereOrNull(
      (child) =>
          cleanLocalPath(originalPath, replacePath, child.path)
              .replaceFirst('[x]', '') ==
          currentPath,
    );
  }
  return null;
}

List<ElementDefinition> extractElements(
    StructureDefinition structureDefinition) {
  return structureDefinition.snapshot?.element ?? [];
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
