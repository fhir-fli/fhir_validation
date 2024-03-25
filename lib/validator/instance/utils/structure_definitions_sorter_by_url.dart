import 'package:collection/collection.dart';
import 'package:fhir/r5.dart';

class StructureDefinitionSorterByUrl {
  bool compare(StructureDefinition o1, StructureDefinition o2) {
    return DeepCollectionEquality().equals(o1.url, o2.url);
  }
}
