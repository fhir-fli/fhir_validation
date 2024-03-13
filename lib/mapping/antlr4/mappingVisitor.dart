// Generated from mapping.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'mappingParser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [mappingParser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class mappingVisitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [mappingParser.structureMap].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStructureMap(StructureMapContext ctx);

  /// Visit a parse tree produced by [mappingParser.identifier].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIdentifier(IdentifierContext ctx);

  /// Visit a parse tree produced by [mappingParser.mapId].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitMapId(MapIdContext ctx);

  /// Visit a parse tree produced by [mappingParser.url].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitUrl(UrlContext ctx);

  /// Visit a parse tree produced by [mappingParser.structure].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStructure(StructureContext ctx);

  /// Visit a parse tree produced by [mappingParser.structureAlias].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStructureAlias(StructureAliasContext ctx);

  /// Visit a parse tree produced by [mappingParser.imports].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitImports(ImportsContext ctx);

  /// Visit a parse tree produced by [mappingParser.const].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConst(ConstContext ctx);

  /// Visit a parse tree produced by [mappingParser.rules].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRules(RulesContext ctx);

  /// Visit a parse tree produced by [mappingParser.group].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitGroup(GroupContext ctx);

  /// Visit a parse tree produced by [mappingParser.typeMode].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTypeMode(TypeModeContext ctx);

  /// Visit a parse tree produced by [mappingParser.extends].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExtends(ExtendsContext ctx);

  /// Visit a parse tree produced by [mappingParser.parameters].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParameters(ParametersContext ctx);

  /// Visit a parse tree produced by [mappingParser.parameter].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParameter(ParameterContext ctx);

  /// Visit a parse tree produced by [mappingParser.type].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitType(TypeContext ctx);

  /// Visit a parse tree produced by [mappingParser.mappingRule].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitMappingRule(MappingRuleContext ctx);

  /// Visit a parse tree produced by [mappingParser.ruleName].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRuleName(RuleNameContext ctx);

  /// Visit a parse tree produced by [mappingParser.ruleSources].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRuleSources(RuleSourcesContext ctx);

  /// Visit a parse tree produced by [mappingParser.ruleSource].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRuleSource(RuleSourceContext ctx);

  /// Visit a parse tree produced by [mappingParser.ruleTargets].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRuleTargets(RuleTargetsContext ctx);

  /// Visit a parse tree produced by [mappingParser.sourceType].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSourceType(SourceTypeContext ctx);

  /// Visit a parse tree produced by [mappingParser.sourceCardinality].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSourceCardinality(SourceCardinalityContext ctx);

  /// Visit a parse tree produced by [mappingParser.upperBound].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitUpperBound(UpperBoundContext ctx);

  /// Visit a parse tree produced by [mappingParser.ruleCtx].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRuleCtx(RuleCtxContext ctx);

  /// Visit a parse tree produced by [mappingParser.sourceDefault].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSourceDefault(SourceDefaultContext ctx);

  /// Visit a parse tree produced by [mappingParser.alias].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAlias(AliasContext ctx);

  /// Visit a parse tree produced by [mappingParser.whereClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitWhereClause(WhereClauseContext ctx);

  /// Visit a parse tree produced by [mappingParser.checkClause].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitCheckClause(CheckClauseContext ctx);

  /// Visit a parse tree produced by [mappingParser.log].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLog(LogContext ctx);

  /// Visit a parse tree produced by [mappingParser.dependent].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitDependent(DependentContext ctx);

  /// Visit a parse tree produced by [mappingParser.ruleTarget].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRuleTarget(RuleTargetContext ctx);

  /// Visit a parse tree produced by [mappingParser.transform].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTransform(TransformContext ctx);

  /// Visit a parse tree produced by [mappingParser.invocation].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInvocation(InvocationContext ctx);

  /// Visit a parse tree produced by [mappingParser.paramList].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParamList(ParamListContext ctx);

  /// Visit a parse tree produced by [mappingParser.param].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParam(ParamContext ctx);

  /// Visit a parse tree produced by [mappingParser.fhirPath].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFhirPath(FhirPathContext ctx);

  /// Visit a parse tree produced by [mappingParser.literal].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLiteral(LiteralContext ctx);

  /// Visit a parse tree produced by [mappingParser.groupTypeMode].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitGroupTypeMode(GroupTypeModeContext ctx);

  /// Visit a parse tree produced by [mappingParser.sourceListMode].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSourceListMode(SourceListModeContext ctx);

  /// Visit a parse tree produced by [mappingParser.targetListMode].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTargetListMode(TargetListModeContext ctx);

  /// Visit a parse tree produced by [mappingParser.inputMode].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitInputMode(InputModeContext ctx);

  /// Visit a parse tree produced by [mappingParser.modelMode].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitModelMode(ModelModeContext ctx);
}