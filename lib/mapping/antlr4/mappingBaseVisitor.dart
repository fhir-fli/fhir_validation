// Generated from mapping.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'mappingParser.dart';
import 'mappingVisitor.dart';

/// This class provides an empty implementation of [mappingVisitor],
/// which can be extended to create a visitor which only needs to handle
/// a subset of the available methods.
///
/// [T] is the return type of the visit operation. Use `void` for
/// operations with no return type.
class mappingBaseVisitor<T> extends ParseTreeVisitor<T>
    implements mappingVisitor<T> {
  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitStructureMap(StructureMapContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitIdentifier(IdentifierContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitMapId(MapIdContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitUrl(UrlContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitStructure(StructureContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitStructureAlias(StructureAliasContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitImports(ImportsContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitConst(ConstContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRules(RulesContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitGroup(GroupContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTypeMode(TypeModeContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitExtends(ExtendsContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParameters(ParametersContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParameter(ParameterContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitType(TypeContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitMappingRule(MappingRuleContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRuleName(RuleNameContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRuleSources(RuleSourcesContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRuleSource(RuleSourceContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRuleTargets(RuleTargetsContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSourceType(SourceTypeContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSourceCardinality(SourceCardinalityContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitUpperBound(UpperBoundContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRuleCtx(RuleCtxContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSourceDefault(SourceDefaultContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAlias(AliasContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitWhereClause(WhereClauseContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitCheckClause(CheckClauseContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLog(LogContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitDependent(DependentContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRuleTarget(RuleTargetContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTransform(TransformContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInvocation(InvocationContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParamList(ParamListContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParam(ParamContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitFhirPath(FhirPathContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLiteral(LiteralContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitGroupTypeMode(GroupTypeModeContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitSourceListMode(SourceListModeContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTargetListMode(TargetListModeContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitInputMode(InputModeContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitModelMode(ModelModeContext ctx) {
    print('${ctx.runtimeType}  ${ctx.text}');
    return visitChildren(ctx);
  }
}
