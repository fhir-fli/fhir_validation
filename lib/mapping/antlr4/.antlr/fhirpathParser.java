// Generated from /home/grey/dev/fhir/fhir_validation/lib/mapping/antlr4/fhirpath.g4 by ANTLR 4.13.1
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast", "CheckReturnValue"})
public class fhirpathParser extends Parser {
	static { RuntimeMetaData.checkVersion("4.13.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, LOGIC=14, COMP=15, BOOL=16, CONST=17, 
		STRING=18, NUMBER=19, CHOICE=20, ID=21, WS=22;
	public static final int
		RULE_prog = 0, RULE_line = 1, RULE_expr_no_binop = 2, RULE_expr = 3, RULE_binop_operator = 4, 
		RULE_binop = 5, RULE_predicate = 6, RULE_item = 7, RULE_element = 8, RULE_recurse = 9, 
		RULE_axis_spec = 10, RULE_function = 11, RULE_param_list = 12, RULE_fpconst = 13;
	private static String[] makeRuleNames() {
		return new String[] {
			"prog", "line", "expr_no_binop", "expr", "binop_operator", "binop", "predicate", 
			"item", "element", "recurse", "axis_spec", "function", "param_list", 
			"fpconst"
		};
	}
	public static final String[] ruleNames = makeRuleNames();

	private static String[] makeLiteralNames() {
		return new String[] {
			null, "'('", "')'", "':'", "'\\r'", "'\\n'", "'$context'", "'$resource'", 
			"'$parent'", "'.'", "'*'", "'**'", "','", "'-'", null, null, null, null, 
			null, null, "'[x]'"
		};
	}
	private static final String[] _LITERAL_NAMES = makeLiteralNames();
	private static String[] makeSymbolicNames() {
		return new String[] {
			null, null, null, null, null, null, null, null, null, null, null, null, 
			null, null, "LOGIC", "COMP", "BOOL", "CONST", "STRING", "NUMBER", "CHOICE", 
			"ID", "WS"
		};
	}
	private static final String[] _SYMBOLIC_NAMES = makeSymbolicNames();
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}

	@Override
	public String getGrammarFileName() { return "fhirpath.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public fhirpathParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@SuppressWarnings("CheckReturnValue")
	public static class ProgContext extends ParserRuleContext {
		public List<LineContext> line() {
			return getRuleContexts(LineContext.class);
		}
		public LineContext line(int i) {
			return getRuleContext(LineContext.class,i);
		}
		public ProgContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_prog; }
	}

	public final ProgContext prog() throws RecognitionException {
		ProgContext _localctx = new ProgContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_prog);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(28);
			line();
			setState(32);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ID) {
				{
				{
				setState(29);
				line();
				}
				}
				setState(34);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class LineContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(fhirpathParser.ID, 0); }
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public PredicateContext predicate() {
			return getRuleContext(PredicateContext.class,0);
		}
		public LineContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_line; }
	}

	public final LineContext line() throws RecognitionException {
		LineContext _localctx = new LineContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_line);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(35);
			match(ID);
			{
			setState(36);
			match(T__0);
			setState(37);
			predicate();
			setState(38);
			match(T__1);
			}
			setState(40);
			match(T__2);
			setState(41);
			expr();
			setState(43);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==T__3) {
				{
				setState(42);
				match(T__3);
				}
			}

			setState(45);
			match(T__4);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Expr_no_binopContext extends ParserRuleContext {
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public PredicateContext predicate() {
			return getRuleContext(PredicateContext.class,0);
		}
		public FpconstContext fpconst() {
			return getRuleContext(FpconstContext.class,0);
		}
		public Expr_no_binopContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expr_no_binop; }
	}

	public final Expr_no_binopContext expr_no_binop() throws RecognitionException {
		Expr_no_binopContext _localctx = new Expr_no_binopContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_expr_no_binop);
		try {
			setState(53);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,2,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(47);
				match(T__0);
				setState(48);
				expr();
				setState(49);
				match(T__1);
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(51);
				predicate();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(52);
				fpconst();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class ExprContext extends ParserRuleContext {
		public BinopContext binop() {
			return getRuleContext(BinopContext.class,0);
		}
		public Expr_no_binopContext expr_no_binop() {
			return getRuleContext(Expr_no_binopContext.class,0);
		}
		public ExprContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expr; }
	}

	public final ExprContext expr() throws RecognitionException {
		ExprContext _localctx = new ExprContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_expr);
		try {
			setState(57);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(55);
				binop();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(56);
				expr_no_binop();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Binop_operatorContext extends ParserRuleContext {
		public TerminalNode LOGIC() { return getToken(fhirpathParser.LOGIC, 0); }
		public TerminalNode COMP() { return getToken(fhirpathParser.COMP, 0); }
		public TerminalNode BOOL() { return getToken(fhirpathParser.BOOL, 0); }
		public Binop_operatorContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_binop_operator; }
	}

	public final Binop_operatorContext binop_operator() throws RecognitionException {
		Binop_operatorContext _localctx = new Binop_operatorContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_binop_operator);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(59);
			_la = _input.LA(1);
			if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & 114688L) != 0)) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class BinopContext extends ParserRuleContext {
		public List<Expr_no_binopContext> expr_no_binop() {
			return getRuleContexts(Expr_no_binopContext.class);
		}
		public Expr_no_binopContext expr_no_binop(int i) {
			return getRuleContext(Expr_no_binopContext.class,i);
		}
		public Binop_operatorContext binop_operator() {
			return getRuleContext(Binop_operatorContext.class,0);
		}
		public BinopContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_binop; }
	}

	public final BinopContext binop() throws RecognitionException {
		BinopContext _localctx = new BinopContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_binop);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(61);
			expr_no_binop();
			setState(62);
			binop_operator();
			setState(63);
			expr_no_binop();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class PredicateContext extends ParserRuleContext {
		public List<ItemContext> item() {
			return getRuleContexts(ItemContext.class);
		}
		public ItemContext item(int i) {
			return getRuleContext(ItemContext.class,i);
		}
		public PredicateContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_predicate; }
	}

	public final PredicateContext predicate() throws RecognitionException {
		PredicateContext _localctx = new PredicateContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_predicate);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(69);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case T__5:
				{
				setState(65);
				match(T__5);
				}
				break;
			case T__6:
				{
				setState(66);
				match(T__6);
				}
				break;
			case T__7:
				{
				setState(67);
				match(T__7);
				}
				break;
			case T__0:
			case T__9:
			case T__10:
			case ID:
				{
				setState(68);
				item();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			setState(75);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__8) {
				{
				{
				setState(71);
				match(T__8);
				setState(72);
				item();
				}
				}
				setState(77);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class ItemContext extends ParserRuleContext {
		public ElementContext element() {
			return getRuleContext(ElementContext.class,0);
		}
		public RecurseContext recurse() {
			return getRuleContext(RecurseContext.class,0);
		}
		public FunctionContext function() {
			return getRuleContext(FunctionContext.class,0);
		}
		public Axis_specContext axis_spec() {
			return getRuleContext(Axis_specContext.class,0);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public ItemContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_item; }
	}

	public final ItemContext item() throws RecognitionException {
		ItemContext _localctx = new ItemContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_item);
		int _la;
		try {
			setState(88);
			_errHandler.sync(this);
			switch ( getInterpreter().adaptivePredict(_input,7,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(78);
				element();
				setState(80);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__9) {
					{
					setState(79);
					recurse();
					}
				}

				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(82);
				function();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(83);
				axis_spec();
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(84);
				match(T__0);
				setState(85);
				expr();
				setState(86);
				match(T__1);
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class ElementContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(fhirpathParser.ID, 0); }
		public TerminalNode CHOICE() { return getToken(fhirpathParser.CHOICE, 0); }
		public ElementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_element; }
	}

	public final ElementContext element() throws RecognitionException {
		ElementContext _localctx = new ElementContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_element);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(90);
			match(ID);
			setState(92);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if (_la==CHOICE) {
				{
				setState(91);
				match(CHOICE);
				}
			}

			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class RecurseContext extends ParserRuleContext {
		public RecurseContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_recurse; }
	}

	public final RecurseContext recurse() throws RecognitionException {
		RecurseContext _localctx = new RecurseContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_recurse);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(94);
			match(T__9);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Axis_specContext extends ParserRuleContext {
		public Axis_specContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_axis_spec; }
	}

	public final Axis_specContext axis_spec() throws RecognitionException {
		Axis_specContext _localctx = new Axis_specContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_axis_spec);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(96);
			_la = _input.LA(1);
			if ( !(_la==T__9 || _la==T__10) ) {
			_errHandler.recoverInline(this);
			}
			else {
				if ( _input.LA(1)==Token.EOF ) matchedEOF = true;
				_errHandler.reportMatch(this);
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class FunctionContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(fhirpathParser.ID, 0); }
		public Param_listContext param_list() {
			return getRuleContext(Param_listContext.class,0);
		}
		public FunctionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_function; }
	}

	public final FunctionContext function() throws RecognitionException {
		FunctionContext _localctx = new FunctionContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_function);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(98);
			match(ID);
			setState(99);
			match(T__0);
			setState(101);
			_errHandler.sync(this);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & 3091906L) != 0)) {
				{
				setState(100);
				param_list();
				}
			}

			setState(103);
			match(T__1);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class Param_listContext extends ParserRuleContext {
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public Param_listContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_param_list; }
	}

	public final Param_listContext param_list() throws RecognitionException {
		Param_listContext _localctx = new Param_listContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_param_list);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(105);
			expr();
			setState(110);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__11) {
				{
				{
				setState(106);
				match(T__11);
				setState(107);
				expr();
				}
				}
				setState(112);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	@SuppressWarnings("CheckReturnValue")
	public static class FpconstContext extends ParserRuleContext {
		public TerminalNode STRING() { return getToken(fhirpathParser.STRING, 0); }
		public TerminalNode NUMBER() { return getToken(fhirpathParser.NUMBER, 0); }
		public TerminalNode BOOL() { return getToken(fhirpathParser.BOOL, 0); }
		public TerminalNode CONST() { return getToken(fhirpathParser.CONST, 0); }
		public FpconstContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_fpconst; }
	}

	public final FpconstContext fpconst() throws RecognitionException {
		FpconstContext _localctx = new FpconstContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_fpconst);
		int _la;
		try {
			setState(120);
			_errHandler.sync(this);
			switch (_input.LA(1)) {
			case STRING:
				enterOuterAlt(_localctx, 1);
				{
				setState(113);
				match(STRING);
				}
				break;
			case T__12:
			case NUMBER:
				enterOuterAlt(_localctx, 2);
				{
				setState(115);
				_errHandler.sync(this);
				_la = _input.LA(1);
				if (_la==T__12) {
					{
					setState(114);
					match(T__12);
					}
				}

				setState(117);
				match(NUMBER);
				}
				break;
			case BOOL:
				enterOuterAlt(_localctx, 3);
				{
				setState(118);
				match(BOOL);
				}
				break;
			case CONST:
				enterOuterAlt(_localctx, 4);
				{
				setState(119);
				match(CONST);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static final String _serializedATN =
		"\u0004\u0001\u0016{\u0002\u0000\u0007\u0000\u0002\u0001\u0007\u0001\u0002"+
		"\u0002\u0007\u0002\u0002\u0003\u0007\u0003\u0002\u0004\u0007\u0004\u0002"+
		"\u0005\u0007\u0005\u0002\u0006\u0007\u0006\u0002\u0007\u0007\u0007\u0002"+
		"\b\u0007\b\u0002\t\u0007\t\u0002\n\u0007\n\u0002\u000b\u0007\u000b\u0002"+
		"\f\u0007\f\u0002\r\u0007\r\u0001\u0000\u0001\u0000\u0005\u0000\u001f\b"+
		"\u0000\n\u0000\f\u0000\"\t\u0000\u0001\u0001\u0001\u0001\u0001\u0001\u0001"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0001\u0003\u0001,\b"+
		"\u0001\u0001\u0001\u0001\u0001\u0001\u0002\u0001\u0002\u0001\u0002\u0001"+
		"\u0002\u0001\u0002\u0001\u0002\u0003\u00026\b\u0002\u0001\u0003\u0001"+
		"\u0003\u0003\u0003:\b\u0003\u0001\u0004\u0001\u0004\u0001\u0005\u0001"+
		"\u0005\u0001\u0005\u0001\u0005\u0001\u0006\u0001\u0006\u0001\u0006\u0001"+
		"\u0006\u0003\u0006F\b\u0006\u0001\u0006\u0001\u0006\u0005\u0006J\b\u0006"+
		"\n\u0006\f\u0006M\t\u0006\u0001\u0007\u0001\u0007\u0003\u0007Q\b\u0007"+
		"\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007\u0001\u0007"+
		"\u0003\u0007Y\b\u0007\u0001\b\u0001\b\u0003\b]\b\b\u0001\t\u0001\t\u0001"+
		"\n\u0001\n\u0001\u000b\u0001\u000b\u0001\u000b\u0003\u000bf\b\u000b\u0001"+
		"\u000b\u0001\u000b\u0001\f\u0001\f\u0001\f\u0005\fm\b\f\n\f\f\fp\t\f\u0001"+
		"\r\u0001\r\u0003\rt\b\r\u0001\r\u0001\r\u0001\r\u0003\ry\b\r\u0001\r\u0000"+
		"\u0000\u000e\u0000\u0002\u0004\u0006\b\n\f\u000e\u0010\u0012\u0014\u0016"+
		"\u0018\u001a\u0000\u0002\u0001\u0000\u000e\u0010\u0001\u0000\n\u000b\u0080"+
		"\u0000\u001c\u0001\u0000\u0000\u0000\u0002#\u0001\u0000\u0000\u0000\u0004"+
		"5\u0001\u0000\u0000\u0000\u00069\u0001\u0000\u0000\u0000\b;\u0001\u0000"+
		"\u0000\u0000\n=\u0001\u0000\u0000\u0000\fE\u0001\u0000\u0000\u0000\u000e"+
		"X\u0001\u0000\u0000\u0000\u0010Z\u0001\u0000\u0000\u0000\u0012^\u0001"+
		"\u0000\u0000\u0000\u0014`\u0001\u0000\u0000\u0000\u0016b\u0001\u0000\u0000"+
		"\u0000\u0018i\u0001\u0000\u0000\u0000\u001ax\u0001\u0000\u0000\u0000\u001c"+
		" \u0003\u0002\u0001\u0000\u001d\u001f\u0003\u0002\u0001\u0000\u001e\u001d"+
		"\u0001\u0000\u0000\u0000\u001f\"\u0001\u0000\u0000\u0000 \u001e\u0001"+
		"\u0000\u0000\u0000 !\u0001\u0000\u0000\u0000!\u0001\u0001\u0000\u0000"+
		"\u0000\" \u0001\u0000\u0000\u0000#$\u0005\u0015\u0000\u0000$%\u0005\u0001"+
		"\u0000\u0000%&\u0003\f\u0006\u0000&\'\u0005\u0002\u0000\u0000\'(\u0001"+
		"\u0000\u0000\u0000()\u0005\u0003\u0000\u0000)+\u0003\u0006\u0003\u0000"+
		"*,\u0005\u0004\u0000\u0000+*\u0001\u0000\u0000\u0000+,\u0001\u0000\u0000"+
		"\u0000,-\u0001\u0000\u0000\u0000-.\u0005\u0005\u0000\u0000.\u0003\u0001"+
		"\u0000\u0000\u0000/0\u0005\u0001\u0000\u000001\u0003\u0006\u0003\u0000"+
		"12\u0005\u0002\u0000\u000026\u0001\u0000\u0000\u000036\u0003\f\u0006\u0000"+
		"46\u0003\u001a\r\u00005/\u0001\u0000\u0000\u000053\u0001\u0000\u0000\u0000"+
		"54\u0001\u0000\u0000\u00006\u0005\u0001\u0000\u0000\u00007:\u0003\n\u0005"+
		"\u00008:\u0003\u0004\u0002\u000097\u0001\u0000\u0000\u000098\u0001\u0000"+
		"\u0000\u0000:\u0007\u0001\u0000\u0000\u0000;<\u0007\u0000\u0000\u0000"+
		"<\t\u0001\u0000\u0000\u0000=>\u0003\u0004\u0002\u0000>?\u0003\b\u0004"+
		"\u0000?@\u0003\u0004\u0002\u0000@\u000b\u0001\u0000\u0000\u0000AF\u0005"+
		"\u0006\u0000\u0000BF\u0005\u0007\u0000\u0000CF\u0005\b\u0000\u0000DF\u0003"+
		"\u000e\u0007\u0000EA\u0001\u0000\u0000\u0000EB\u0001\u0000\u0000\u0000"+
		"EC\u0001\u0000\u0000\u0000ED\u0001\u0000\u0000\u0000FK\u0001\u0000\u0000"+
		"\u0000GH\u0005\t\u0000\u0000HJ\u0003\u000e\u0007\u0000IG\u0001\u0000\u0000"+
		"\u0000JM\u0001\u0000\u0000\u0000KI\u0001\u0000\u0000\u0000KL\u0001\u0000"+
		"\u0000\u0000L\r\u0001\u0000\u0000\u0000MK\u0001\u0000\u0000\u0000NP\u0003"+
		"\u0010\b\u0000OQ\u0003\u0012\t\u0000PO\u0001\u0000\u0000\u0000PQ\u0001"+
		"\u0000\u0000\u0000QY\u0001\u0000\u0000\u0000RY\u0003\u0016\u000b\u0000"+
		"SY\u0003\u0014\n\u0000TU\u0005\u0001\u0000\u0000UV\u0003\u0006\u0003\u0000"+
		"VW\u0005\u0002\u0000\u0000WY\u0001\u0000\u0000\u0000XN\u0001\u0000\u0000"+
		"\u0000XR\u0001\u0000\u0000\u0000XS\u0001\u0000\u0000\u0000XT\u0001\u0000"+
		"\u0000\u0000Y\u000f\u0001\u0000\u0000\u0000Z\\\u0005\u0015\u0000\u0000"+
		"[]\u0005\u0014\u0000\u0000\\[\u0001\u0000\u0000\u0000\\]\u0001\u0000\u0000"+
		"\u0000]\u0011\u0001\u0000\u0000\u0000^_\u0005\n\u0000\u0000_\u0013\u0001"+
		"\u0000\u0000\u0000`a\u0007\u0001\u0000\u0000a\u0015\u0001\u0000\u0000"+
		"\u0000bc\u0005\u0015\u0000\u0000ce\u0005\u0001\u0000\u0000df\u0003\u0018"+
		"\f\u0000ed\u0001\u0000\u0000\u0000ef\u0001\u0000\u0000\u0000fg\u0001\u0000"+
		"\u0000\u0000gh\u0005\u0002\u0000\u0000h\u0017\u0001\u0000\u0000\u0000"+
		"in\u0003\u0006\u0003\u0000jk\u0005\f\u0000\u0000km\u0003\u0006\u0003\u0000"+
		"lj\u0001\u0000\u0000\u0000mp\u0001\u0000\u0000\u0000nl\u0001\u0000\u0000"+
		"\u0000no\u0001\u0000\u0000\u0000o\u0019\u0001\u0000\u0000\u0000pn\u0001"+
		"\u0000\u0000\u0000qy\u0005\u0012\u0000\u0000rt\u0005\r\u0000\u0000sr\u0001"+
		"\u0000\u0000\u0000st\u0001\u0000\u0000\u0000tu\u0001\u0000\u0000\u0000"+
		"uy\u0005\u0013\u0000\u0000vy\u0005\u0010\u0000\u0000wy\u0005\u0011\u0000"+
		"\u0000xq\u0001\u0000\u0000\u0000xs\u0001\u0000\u0000\u0000xv\u0001\u0000"+
		"\u0000\u0000xw\u0001\u0000\u0000\u0000y\u001b\u0001\u0000\u0000\u0000"+
		"\r +59EKPX\\ensx";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}