import 'dart:convert';

import 'package:fhir/r4.dart';
import 'package:petitparser/petitparser.dart';

final Parser<StructureMap> structureMapLexer = (metaUrl.optional() &
        metaName.optional() &
        metaTitle.optional() &
        ignored.optional() &
        mapIdLexer.trim().star() &
        structureLexer.trim().star() &
        importsLexer.trim().star() &
        constLexer.trim().star() &
        groupLexer.trim().plus())
    .map((value) => StructureMap(
          url: value[0] == null ? null : FhirUri(value[0]),
          name: value[1],
          title: value[2],
          status: FhirCode('draft'),
          description: value[2] == null ? null : FhirMarkdown(value[2]),
          group: value[8],
          structure: value[5],
        ))
    .end();

final Parser<String> mappingIdentifierLexer =
    (IDENTIFIER | DELIMITEDIDENTIFIER).map((value) {
  print('within mapping identifier lexer: $value');
  return value;
});

final Parser mapIdLexer =
    string('map') & urlLexer.trim() & char('=') & mappingIdentifierLexer.trim();

final Parser<String> urlLexer =
    (DELIMITEDIDENTIFIER | QUOTEDIDENTIFIER).map((value) => value);

final Parser<StructureMapStructure> structureLexer = (string('uses') &
        urlLexer.trim() &
        (structureAliasLexer).optional() &
        string('as').trim() &
        modelModeLexer)
    .map((value) => StructureMapStructure(
          url: FhirCanonical(value[1]),
          mode: FhirCode(value[4]),
          alias: value[2],
        ));

final Parser<String> structureAliasLexer =
    (string('alias') & mappingIdentifierLexer.trim()).map((value) => value[1]);

final Parser importsLexer = string('imports') & urlLexer.trim();

final Parser constLexer = string('let') &
    ID.trim() &
    char('=') &
    fhirPathLexer.trim() &
    char(';'); // which might just be a literal

/// ***************************************************************
/// Self referential
Parser<List<StructureMapRule>> rulesLexer() {
  final _rulesLexer = undefined();
  final _mappingRuleLexer = undefined();
  final _dependentLexer = undefined();

  final Parser<List<StructureMapRule>> rulesLexerPart = (char('{').trim() &
          _mappingRuleLexer.map((value) => value as StructureMapRule).star() &
          char('}').trim())
      .map((value) => value[1] as List<StructureMapRule>);

  final Parser<StructureMapRule> mappingRuleLexerPart =
      (ruleSourcesLexer.trim() &
              (string('->').trim() & ruleTargetsLexer.trim())
                  .map((value) => value[1])
                  .optional() &
              (_dependentLexer.trim()).optional() &
              (ruleNameLexer.trim()).optional() &
              char(';').trim())
          .map((value) {
    return StructureMapRule(
      source: value[0],
      target: value[1] == null || value[1].isEmpty ? null : value[1],
      dependent: value[2] == null || value[2].isEmpty ? null : value[2],
      name: value[3] == null ? null : FhirId(value[3]),
    );
  });

  final Parser<List<StructureMapDependent>> dependentLexerPart =
      (string('then').trim() &
              (invocationLexer &
                      (char(',').trim() & invocationLexer.trim())
                          .map((value) => value[1])
                          .star() &
                      _rulesLexer.star() |
                  _rulesLexer))
          .map((value) => [StructureMapDependent()]);

  _rulesLexer.set(rulesLexerPart);
  _mappingRuleLexer.set(mappingRuleLexerPart);
  _dependentLexer.set(dependentLexerPart);
  return _rulesLexer.map((value) => value);
}

/// *********************************************************************
final Parser<StructureMapTarget> ruleTargetLexer =
    (((ruleCtxLexer.trim().map((value) {
                      print('ruleCtxLexer: $value');
                      return value;
                    }) &
                    (char('=').trim() & transformLexer.trim())
                        .map((value) => value[1])
                        .optional() &
                    aliasLexer.trim().optional() &
                    targetListModeLexer.trim().optional()))
                .map((value) => StructureMapTarget(
                    context: FhirId(value[0].first),
                    element: value[0].length > 1 ? value[0][1] : null,
                    listMode: value[3] == null ? null : [FhirCode(value[3])],
                    listRuleId: value[2] == null ? null : FhirId(value[2]),
                    transform: value[1] == null || (value[1].isEmpty)
                        ? null
                        : FhirCode(value[1].keys.first),
                    parameter: value[1].values.first.isEmpty
                        ? null
                        : value[1].values.first)) |
            (invocationLexer.trim() & aliasLexer.optional())
                .map((value) => StructureMapTarget()))
        .map((value) => value);

