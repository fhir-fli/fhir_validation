import 'dart:convert';

import 'petitparser/lexer.dart';

void main() {
  final ast = structureMapLexer.parse(mapString);
  print(prettyJson(ast.value.toJson()));
}

final mapString = r'''
/// url = 'http://hl7.org/fhir/StructureMap/tutorial-step3a'
/// name = 'tutorial-step3a'
/// title = 'Tutorial Step 3s'

uses "http://hl7.org/fhir/StructureDefinition/tutorial-left" alias TLeft as source
uses "http://hl7.org/fhir/StructureDefinition/tutorial-right" alias TRight as target

group tutorial(source src : TLeft, target tgt : TRight) {
  src.a2 as a -> tgt.a2 = truncate(a, 20) "rule_a20a";
}
''';

String prettyJson(Map map) => JsonEncoder.withIndent('    ').convert(map);

String prettyPrintJson(Map map) => JsonEncoder.withIndent('    ').convert(map);

String jsonPrettyPrint(Map map) => JsonEncoder.withIndent('    ').convert(map);
