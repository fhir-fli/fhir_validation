// Generated from mapping.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'mappingVisitor.dart';
import 'mappingBaseVisitor.dart';
const int RULE_structureMap = 0, RULE_identifier = 1, RULE_mapId = 2, RULE_url = 3, 
          RULE_structure = 4, RULE_structureAlias = 5, RULE_imports = 6, 
          RULE_const = 7, RULE_rules = 8, RULE_group = 9, RULE_typeMode = 10, 
          RULE_extends = 11, RULE_parameters = 12, RULE_parameter = 13, 
          RULE_type = 14, RULE_mappingRule = 15, RULE_ruleName = 16, RULE_ruleSources = 17, 
          RULE_ruleSource = 18, RULE_ruleTargets = 19, RULE_sourceType = 20, 
          RULE_sourceCardinality = 21, RULE_upperBound = 22, RULE_ruleCtx = 23, 
          RULE_sourceDefault = 24, RULE_alias = 25, RULE_whereClause = 26, 
          RULE_checkClause = 27, RULE_log = 28, RULE_dependent = 29, RULE_ruleTarget = 30, 
          RULE_transform = 31, RULE_invocation = 32, RULE_paramList = 33, 
          RULE_param = 34, RULE_fhirPath = 35, RULE_literal = 36, RULE_groupTypeMode = 37, 
          RULE_sourceListMode = 38, RULE_targetListMode = 39, RULE_inputMode = 40, 
          RULE_modelMode = 41;
class mappingParser extends Parser {
  static final checkVersion = () => RuntimeMetaData.checkVersion('4.13.1', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
      _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache = PredictionContextCache();
  static const int TOKEN_T__0 = 1, TOKEN_T__1 = 2, TOKEN_T__2 = 3, TOKEN_T__3 = 4, 
                   TOKEN_T__4 = 5, TOKEN_T__5 = 6, TOKEN_T__6 = 7, TOKEN_T__7 = 8, 
                   TOKEN_T__8 = 9, TOKEN_T__9 = 10, TOKEN_T__10 = 11, TOKEN_T__11 = 12, 
                   TOKEN_T__12 = 13, TOKEN_T__13 = 14, TOKEN_T__14 = 15, 
                   TOKEN_T__15 = 16, TOKEN_T__16 = 17, TOKEN_T__17 = 18, 
                   TOKEN_T__18 = 19, TOKEN_T__19 = 20, TOKEN_T__20 = 21, 
                   TOKEN_T__21 = 22, TOKEN_T__22 = 23, TOKEN_T__23 = 24, 
                   TOKEN_T__24 = 25, TOKEN_T__25 = 26, TOKEN_T__26 = 27, 
                   TOKEN_T__27 = 28, TOKEN_T__28 = 29, TOKEN_T__29 = 30, 
                   TOKEN_T__30 = 31, TOKEN_T__31 = 32, TOKEN_T__32 = 33, 
                   TOKEN_T__33 = 34, TOKEN_T__34 = 35, TOKEN_T__35 = 36, 
                   TOKEN_T__36 = 37, TOKEN_T__37 = 38, TOKEN_T__38 = 39, 
                   TOKEN_T__39 = 40, TOKEN_BOOL = 41, TOKEN_DATE = 42, TOKEN_DATETIME = 43, 
                   TOKEN_TIME = 44, TOKEN_ID = 45, TOKEN_IDENTIFIER = 46, 
                   TOKEN_DELIMITEDIDENTIFIER = 47, TOKEN_QUOTEDIDENTIFIER = 48, 
                   TOKEN_STRING = 49, TOKEN_INTEGER = 50, TOKEN_NUMBER = 51, 
                   TOKEN_WS = 52, TOKEN_COMMENT = 53, TOKEN_LINE_COMMENT = 54;

  @override
  final List<String> ruleNames = [
    'structureMap', 'identifier', 'mapId', 'url', 'structure', 'structureAlias', 
    'imports', 'const', 'rules', 'group', 'typeMode', 'extends', 'parameters', 
    'parameter', 'type', 'mappingRule', 'ruleName', 'ruleSources', 'ruleSource', 
    'ruleTargets', 'sourceType', 'sourceCardinality', 'upperBound', 'ruleCtx', 
    'sourceDefault', 'alias', 'whereClause', 'checkClause', 'log', 'dependent', 
    'ruleTarget', 'transform', 'invocation', 'paramList', 'param', 'fhirPath', 
    'literal', 'groupTypeMode', 'sourceListMode', 'targetListMode', 'inputMode', 
    'modelMode'
  ];

  static final List<String?> _LITERAL_NAMES = [
      null, "'map'", "'='", "'uses'", "'as'", "'alias'", "'imports'", "'let'", 
      "';'", "'{'", "'}'", "'group'", "'<<'", "'>>'", "'extends'", "'('", 
      "','", "')'", "':'", "'->'", "'..'", "'*'", "'.'", "'default'", "'where'", 
      "'check'", "'log'", "'then'", "'types'", "'type+'", "'first'", "'not_first'", 
      "'last'", "'not_last'", "'only_one'", "'share'", "'single'", "'source'", 
      "'target'", "'queried'", "'produced'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
      null, null, null, null, null, null, null, null, null, null, null, 
      null, null, null, null, null, null, null, null, null, null, null, 
      null, null, null, null, null, null, null, null, null, null, null, 
      null, null, null, null, null, null, null, null, "BOOL", "DATE", "DATETIME", 
      "TIME", "ID", "IDENTIFIER", "DELIMITEDIDENTIFIER", "QUOTEDIDENTIFIER", 
      "STRING", "INTEGER", "NUMBER", "WS", "COMMENT", "LINE_COMMENT"
  ];
  static final Vocabulary VOCABULARY = VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'mapping.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
   return _ATN;
  }