final Parser<List<StructureMapTarget>> ruleTargetsLexer =
    (ruleTargetLexer.trim() &
            (char(',').trim() & ruleTargetLexer.trim())
                .map((value) => value[1] as StructureMapTarget)
                .star())
        .map((value) => <StructureMapTarget>[
              value[0],
              if (value[1].isNotEmpty) ...value[1],
            ]);

final Parser<List<StructureMapSource>> ruleSourcesLexer =
    (ruleSourceLexer.trim() &
            (char(',').trim() & ruleSourceLexer.trim())
                .map((value) => value[1] as StructureMapSource)
                .star())
        .map((value) => [
              value[0],
              if ((value[1] as List<StructureMapSource>).isNotEmpty)
                ...(value[1] as List<StructureMapSource>)
            ]);

final Parser<StructureMapSource> ruleSourceLexer = (ruleCtxLexer &
        (sourceTypeLexer.trim()).optional() &
        (sourceCardinalityLexer.trim()).optional() &
        (sourceDefaultLexer.trim()).optional() &
        (sourceListModeLexer.trim()).optional() &
        (aliasLexer.trim()).optional() &
        (whereClauseLexer.trim()).optional() &
        (checkClauseLexer.trim()).optional() &
        (logLexer.trim()).optional())
    .map((value) => StructureMapSource(
          context: FhirId(value[0].first),
          element: value[0].length > 1 ? value[0][1] : null,
          variable:
              value[5] == null ? null : FhirId(value[5].toString().trim()),
          type: value[1],
          min: value[2] == null ? null : FhirInteger(int.parse(value[2])),
          defaultValueString: value[3] == null ? null : value[3],
          listMode: value[4] == null ? null : FhirCode(value[4]),
          condition: value[6] == null ? null : value[6],
          check: value[7] == null ? null : value[7],
          logMessage: value[8] == null ? null : value[8],
        ));

final Parser<StructureMapGroup> groupLexer = (string('group').trim() &
        ID.trim() &
        parametersLexer &
        (extendsLexer.trim()).optional() &
        (typeModeLexer.trim()).optional() &
        rulesLexer().trim())
    .map((value) => StructureMapGroup(
          name: FhirId(value[1]),
          input: value[2] as List<StructureMapInput>,
          typeMode: value[4] == null ? FhirCode('none') : FhirCode(value[4]),
          rule: value[5] as List<StructureMapRule>,
        ));

final Parser typeModeLexer = string('<<') & groupTypeMode & string('>>');

final Parser extendsLexer = string('extends') & ID.trim();

final Parser<List<StructureMapInput>> parametersLexer = (char('(').trim() &
        parameterLexer &
        (char(',').trim() & parameterLexer)
            .map((value) => value[1] as StructureMapInput)
            .plus() &
        char(')').trim())
    .map((value) => <StructureMapInput>[
          value[1],
          if ((value[2] as List<StructureMapInput>).isNotEmpty)
            ...(value[2] as List<StructureMapInput>)
        ]);

final Parser<StructureMapInput> parameterLexer =
    (inputModeLexer.trim() & ID.trim() & typeLexer.optional().trim()).map(
        (value) => StructureMapInput(
            mode: value[0] == null ? null : FhirCode(value[0]),
            name: value[1] == null ? null : FhirId(value[1]),
            type: value.length > 1 ? value[2] : null));

final Parser<String> typeLexer =
    (char(':').trim() & mappingIdentifierLexer.trim()).map((value) => value[1]);

final Parser ruleNameLexer = ID | QUOTEDIDENTIFIER;

final Parser<String> sourceTypeLexer =
    (char(':') & mappingIdentifierLexer.trim()).map((value) => value[1]);

final Parser sourceCardinalityLexer = INTEGER & string('..') & upperBoundLexer;

final Parser upperBoundLexer = INTEGER | char('*');

final Parser<List<String>> ruleCtxLexer = (mappingIdentifierLexer &
        (char('.') & mappingIdentifierLexer).map((value) => value[1]).star())
    .map((value) => [value[0], if (value[1].isNotEmpty) ...value[1]]);

final Parser sourceDefaultLexer =
    string('default') & char('(').trim() & fhirPathLexer.trim() & char(')');

final Parser<String> aliasLexer =
    (string('as') & mappingIdentifierLexer.trim().flatten())
        .map((value) => value[1]);

final Parser whereClauseLexer =
    string('where') & char('(').trim() & fhirPathLexer.trim() & char(')');

final Parser checkClauseLexer =
    string('check') & char('(').trim() & fhirPathLexer.trim() & char(')');

final Parser logLexer =
    string('log') & char('(').trim() & fhirPathLexer.trim() & char(')');

typedef transform = Map<String, List<StructureMapParameter>>;

final Parser<transform> transformLexer = (invocationLexer |
        ruleCtxLexer.flatten().map((value) {
          print('rulectxlexer inside transform $value');
          return {
            'copy': [StructureMapParameter(valueId: FhirId(value.toString()))]
          };
        }) // 'copy' transform
        |
        literalLexer.map((value) {
          print('literal $value');
          return value;
        }) // trivial constant transform
    )
    .map((value) => value as transform); // other named transforms

final Parser<transform> invocationLexer = (mappingIdentifierLexer.map((value) {
          print('mappingIdentifierLexer: $value');
          return value;
        }) &
        char('(').trim().map((value) {
          print('paren');
          return value;
        }) &
        paramListLexer.optional() &
        char(')').trim())
    .map((value) => {value[0]: value[2] != null ? value[2] : []});

final Parser<List<StructureMapParameter>> paramListLexer = (paramLexer.trim() &
        (char(',').trim() & paramLexer).map((value) => value[1]).star())
    .map((value) => [
          value[0],
          if (value[1] != null && value[1].isNotEmpty) ...value[1],
        ]);

final Parser<StructureMapParameter> paramLexer =
    (literalLexer | ID.map((value) => FhirId(value)))
        .map((value) => StructureMapParameter(
              valueString: value is String ? value : null,
              valueId: value is FhirId ? value : null,
              valueInteger: value is FhirInteger ? value : null,
              valueDecimal: value is FhirDecimal ? value : null,
              valueBoolean: value is FhirBoolean ? value : null,
            ));

final Parser fhirPathLexer =
    literalLexer; // insert reference to FhirPath grammar here

final Parser literalLexer =
    INTEGER | NUMBER | STRING | DATETIME | DATE | TIME | BOOL;

final Parser groupTypeMode = string('types') | stringIgnoreCase('type+');

final Parser sourceListModeLexer = string('first') |
    string('not_first') |
    string('last') |
    string('not_last') |
    string('only_one');

final Parser<String> targetListModeLexer =
    (string('first') | string('share') | string('last') | string('single'))
        .map((value) => value.toString());

final Parser inputModeLexer = string('source').trim() | string('target').trim();

final Parser<String> modelModeLexer = (string('source') |
        string('queried') |
        string('target') |
        string('produced'))
    .map((value) => value); // StructureMapModelMode binding

/*
 * Syntax for embedded ConceptMaps excluded for now
 *
 * conceptMap : 'conceptMap' '"#' IDENTIFIER '{' (prefix)+ conceptMapping '}' ;
 *
 * prefix : 'prefix' conceptMappingVar '=' URL ;
 *
 * conceptMappingVar : IDENTIFIER ; conceptMapping : conceptMappingVar ':' field (('<=' | '=' | '=='
 * | '!=' '>=' '>-' | '<-' | '~') conceptMappingVar ':' field) | '--' ;
 */

/*********************Lexical rules from FhirPath *************************/

final Parser<FhirBoolean> BOOL = (string('true') | string('false'))
    .flatten()
    .map((value) => FhirBoolean(value == 'true'));

final Parser<FhirDate> DATE = (char('@') & DATEFORMAT)
    .flatten()
    .map((value) => FhirDate(value.replaceFirst('@', '')));

final Parser<FhirDateTime> DATETIME = (char('@') &
        DATEFORMAT &
        char('T') &
        (TIMEFORMAT & TIMEZONEOFFSETFORMAT.optional()).optional())
    .flatten()
    .map((value) => FhirDateTime(value.replaceFirst('@', '')));

final Parser<FhirTime> TIME = (char('@') & char('T') & TIMEFORMAT)
    .flatten()
    .map(
        (value) => FhirTime(value.replaceFirst('@', '').replaceFirst('T', '')));

final Parser DATEFORMAT = (digit() &
        digit() &
        digit() &
        digit() &
        (char('-') &
                digit() &
                digit() &
                (char('-') & digit() & digit()).optional())
            .optional())
    .flatten()
    .token();

final Parser TIMEFORMAT = (digit() &
        digit() &
        (char(':') &
                digit() &
                digit() &
                (char(':') &
                        digit() &
                        digit() &
                        (char('.') & digit().plus()).optional())
                    .optional())
            .optional())
    .flatten()
    .token();

final TIMEZONEOFFSETFORMAT = (char('Z') |
        ((char('+') | char('-')) &
            digit() &
            digit() &
            char(':') &
            digit() &
            digit()))
    .flatten()
    .token();

final Parser<String> ID = (pattern('a-zA-Z') & pattern('a-zA-Z0-9').star())
    .flatten()
    .map((value) => value.toString());