  mappingParser(TokenStream input) : super(input) {
    interpreter = ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  StructureMapContext structureMap() {
    dynamic _localctx = StructureMapContext(context, state);
    enterRule(_localctx, 0, RULE_structureMap);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 87;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_T__0) {
        state = 84;
        mapId();
        state = 89;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 93;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_T__2) {
        state = 90;
        structure();
        state = 95;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 99;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_T__5) {
        state = 96;
        imports();
        state = 101;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 105;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_T__6) {
        state = 102;
        const_();
        state = 107;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 109; 
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      do {
        state = 108;
        group();
        state = 111; 
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      } while (_la == TOKEN_T__10);
      state = 113;
      match(TOKEN_EOF);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  IdentifierContext identifier() {
    dynamic _localctx = IdentifierContext(context, state);
    enterRule(_localctx, 2, RULE_identifier);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 115;
      _la = tokenStream.LA(1)!;
      if (!(_la == TOKEN_IDENTIFIER || _la == TOKEN_DELIMITEDIDENTIFIER)) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  MapIdContext mapId() {
    dynamic _localctx = MapIdContext(context, state);
    enterRule(_localctx, 4, RULE_mapId);
    try {
      enterOuterAlt(_localctx, 1);
      state = 117;
      match(TOKEN_T__0);
      state = 118;
      url();
      state = 119;
      match(TOKEN_T__1);
      state = 120;
      identifier();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  UrlContext url() {
    dynamic _localctx = UrlContext(context, state);
    enterRule(_localctx, 6, RULE_url);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 122;
      _la = tokenStream.LA(1)!;
      if (!(_la == TOKEN_DELIMITEDIDENTIFIER || _la == TOKEN_QUOTEDIDENTIFIER)) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  StructureContext structure() {
    dynamic _localctx = StructureContext(context, state);
    enterRule(_localctx, 8, RULE_structure);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 124;
      match(TOKEN_T__2);
      state = 125;
      url();
      state = 127;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__4) {
        state = 126;
        structureAlias();
      }

      state = 129;
      match(TOKEN_T__3);
      state = 130;
      modelMode();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  StructureAliasContext structureAlias() {
    dynamic _localctx = StructureAliasContext(context, state);
    enterRule(_localctx, 10, RULE_structureAlias);
    try {
      enterOuterAlt(_localctx, 1);
      state = 132;
      match(TOKEN_T__4);
      state = 133;
      identifier();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ImportsContext imports() {
    dynamic _localctx = ImportsContext(context, state);
    enterRule(_localctx, 12, RULE_imports);
    try {
      enterOuterAlt(_localctx, 1);
      state = 135;
      match(TOKEN_T__5);
      state = 136;
      url();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ConstContext const_() {
    dynamic _localctx = ConstContext(context, state);
    enterRule(_localctx, 14, RULE_const);
    try {
      enterOuterAlt(_localctx, 1);
      state = 138;
      match(TOKEN_T__6);
      state = 139;
      match(TOKEN_ID);
      state = 140;
      match(TOKEN_T__1);
      state = 141;
      fhirPath();
      state = 142;
      match(TOKEN_T__7);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  RulesContext rules() {
    dynamic _localctx = RulesContext(context, state);
    enterRule(_localctx, 16, RULE_rules);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 144;
      match(TOKEN_T__8);
      state = 148;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_IDENTIFIER || _la == TOKEN_DELIMITEDIDENTIFIER) {
        state = 145;
        mappingRule();
        state = 150;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
      state = 151;
      match(TOKEN_T__9);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  GroupContext group() {
    dynamic _localctx = GroupContext(context, state);
    enterRule(_localctx, 18, RULE_group);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 153;
      match(TOKEN_T__10);
      state = 154;
      match(TOKEN_ID);
      state = 155;
      parameters();
      state = 157;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__13) {
        state = 156;
        extends_();
      }

      state = 160;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__11) {
        state = 159;
        typeMode();
      }

      state = 162;
      rules();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  TypeModeContext typeMode() {
    dynamic _localctx = TypeModeContext(context, state);
    enterRule(_localctx, 20, RULE_typeMode);
    try {
      enterOuterAlt(_localctx, 1);
      state = 164;
      match(TOKEN_T__11);
      state = 165;
      groupTypeMode();
      state = 166;
      match(TOKEN_T__12);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ExtendsContext extends_() {
    dynamic _localctx = ExtendsContext(context, state);
    enterRule(_localctx, 22, RULE_extends);
    try {
      enterOuterAlt(_localctx, 1);
      state = 168;
      match(TOKEN_T__13);
      state = 169;
      match(TOKEN_ID);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ParametersContext parameters() {
    dynamic _localctx = ParametersContext(context, state);
    enterRule(_localctx, 24, RULE_parameters);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 171;
      match(TOKEN_T__14);
      state = 172;
      parameter();
      state = 175; 
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      do {
        state = 173;
        match(TOKEN_T__15);
        state = 174;
        parameter();
        state = 177; 
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      } while (_la == TOKEN_T__15);
      state = 179;
      match(TOKEN_T__16);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ParameterContext parameter() {
    dynamic _localctx = ParameterContext(context, state);
    enterRule(_localctx, 26, RULE_parameter);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 181;
      inputMode();
      state = 182;
      match(TOKEN_ID);
      state = 184;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__17) {
        state = 183;
        type();
      }

    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  TypeContext type() {
    dynamic _localctx = TypeContext(context, state);
    enterRule(_localctx, 28, RULE_type);
    try {
      enterOuterAlt(_localctx, 1);
      state = 186;
      match(TOKEN_T__17);
      state = 187;
      identifier();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  MappingRuleContext mappingRule() {
    dynamic _localctx = MappingRuleContext(context, state);
    enterRule(_localctx, 30, RULE_mappingRule);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 189;
      ruleSources();
      state = 192;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__18) {
        state = 190;
        match(TOKEN_T__18);
        state = 191;
        ruleTargets();
      }

      state = 195;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__26) {
        state = 194;
        dependent();
      }

      state = 198;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_ID) {
        state = 197;
        ruleName();
      }

      state = 200;
      match(TOKEN_T__7);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  RuleNameContext ruleName() {
    dynamic _localctx = RuleNameContext(context, state);
    enterRule(_localctx, 32, RULE_ruleName);
    try {
      enterOuterAlt(_localctx, 1);
      state = 202;
      match(TOKEN_ID);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  RuleSourcesContext ruleSources() {
    dynamic _localctx = RuleSourcesContext(context, state);
    enterRule(_localctx, 34, RULE_ruleSources);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 204;
      ruleSource();
      state = 209;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_T__15) {
        state = 205;
        match(TOKEN_T__15);
        state = 206;
        ruleSource();
        state = 211;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  RuleSourceContext ruleSource() {
    dynamic _localctx = RuleSourceContext(context, state);
    enterRule(_localctx, 36, RULE_ruleSource);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 212;
      ruleCtx();
      state = 214;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__17) {
        state = 213;
        sourceType();
      }

      state = 217;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_INTEGER) {
        state = 216;
        sourceCardinality();
      }

      state = 220;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__22) {
        state = 219;
        sourceDefault();
      }

      state = 223;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if ((((_la) & ~0x3f) == 0 && ((1 << _la) & 33285996544) != 0)) {
        state = 222;
        sourceListMode();
      }

      state = 226;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__3) {
        state = 225;
        alias();
      }

      state = 229;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__23) {
        state = 228;
        whereClause();
      }

      state = 232;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__24) {
        state = 231;
        checkClause();
      }

      state = 235;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_T__25) {
        state = 234;
        log();
      }

    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  RuleTargetsContext ruleTargets() {
    dynamic _localctx = RuleTargetsContext(context, state);
    enterRule(_localctx, 38, RULE_ruleTargets);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 237;
      ruleTarget();
      state = 242;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_T__15) {
        state = 238;
        match(TOKEN_T__15);
        state = 239;
        ruleTarget();
        state = 244;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  SourceTypeContext sourceType() {
    dynamic _localctx = SourceTypeContext(context, state);
    enterRule(_localctx, 40, RULE_sourceType);
    try {
      enterOuterAlt(_localctx, 1);
      state = 245;
      match(TOKEN_T__17);
      state = 246;
      identifier();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  SourceCardinalityContext sourceCardinality() {
    dynamic _localctx = SourceCardinalityContext(context, state);
    enterRule(_localctx, 42, RULE_sourceCardinality);
    try {
      enterOuterAlt(_localctx, 1);
      state = 248;
      match(TOKEN_INTEGER);
      state = 249;
      match(TOKEN_T__19);
      state = 250;
      upperBound();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  UpperBoundContext upperBound() {
    dynamic _localctx = UpperBoundContext(context, state);
    enterRule(_localctx, 44, RULE_upperBound);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 252;
      _la = tokenStream.LA(1)!;
      if (!(_la == TOKEN_T__20 || _la == TOKEN_INTEGER)) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  RuleCtxContext ruleCtx() {
    dynamic _localctx = RuleCtxContext(context, state);
    enterRule(_localctx, 46, RULE_ruleCtx);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 254;
      identifier();
      state = 259;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_T__21) {
        state = 255;
        match(TOKEN_T__21);
        state = 256;
        identifier();
        state = 261;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  SourceDefaultContext sourceDefault() {
    dynamic _localctx = SourceDefaultContext(context, state);
    enterRule(_localctx, 48, RULE_sourceDefault);
    try {
      enterOuterAlt(_localctx, 1);
      state = 262;
      match(TOKEN_T__22);
      state = 263;
      match(TOKEN_T__14);
      state = 264;
      fhirPath();
      state = 265;
      match(TOKEN_T__16);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  AliasContext alias() {
    dynamic _localctx = AliasContext(context, state);
    enterRule(_localctx, 50, RULE_alias);
    try {
      enterOuterAlt(_localctx, 1);
      state = 267;
      match(TOKEN_T__3);
      state = 268;
      identifier();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  WhereClauseContext whereClause() {
    dynamic _localctx = WhereClauseContext(context, state);
    enterRule(_localctx, 52, RULE_whereClause);
    try {
      enterOuterAlt(_localctx, 1);
      state = 270;
      match(TOKEN_T__23);
      state = 271;
      match(TOKEN_T__14);
      state = 272;
      fhirPath();
      state = 273;
      match(TOKEN_T__16);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  CheckClauseContext checkClause() {
    dynamic _localctx = CheckClauseContext(context, state);
    enterRule(_localctx, 54, RULE_checkClause);
    try {
      enterOuterAlt(_localctx, 1);
      state = 275;
      match(TOKEN_T__24);
      state = 276;
      match(TOKEN_T__14);
      state = 277;
      fhirPath();
      state = 278;
      match(TOKEN_T__16);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  LogContext log() {
    dynamic _localctx = LogContext(context, state);
    enterRule(_localctx, 56, RULE_log);
    try {
      enterOuterAlt(_localctx, 1);
      state = 280;
      match(TOKEN_T__25);
      state = 281;
      match(TOKEN_T__14);
      state = 282;
      fhirPath();
      state = 283;
      match(TOKEN_T__16);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  DependentContext dependent() {
    dynamic _localctx = DependentContext(context, state);
    enterRule(_localctx, 58, RULE_dependent);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 285;
      match(TOKEN_T__26);
      state = 298;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
      case TOKEN_IDENTIFIER:
      case TOKEN_DELIMITEDIDENTIFIER:
        state = 286;
        invocation();
        state = 291;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        while (_la == TOKEN_T__15) {
          state = 287;
          match(TOKEN_T__15);
          state = 288;
          invocation();
          state = 293;
          errorHandler.sync(this);
          _la = tokenStream.LA(1)!;
        }
        state = 295;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        if (_la == TOKEN_T__8) {
          state = 294;
          rules();
        }

        break;
      case TOKEN_T__8:
        state = 297;
        rules();
        break;
      default:
        throw NoViableAltException(this);
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  RuleTargetContext ruleTarget() {
    dynamic _localctx = RuleTargetContext(context, state);
    enterRule(_localctx, 60, RULE_ruleTarget);
    int _la;
    try {
      state = 315;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 32, context)) {
      case 1:
        enterOuterAlt(_localctx, 1);
        state = 300;
        ruleCtx();
        state = 303;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        if (_la == TOKEN_T__1) {
          state = 301;
          match(TOKEN_T__1);
          state = 302;
          transform();
        }

        state = 306;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        if (_la == TOKEN_T__3) {
          state = 305;
          alias();
        }

        state = 309;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        if ((((_la) & ~0x3f) == 0 && ((1 << _la) & 108447924224) != 0)) {
          state = 308;
          targetListMode();
        }

        break;
      case 2:
        enterOuterAlt(_localctx, 2);
        state = 311;
        invocation();
        state = 313;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
        if (_la == TOKEN_T__3) {
          state = 312;
          alias();
        }

        break;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  TransformContext transform() {
    dynamic _localctx = TransformContext(context, state);
    enterRule(_localctx, 62, RULE_transform);
    try {
      state = 320;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 33, context)) {
      case 1:
        enterOuterAlt(_localctx, 1);
        state = 317;
        literal();
        break;
      case 2:
        enterOuterAlt(_localctx, 2);
        state = 318;
        ruleCtx();
        break;
      case 3:
        enterOuterAlt(_localctx, 3);
        state = 319;
        invocation();
        break;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  InvocationContext invocation() {
    dynamic _localctx = InvocationContext(context, state);
    enterRule(_localctx, 64, RULE_invocation);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 322;
      identifier();
      state = 323;
      match(TOKEN_T__14);
      state = 325;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if ((((_la) & ~0x3f) == 0 && ((1 << _la) & 4008819394871296) != 0)) {
        state = 324;
        paramList();
      }

      state = 327;
      match(TOKEN_T__16);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ParamListContext paramList() {
    dynamic _localctx = ParamListContext(context, state);
    enterRule(_localctx, 66, RULE_paramList);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 329;
      param();
      state = 334;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_T__15) {
        state = 330;
        match(TOKEN_T__15);
        state = 331;
        param();
        state = 336;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ParamContext param() {
    dynamic _localctx = ParamContext(context, state);
    enterRule(_localctx, 68, RULE_param);
    try {
      state = 339;
      errorHandler.sync(this);
      switch (tokenStream.LA(1)!) {
      case TOKEN_BOOL:
      case TOKEN_DATE:
      case TOKEN_DATETIME:
      case TOKEN_TIME:
      case TOKEN_STRING:
      case TOKEN_INTEGER:
      case TOKEN_NUMBER:
        enterOuterAlt(_localctx, 1);
        state = 337;
        literal();
        break;
      case TOKEN_ID:
        enterOuterAlt(_localctx, 2);
        state = 338;
        match(TOKEN_ID);
        break;
      default:
        throw NoViableAltException(this);
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  FhirPathContext fhirPath() {
    dynamic _localctx = FhirPathContext(context, state);
    enterRule(_localctx, 70, RULE_fhirPath);
    try {
      enterOuterAlt(_localctx, 1);
      state = 341;
      literal();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  LiteralContext literal() {
    dynamic _localctx = LiteralContext(context, state);
    enterRule(_localctx, 72, RULE_literal);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 343;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 3973635022782464) != 0))) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  GroupTypeModeContext groupTypeMode() {
    dynamic _localctx = GroupTypeModeContext(context, state);
    enterRule(_localctx, 74, RULE_groupTypeMode);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 345;
      _la = tokenStream.LA(1)!;
      if (!(_la == TOKEN_T__27 || _la == TOKEN_T__28)) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  SourceListModeContext sourceListMode() {
    dynamic _localctx = SourceListModeContext(context, state);
    enterRule(_localctx, 76, RULE_sourceListMode);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 347;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 33285996544) != 0))) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  TargetListModeContext targetListMode() {
    dynamic _localctx = TargetListModeContext(context, state);
    enterRule(_localctx, 78, RULE_targetListMode);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 349;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 108447924224) != 0))) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  InputModeContext inputMode() {
    dynamic _localctx = InputModeContext(context, state);
    enterRule(_localctx, 80, RULE_inputMode);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 351;
      _la = tokenStream.LA(1)!;
      if (!(_la == TOKEN_T__36 || _la == TOKEN_T__37)) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ModelModeContext modelMode() {
    dynamic _localctx = ModelModeContext(context, state);
    enterRule(_localctx, 82, RULE_modelMode);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 353;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 2061584302080) != 0))) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  static const List<int> _serializedATN = [
      4,1,54,356,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,
      2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,2,
      14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,2,19,7,19,2,20,7,20,
      2,21,7,21,2,22,7,22,2,23,7,23,2,24,7,24,2,25,7,25,2,26,7,26,2,27,7,
      27,2,28,7,28,2,29,7,29,2,30,7,30,2,31,7,31,2,32,7,32,2,33,7,33,2,34,
      7,34,2,35,7,35,2,36,7,36,2,37,7,37,2,38,7,38,2,39,7,39,2,40,7,40,2,
      41,7,41,1,0,5,0,86,8,0,10,0,12,0,89,9,0,1,0,5,0,92,8,0,10,0,12,0,95,
      9,0,1,0,5,0,98,8,0,10,0,12,0,101,9,0,1,0,5,0,104,8,0,10,0,12,0,107,
      9,0,1,0,4,0,110,8,0,11,0,12,0,111,1,0,1,0,1,1,1,1,1,2,1,2,1,2,1,2,
      1,2,1,3,1,3,1,4,1,4,1,4,3,4,128,8,4,1,4,1,4,1,4,1,5,1,5,1,5,1,6,1,
      6,1,6,1,7,1,7,1,7,1,7,1,7,1,7,1,8,1,8,5,8,147,8,8,10,8,12,8,150,9,
      8,1,8,1,8,1,9,1,9,1,9,1,9,3,9,158,8,9,1,9,3,9,161,8,9,1,9,1,9,1,10,
      1,10,1,10,1,10,1,11,1,11,1,11,1,12,1,12,1,12,1,12,4,12,176,8,12,11,
      12,12,12,177,1,12,1,12,1,13,1,13,1,13,3,13,185,8,13,1,14,1,14,1,14,
      1,15,1,15,1,15,3,15,193,8,15,1,15,3,15,196,8,15,1,15,3,15,199,8,15,
      1,15,1,15,1,16,1,16,1,17,1,17,1,17,5,17,208,8,17,10,17,12,17,211,9,
      17,1,18,1,18,3,18,215,8,18,1,18,3,18,218,8,18,1,18,3,18,221,8,18,1,
      18,3,18,224,8,18,1,18,3,18,227,8,18,1,18,3,18,230,8,18,1,18,3,18,233,
      8,18,1,18,3,18,236,8,18,1,19,1,19,1,19,5,19,241,8,19,10,19,12,19,244,
      9,19,1,20,1,20,1,20,1,21,1,21,1,21,1,21,1,22,1,22,1,23,1,23,1,23,5,
      23,258,8,23,10,23,12,23,261,9,23,1,24,1,24,1,24,1,24,1,24,1,25,1,25,
      1,25,1,26,1,26,1,26,1,26,1,26,1,27,1,27,1,27,1,27,1,27,1,28,1,28,1,
      28,1,28,1,28,1,29,1,29,1,29,1,29,5,29,290,8,29,10,29,12,29,293,9,29,
      1,29,3,29,296,8,29,1,29,3,29,299,8,29,1,30,1,30,1,30,3,30,304,8,30,
      1,30,3,30,307,8,30,1,30,3,30,310,8,30,1,30,1,30,3,30,314,8,30,3,30,
      316,8,30,1,31,1,31,1,31,3,31,321,8,31,1,32,1,32,1,32,3,32,326,8,32,
      1,32,1,32,1,33,1,33,1,33,5,33,333,8,33,10,33,12,33,336,9,33,1,34,1,
      34,3,34,340,8,34,1,35,1,35,1,36,1,36,1,37,1,37,1,38,1,38,1,39,1,39,
      1,40,1,40,1,41,1,41,1,41,0,0,42,0,2,4,6,8,10,12,14,16,18,20,22,24,
      26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,
      70,72,74,76,78,80,82,0,9,1,0,46,47,1,0,47,48,2,0,21,21,50,50,2,0,41,
      44,49,51,1,0,28,29,1,0,30,34,3,0,30,30,32,32,35,36,1,0,37,38,1,0,37,
      40,351,0,87,1,0,0,0,2,115,1,0,0,0,4,117,1,0,0,0,6,122,1,0,0,0,8,124,
      1,0,0,0,10,132,1,0,0,0,12,135,1,0,0,0,14,138,1,0,0,0,16,144,1,0,0,
      0,18,153,1,0,0,0,20,164,1,0,0,0,22,168,1,0,0,0,24,171,1,0,0,0,26,181,
      1,0,0,0,28,186,1,0,0,0,30,189,1,0,0,0,32,202,1,0,0,0,34,204,1,0,0,
      0,36,212,1,0,0,0,38,237,1,0,0,0,40,245,1,0,0,0,42,248,1,0,0,0,44,252,
      1,0,0,0,46,254,1,0,0,0,48,262,1,0,0,0,50,267,1,0,0,0,52,270,1,0,0,
      0,54,275,1,0,0,0,56,280,1,0,0,0,58,285,1,0,0,0,60,315,1,0,0,0,62,320,
      1,0,0,0,64,322,1,0,0,0,66,329,1,0,0,0,68,339,1,0,0,0,70,341,1,0,0,
      0,72,343,1,0,0,0,74,345,1,0,0,0,76,347,1,0,0,0,78,349,1,0,0,0,80,351,
      1,0,0,0,82,353,1,0,0,0,84,86,3,4,2,0,85,84,1,0,0,0,86,89,1,0,0,0,87,
      85,1,0,0,0,87,88,1,0,0,0,88,93,1,0,0,0,89,87,1,0,0,0,90,92,3,8,4,0,
      91,90,1,0,0,0,92,95,1,0,0,0,93,91,1,0,0,0,93,94,1,0,0,0,94,99,1,0,
      0,0,95,93,1,0,0,0,96,98,3,12,6,0,97,96,1,0,0,0,98,101,1,0,0,0,99,97,
      1,0,0,0,99,100,1,0,0,0,100,105,1,0,0,0,101,99,1,0,0,0,102,104,3,14,
      7,0,103,102,1,0,0,0,104,107,1,0,0,0,105,103,1,0,0,0,105,106,1,0,0,
      0,106,109,1,0,0,0,107,105,1,0,0,0,108,110,3,18,9,0,109,108,1,0,0,0,
      110,111,1,0,0,0,111,109,1,0,0,0,111,112,1,0,0,0,112,113,1,0,0,0,113,
      114,5,0,0,1,114,1,1,0,0,0,115,116,7,0,0,0,116,3,1,0,0,0,117,118,5,
      1,0,0,118,119,3,6,3,0,119,120,5,2,0,0,120,121,3,2,1,0,121,5,1,0,0,
      0,122,123,7,1,0,0,123,7,1,0,0,0,124,125,5,3,0,0,125,127,3,6,3,0,126,
      128,3,10,5,0,127,126,1,0,0,0,127,128,1,0,0,0,128,129,1,0,0,0,129,130,
      5,4,0,0,130,131,3,82,41,0,131,9,1,0,0,0,132,133,5,5,0,0,133,134,3,
      2,1,0,134,11,1,0,0,0,135,136,5,6,0,0,136,137,3,6,3,0,137,13,1,0,0,
      0,138,139,5,7,0,0,139,140,5,45,0,0,140,141,5,2,0,0,141,142,3,70,35,
      0,142,143,5,8,0,0,143,15,1,0,0,0,144,148,5,9,0,0,145,147,3,30,15,0,
      146,145,1,0,0,0,147,150,1,0,0,0,148,146,1,0,0,0,148,149,1,0,0,0,149,
      151,1,0,0,0,150,148,1,0,0,0,151,152,5,10,0,0,152,17,1,0,0,0,153,154,
      5,11,0,0,154,155,5,45,0,0,155,157,3,24,12,0,156,158,3,22,11,0,157,
      156,1,0,0,0,157,158,1,0,0,0,158,160,1,0,0,0,159,161,3,20,10,0,160,
      159,1,0,0,0,160,161,1,0,0,0,161,162,1,0,0,0,162,163,3,16,8,0,163,19,
      1,0,0,0,164,165,5,12,0,0,165,166,3,74,37,0,166,167,5,13,0,0,167,21,
      1,0,0,0,168,169,5,14,0,0,169,170,5,45,0,0,170,23,1,0,0,0,171,172,5,
      15,0,0,172,175,3,26,13,0,173,174,5,16,0,0,174,176,3,26,13,0,175,173,
      1,0,0,0,176,177,1,0,0,0,177,175,1,0,0,0,177,178,1,0,0,0,178,179,1,
      0,0,0,179,180,5,17,0,0,180,25,1,0,0,0,181,182,3,80,40,0,182,184,5,
      45,0,0,183,185,3,28,14,0,184,183,1,0,0,0,184,185,1,0,0,0,185,27,1,
      0,0,0,186,187,5,18,0,0,187,188,3,2,1,0,188,29,1,0,0,0,189,192,3,34,
      17,0,190,191,5,19,0,0,191,193,3,38,19,0,192,190,1,0,0,0,192,193,1,
      0,0,0,193,195,1,0,0,0,194,196,3,58,29,0,195,194,1,0,0,0,195,196,1,
      0,0,0,196,198,1,0,0,0,197,199,3,32,16,0,198,197,1,0,0,0,198,199,1,
      0,0,0,199,200,1,0,0,0,200,201,5,8,0,0,201,31,1,0,0,0,202,203,5,45,
      0,0,203,33,1,0,0,0,204,209,3,36,18,0,205,206,5,16,0,0,206,208,3,36,
      18,0,207,205,1,0,0,0,208,211,1,0,0,0,209,207,1,0,0,0,209,210,1,0,0,
      0,210,35,1,0,0,0,211,209,1,0,0,0,212,214,3,46,23,0,213,215,3,40,20,
      0,214,213,1,0,0,0,214,215,1,0,0,0,215,217,1,0,0,0,216,218,3,42,21,
      0,217,216,1,0,0,0,217,218,1,0,0,0,218,220,1,0,0,0,219,221,3,48,24,
      0,220,219,1,0,0,0,220,221,1,0,0,0,221,223,1,0,0,0,222,224,3,76,38,
      0,223,222,1,0,0,0,223,224,1,0,0,0,224,226,1,0,0,0,225,227,3,50,25,
      0,226,225,1,0,0,0,226,227,1,0,0,0,227,229,1,0,0,0,228,230,3,52,26,
      0,229,228,1,0,0,0,229,230,1,0,0,0,230,232,1,0,0,0,231,233,3,54,27,
      0,232,231,1,0,0,0,232,233,1,0,0,0,233,235,1,0,0,0,234,236,3,56,28,
      0,235,234,1,0,0,0,235,236,1,0,0,0,236,37,1,0,0,0,237,242,3,60,30,0,
      238,239,5,16,0,0,239,241,3,60,30,0,240,238,1,0,0,0,241,244,1,0,0,0,
      242,240,1,0,0,0,242,243,1,0,0,0,243,39,1,0,0,0,244,242,1,0,0,0,245,
      246,5,18,0,0,246,247,3,2,1,0,247,41,1,0,0,0,248,249,5,50,0,0,249,250,
      5,20,0,0,250,251,3,44,22,0,251,43,1,0,0,0,252,253,7,2,0,0,253,45,1,
      0,0,0,254,259,3,2,1,0,255,256,5,22,0,0,256,258,3,2,1,0,257,255,1,0,
      0,0,258,261,1,0,0,0,259,257,1,0,0,0,259,260,1,0,0,0,260,47,1,0,0,0,
      261,259,1,0,0,0,262,263,5,23,0,0,263,264,5,15,0,0,264,265,3,70,35,
      0,265,266,5,17,0,0,266,49,1,0,0,0,267,268,5,4,0,0,268,269,3,2,1,0,
      269,51,1,0,0,0,270,271,5,24,0,0,271,272,5,15,0,0,272,273,3,70,35,0,
      273,274,5,17,0,0,274,53,1,0,0,0,275,276,5,25,0,0,276,277,5,15,0,0,
      277,278,3,70,35,0,278,279,5,17,0,0,279,55,1,0,0,0,280,281,5,26,0,0,
      281,282,5,15,0,0,282,283,3,70,35,0,283,284,5,17,0,0,284,57,1,0,0,0,
      285,298,5,27,0,0,286,291,3,64,32,0,287,288,5,16,0,0,288,290,3,64,32,
      0,289,287,1,0,0,0,290,293,1,0,0,0,291,289,1,0,0,0,291,292,1,0,0,0,
      292,295,1,0,0,0,293,291,1,0,0,0,294,296,3,16,8,0,295,294,1,0,0,0,295,
      296,1,0,0,0,296,299,1,0,0,0,297,299,3,16,8,0,298,286,1,0,0,0,298,297,
      1,0,0,0,299,59,1,0,0,0,300,303,3,46,23,0,301,302,5,2,0,0,302,304,3,
      62,31,0,303,301,1,0,0,0,303,304,1,0,0,0,304,306,1,0,0,0,305,307,3,
      50,25,0,306,305,1,0,0,0,306,307,1,0,0,0,307,309,1,0,0,0,308,310,3,
      78,39,0,309,308,1,0,0,0,309,310,1,0,0,0,310,316,1,0,0,0,311,313,3,
      64,32,0,312,314,3,50,25,0,313,312,1,0,0,0,313,314,1,0,0,0,314,316,
      1,0,0,0,315,300,1,0,0,0,315,311,1,0,0,0,316,61,1,0,0,0,317,321,3,72,
      36,0,318,321,3,46,23,0,319,321,3,64,32,0,320,317,1,0,0,0,320,318,1,
      0,0,0,320,319,1,0,0,0,321,63,1,0,0,0,322,323,3,2,1,0,323,325,5,15,
      0,0,324,326,3,66,33,0,325,324,1,0,0,0,325,326,1,0,0,0,326,327,1,0,
      0,0,327,328,5,17,0,0,328,65,1,0,0,0,329,334,3,68,34,0,330,331,5,16,
      0,0,331,333,3,68,34,0,332,330,1,0,0,0,333,336,1,0,0,0,334,332,1,0,
      0,0,334,335,1,0,0,0,335,67,1,0,0,0,336,334,1,0,0,0,337,340,3,72,36,
      0,338,340,5,45,0,0,339,337,1,0,0,0,339,338,1,0,0,0,340,69,1,0,0,0,
      341,342,3,72,36,0,342,71,1,0,0,0,343,344,7,3,0,0,344,73,1,0,0,0,345,
      346,7,4,0,0,346,75,1,0,0,0,347,348,7,5,0,0,348,77,1,0,0,0,349,350,
      7,6,0,0,350,79,1,0,0,0,351,352,7,7,0,0,352,81,1,0,0,0,353,354,7,8,
      0,0,354,83,1,0,0,0,37,87,93,99,105,111,127,148,157,160,177,184,192,
      195,198,209,214,217,220,223,226,229,232,235,242,259,291,295,298,303,
      306,309,313,315,320,325,334,339
  ];

  static final ATN _ATN =
      ATNDeserializer().deserialize(_serializedATN);
}
class StructureMapContext extends ParserRuleContext {
  TerminalNode? EOF() => getToken(mappingParser.TOKEN_EOF, 0);
  List<MapIdContext> mapIds() => getRuleContexts<MapIdContext>();
  MapIdContext? mapId(int i) => getRuleContext<MapIdContext>(i);
  List<StructureContext> structures() => getRuleContexts<StructureContext>();
  StructureContext? structure(int i) => getRuleContext<StructureContext>(i);
  List<ImportsContext> importss() => getRuleContexts<ImportsContext>();
  ImportsContext? imports(int i) => getRuleContext<ImportsContext>(i);
  List<ConstContext> consts() => getRuleContexts<ConstContext>();
  ConstContext? const_(int i) => getRuleContext<ConstContext>(i);
  List<GroupContext> groups() => getRuleContexts<GroupContext>();
  GroupContext? group(int i) => getRuleContext<GroupContext>(i);
  StructureMapContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_structureMap;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitStructureMap(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class IdentifierContext extends ParserRuleContext {
  TerminalNode? IDENTIFIER() => getToken(mappingParser.TOKEN_IDENTIFIER, 0);
  TerminalNode? DELIMITEDIDENTIFIER() => getToken(mappingParser.TOKEN_DELIMITEDIDENTIFIER, 0);
  IdentifierContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_identifier;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitIdentifier(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class MapIdContext extends ParserRuleContext {
  UrlContext? url() => getRuleContext<UrlContext>(0);
  IdentifierContext? identifier() => getRuleContext<IdentifierContext>(0);
  MapIdContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_mapId;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitMapId(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class UrlContext extends ParserRuleContext {
  TerminalNode? DELIMITEDIDENTIFIER() => getToken(mappingParser.TOKEN_DELIMITEDIDENTIFIER, 0);
  TerminalNode? QUOTEDIDENTIFIER() => getToken(mappingParser.TOKEN_QUOTEDIDENTIFIER, 0);
  UrlContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_url;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitUrl(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class StructureContext extends ParserRuleContext {
  UrlContext? url() => getRuleContext<UrlContext>(0);
  ModelModeContext? modelMode() => getRuleContext<ModelModeContext>(0);
  StructureAliasContext? structureAlias() => getRuleContext<StructureAliasContext>(0);
  StructureContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_structure;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitStructure(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class StructureAliasContext extends ParserRuleContext {
  IdentifierContext? identifier() => getRuleContext<IdentifierContext>(0);
  StructureAliasContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_structureAlias;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitStructureAlias(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ImportsContext extends ParserRuleContext {
  UrlContext? url() => getRuleContext<UrlContext>(0);
  ImportsContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_imports;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitImports(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ConstContext extends ParserRuleContext {
  TerminalNode? ID() => getToken(mappingParser.TOKEN_ID, 0);
  FhirPathContext? fhirPath() => getRuleContext<FhirPathContext>(0);
  ConstContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_const;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitConst(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class RulesContext extends ParserRuleContext {
  List<MappingRuleContext> mappingRules() => getRuleContexts<MappingRuleContext>();
  MappingRuleContext? mappingRule(int i) => getRuleContext<MappingRuleContext>(i);
  RulesContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_rules;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitRules(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class GroupContext extends ParserRuleContext {
  TerminalNode? ID() => getToken(mappingParser.TOKEN_ID, 0);
  ParametersContext? parameters() => getRuleContext<ParametersContext>(0);
  RulesContext? rules() => getRuleContext<RulesContext>(0);
  ExtendsContext? extends_() => getRuleContext<ExtendsContext>(0);
  TypeModeContext? typeMode() => getRuleContext<TypeModeContext>(0);
  GroupContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_group;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitGroup(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class TypeModeContext extends ParserRuleContext {
  GroupTypeModeContext? groupTypeMode() => getRuleContext<GroupTypeModeContext>(0);
  TypeModeContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_typeMode;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitTypeMode(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ExtendsContext extends ParserRuleContext {
  TerminalNode? ID() => getToken(mappingParser.TOKEN_ID, 0);
  ExtendsContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_extends;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitExtends(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ParametersContext extends ParserRuleContext {
  List<ParameterContext> parameters() => getRuleContexts<ParameterContext>();
  ParameterContext? parameter(int i) => getRuleContext<ParameterContext>(i);
  ParametersContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_parameters;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitParameters(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ParameterContext extends ParserRuleContext {
  InputModeContext? inputMode() => getRuleContext<InputModeContext>(0);
  TerminalNode? ID() => getToken(mappingParser.TOKEN_ID, 0);
  TypeContext? type() => getRuleContext<TypeContext>(0);
  ParameterContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_parameter;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitParameter(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class TypeContext extends ParserRuleContext {
  IdentifierContext? identifier() => getRuleContext<IdentifierContext>(0);
  TypeContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_type;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitType(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class MappingRuleContext extends ParserRuleContext {
  RuleSourcesContext? ruleSources() => getRuleContext<RuleSourcesContext>(0);
  RuleTargetsContext? ruleTargets() => getRuleContext<RuleTargetsContext>(0);
  DependentContext? dependent() => getRuleContext<DependentContext>(0);
  RuleNameContext? ruleName() => getRuleContext<RuleNameContext>(0);
  MappingRuleContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_mappingRule;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitMappingRule(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class RuleNameContext extends ParserRuleContext {
  TerminalNode? ID() => getToken(mappingParser.TOKEN_ID, 0);
  RuleNameContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_ruleName;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitRuleName(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class RuleSourcesContext extends ParserRuleContext {
  List<RuleSourceContext> ruleSources() => getRuleContexts<RuleSourceContext>();
  RuleSourceContext? ruleSource(int i) => getRuleContext<RuleSourceContext>(i);
  RuleSourcesContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_ruleSources;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitRuleSources(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class RuleSourceContext extends ParserRuleContext {
  RuleCtxContext? ruleCtx() => getRuleContext<RuleCtxContext>(0);
  SourceTypeContext? sourceType() => getRuleContext<SourceTypeContext>(0);
  SourceCardinalityContext? sourceCardinality() => getRuleContext<SourceCardinalityContext>(0);
  SourceDefaultContext? sourceDefault() => getRuleContext<SourceDefaultContext>(0);
  SourceListModeContext? sourceListMode() => getRuleContext<SourceListModeContext>(0);
  AliasContext? alias() => getRuleContext<AliasContext>(0);
  WhereClauseContext? whereClause() => getRuleContext<WhereClauseContext>(0);
  CheckClauseContext? checkClause() => getRuleContext<CheckClauseContext>(0);
  LogContext? log() => getRuleContext<LogContext>(0);
  RuleSourceContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_ruleSource;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitRuleSource(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class RuleTargetsContext extends ParserRuleContext {
  List<RuleTargetContext> ruleTargets() => getRuleContexts<RuleTargetContext>();
  RuleTargetContext? ruleTarget(int i) => getRuleContext<RuleTargetContext>(i);
  RuleTargetsContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_ruleTargets;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitRuleTargets(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class SourceTypeContext extends ParserRuleContext {
  IdentifierContext? identifier() => getRuleContext<IdentifierContext>(0);
  SourceTypeContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_sourceType;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitSourceType(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class SourceCardinalityContext extends ParserRuleContext {
  TerminalNode? INTEGER() => getToken(mappingParser.TOKEN_INTEGER, 0);
  UpperBoundContext? upperBound() => getRuleContext<UpperBoundContext>(0);
  SourceCardinalityContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_sourceCardinality;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitSourceCardinality(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class UpperBoundContext extends ParserRuleContext {
  TerminalNode? INTEGER() => getToken(mappingParser.TOKEN_INTEGER, 0);
  UpperBoundContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_upperBound;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitUpperBound(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class RuleCtxContext extends ParserRuleContext {
  List<IdentifierContext> identifiers() => getRuleContexts<IdentifierContext>();
  IdentifierContext? identifier(int i) => getRuleContext<IdentifierContext>(i);
  RuleCtxContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_ruleCtx;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitRuleCtx(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class SourceDefaultContext extends ParserRuleContext {
  FhirPathContext? fhirPath() => getRuleContext<FhirPathContext>(0);
  SourceDefaultContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_sourceDefault;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitSourceDefault(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class AliasContext extends ParserRuleContext {
  IdentifierContext? identifier() => getRuleContext<IdentifierContext>(0);
  AliasContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_alias;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitAlias(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class WhereClauseContext extends ParserRuleContext {
  FhirPathContext? fhirPath() => getRuleContext<FhirPathContext>(0);
  WhereClauseContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_whereClause;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitWhereClause(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class CheckClauseContext extends ParserRuleContext {
  FhirPathContext? fhirPath() => getRuleContext<FhirPathContext>(0);
  CheckClauseContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_checkClause;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitCheckClause(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class LogContext extends ParserRuleContext {
  FhirPathContext? fhirPath() => getRuleContext<FhirPathContext>(0);
  LogContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_log;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitLog(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class DependentContext extends ParserRuleContext {
  List<InvocationContext> invocations() => getRuleContexts<InvocationContext>();
  InvocationContext? invocation(int i) => getRuleContext<InvocationContext>(i);
  RulesContext? rules() => getRuleContext<RulesContext>(0);
  DependentContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_dependent;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitDependent(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class RuleTargetContext extends ParserRuleContext {
  RuleCtxContext? ruleCtx() => getRuleContext<RuleCtxContext>(0);
  TransformContext? transform() => getRuleContext<TransformContext>(0);
  AliasContext? alias() => getRuleContext<AliasContext>(0);
  TargetListModeContext? targetListMode() => getRuleContext<TargetListModeContext>(0);
  InvocationContext? invocation() => getRuleContext<InvocationContext>(0);
  RuleTargetContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_ruleTarget;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitRuleTarget(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class TransformContext extends ParserRuleContext {
  LiteralContext? literal() => getRuleContext<LiteralContext>(0);
  RuleCtxContext? ruleCtx() => getRuleContext<RuleCtxContext>(0);
  InvocationContext? invocation() => getRuleContext<InvocationContext>(0);
  TransformContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_transform;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitTransform(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class InvocationContext extends ParserRuleContext {
  IdentifierContext? identifier() => getRuleContext<IdentifierContext>(0);
  ParamListContext? paramList() => getRuleContext<ParamListContext>(0);
  InvocationContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_invocation;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitInvocation(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ParamListContext extends ParserRuleContext {
  List<ParamContext> params() => getRuleContexts<ParamContext>();
  ParamContext? param(int i) => getRuleContext<ParamContext>(i);
  ParamListContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_paramList;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitParamList(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ParamContext extends ParserRuleContext {
  LiteralContext? literal() => getRuleContext<LiteralContext>(0);
  TerminalNode? ID() => getToken(mappingParser.TOKEN_ID, 0);
  ParamContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_param;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitParam(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class FhirPathContext extends ParserRuleContext {
  LiteralContext? literal() => getRuleContext<LiteralContext>(0);
  FhirPathContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_fhirPath;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitFhirPath(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class LiteralContext extends ParserRuleContext {
  TerminalNode? INTEGER() => getToken(mappingParser.TOKEN_INTEGER, 0);
  TerminalNode? NUMBER() => getToken(mappingParser.TOKEN_NUMBER, 0);
  TerminalNode? STRING() => getToken(mappingParser.TOKEN_STRING, 0);
  TerminalNode? DATETIME() => getToken(mappingParser.TOKEN_DATETIME, 0);
  TerminalNode? DATE() => getToken(mappingParser.TOKEN_DATE, 0);
  TerminalNode? TIME() => getToken(mappingParser.TOKEN_TIME, 0);
  TerminalNode? BOOL() => getToken(mappingParser.TOKEN_BOOL, 0);
  LiteralContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_literal;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitLiteral(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class GroupTypeModeContext extends ParserRuleContext {
  GroupTypeModeContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_groupTypeMode;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitGroupTypeMode(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class SourceListModeContext extends ParserRuleContext {
  SourceListModeContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_sourceListMode;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitSourceListMode(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class TargetListModeContext extends ParserRuleContext {
  TargetListModeContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_targetListMode;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitTargetListMode(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class InputModeContext extends ParserRuleContext {
  InputModeContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_inputMode;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitInputMode(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class ModelModeContext extends ParserRuleContext {
  ModelModeContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_modelMode;
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is mappingVisitor<T>) {
     return visitor.visitModelMode(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