// Added _ to support CQL (FHIR could constrain it out)
final Parser<String> IDENTIFIER = ((pattern('A-Za-z') | char('_')) &
        (pattern('A-Za-z0-9') | char('_')).star())
    .flatten();

/// DelimitedIdentifier is signified by a backquote (`) on either end
final Parser<String> DELIMITEDIDENTIFIER =
    (char('`') & (ESC | char('`').neg()).star() & char('`')).map((value) {
  final middleValue = value[1]
      .map((e) => e is Token
          ? e.value.contains('u') as bool
              ? utf8.decode(
                  [int.parse(e.value.split('u').last as String, radix: 16)])
              : e.value.replaceAll(r'\\', r'\')
          : e == r'\'
              ? ''
              : e)
      .join('');
  final newValue = '${value[0]}$middleValue${value[2]}';
  return newValue.substring(1, newValue.length - 1);
});

/// DelimitedIdentifier is signified by a backquote ("") on either end
final Parser<String> QUOTEDIDENTIFIER =
    (char('"') & (ESC | char('"').neg()).star() & char('"')).map((value) {
  final middleValue = value[1]
      .map((e) => e is Token
          ? e.value.contains('u') as bool
              ? utf8.decode(
                  [int.parse(e.value.split('u').last as String, radix: 16)])
              : e.value.replaceAll(r'\\', r'\')
          : e == r'\'
              ? ''
              : e)
      .join('');
  final newValue = '${value[0]}$middleValue${value[2]}';
  return newValue.substring(1, newValue.length - 1);
});

final Parser<String> STRING =
    (char("'") & (ESC | char("'").neg()).star() & char("'")).map((value) {
  final middleValue = value[1]
      .map((e) => e is Token
          ? e.value.contains('u') as bool
              ? utf8.decode(
                  [int.parse(e.value.split('u').last as String, radix: 16)])
              : e.value.replaceAll(r'\\', r'\')
          : e == r'\'
              ? ''
              : e)
      .join('');
  var newValue = '${value[0]}$middleValue${value[2]}';
  newValue =
      newValue.length == 2 ? '' : newValue.substring(1, newValue.length - 1);
  return newValue;
});

// Also allows leading zeroes now (just like CQL and XSD)
final Parser<FhirNumber> NUMBER = (DECIMAL | INTEGER).map((value) => value);

final Parser<FhirDecimal> DECIMAL =
    (digit().plus() & char('.') & digit().plus())
        .flatten()
        .map((value) => FhirDecimal(double.parse(value)));

final Parser<FhirInteger> INTEGER =
    digit().plus().flatten().map((value) => FhirInteger(int.parse(value)));

// Pipe whitespace to the HIDDEN channel to support retrieving source text through the parser.
final Parser WS =
    ((string('\r') | string('\n') | string('\t') | char(' ')).plus()).flatten();

final Parser COMMENT =
    (string('/*') & string('*/').neg().star() & string('*/')).flatten();

final Parser LINE_COMMENT = ((string('///') | string('//')) &
        (string('\r') | string('\n')).neg().star())
    .flatten();

final Parser ignored = (WS | COMMENT | LINE_COMMENT).plus();

String _removeDelimiters(String string) {
  if (string.startsWith('"') ||
      string.startsWith('`') ||
      string.startsWith("'")) {
    string = string.substring(1);
  }
  if (string.endsWith('"') || string.endsWith('`') || string.endsWith("'")) {
    string = string.substring(0, string.length - 1);
  }
  return string;
}

final Parser<String> metaUrl = ((string('///') | string('//')).trim() &
        string('url').trim() &
        char('=').trim() &
        (string('\r') | string('\n')).neg().star().flatten())
    .map((value) => _removeDelimiters(value[3]));

final Parser<String> metaName = ((string('///') | string('//')).trim() &
        string('name').trim() &
        char('=').trim() &
        (string('\r') | string('\n')).neg().star().flatten())
    .map((value) => _removeDelimiters(value[3]));

final Parser<String> metaTitle = ((string('///') | string('//')).trim() &
        string('title').trim() &
        char('=').trim() &
        (string('\r') | string('\n')).neg().star().flatten())
    .map((value) => _removeDelimiters(value[3]));

final Parser ESC = (char(r'\') &
        (char('`') |
            char("'") |
            char(r'"') |
            char(r'\') |
            char('/') |
            char('f') |
            char('n') |
            char('r') |
            char('t') |
            UNICODE))
    .flatten()
    .token();

final Parser UNICODE = (char('u') & HEX & HEX & HEX & HEX).flatten().token();

final Parser HEX = pattern('0-9a-fA-F').flatten().token();
