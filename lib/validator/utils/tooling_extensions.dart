

import 'package:fhir_primitives/fhir_primitives.dart';
import 'package:fhir_r5/fhir_r5.dart' as r5;

import '../validation.dart';

class ToolingFhirExtensions {

  static final String EXT_ISSUE_MSG_ID = "http://hl7.org/fhir/StructureDefinition/operationoutcome-message-id";
  static final String EXT_ISSUE_LINE = "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line";
  static final String EXT_ISSUE_COL = "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col";
  static final String EXT_OO_FILE = "http://hl7.org/fhir/StructureDefinition/operationoutcome-file";  
  static final String EXT_RESOURCE_IMPLEMENTS = "http://hl7.org/fhir/StructureDefinition/structuredefinition-implements";
  static final String EXT_XML_TYPE = "http://hl7.org/fhir/StructureDefinition/structuredefinition-xml-type"; // r2 - r3
  static final String EXT_XML_NAME_DEPRECATED = "http://hl7.org/fhir/StructureDefinition/elementdefinition-xml-name";  
  static final String EXT_XML_NAME = "http://hl7.org/fhir/tools/StructureDefinition/xml-name";  
  static final String EXT_EXPLICIT_TYPE = "http://hl7.org/fhir/StructureDefinition/structuredefinition-explicit-type-name";

  static final String EXT_IGP_RESOURCES = "http://hl7.org/fhir/StructureDefinition/igpublisher-folder-resource";
  static final String EXT_IGP_PAGES = "http://hl7.org/fhir/StructureDefinition/igpublisher-folder-pages"; 
  static final String EXT_IGP_SPREADSHEET = "http://hl7.org/fhir/StructureDefinition/igpublisher-spreadsheet";
  static final String EXT_IGP_MAPPING_CSV = "http://hl7.org/fhir/StructureDefinition/igpublisher-mapping-csv";
  static final String EXT_IGP_BUNDLE = "http://hl7.org/fhir/tools/StructureDefinition/igpublisher-bundle";
  static final String EXT_IGP_BASE = "http://hl7.org/fhir/StructureDefinition/igpublisher-res-base";
  static final String EXT_IGP_DEFNS = "http://hl7.org/fhir/StructureDefinition/igpublisher-res-defns";
  static final String EXT_IGP_FORMAT = "http://hl7.org/fhir/StructureDefinition/igpublisher-res-format";
  static final String EXT_IGP_SOURCE = "http://hl7.org/fhir/StructureDefinition/igpublisher-res-source";
  static final String EXT_IGP_CONTAINED_RESOURCE_INFO = "http://hl7.org/fhir/tools/StructureDefinition/contained-resource-information";
  static final String EXT_BINARY_FORMAT_OLD = "http://hl7.org/fhir/StructureDefinition/implementationguide-resource-format";
  static final String EXT_BINARY_FORMAT_NEW = "http://hl7.org/fhir/tools/StructureDefinition/implementationguide-resource-format";
  static final String EXT_BINARY_LOGICAL = "http://hl7.org/fhir/tools/StructureDefinition/implementationguide-resource-logical";
  static final String EXT_IGP_RESOURCE_INFO = "http://hl7.org/fhir/tools/StructureDefinition/resource-information";
  static final String EXT_IGP_LOADVERSION = "http://hl7.org/fhir/StructureDefinition/igpublisher-loadversion";
  static final String EXT_LIST_PACKAGE = "http://hl7.org/fhir/StructureDefinition/list-packageId";
  static final String EXT_JSON_NAME_DEPRECATED = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-json-name";   
  static final String EXT_JSON_NAME = "http://hl7.org/fhir/tools/StructureDefinition/json-name";  
  static final String EXT_BINDING_STYLE = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-binding-style";
  static final String EXT_EXTENSION_STYLE = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-extension-style";
  static final String EXT_LOGICAL_TARGET = "http://hl7.org/fhir/tools/StructureDefinition/logical-target";
  static final String EXT_PROFILE_MAPPING = "http://hl7.org/fhir/tools/StructureDefinition/profile-mapping";
  static final String EXT_CS_ALTERNATE_USE = "http://hl7.org/fhir/StructureDefinition/alternate-code-use";
  static final String EXT_CS_ALTERNATE_STATUS = "http://hl7.org/fhir/StructureDefinition/alternate-code-status";
  static final String EXT_OBLIGATION_PROFILE_FLAG = "http://hl7.org/fhir/tools/StructureDefinition/obligation-profile";
  static final String EXT_OBLIGATION_INHERITS = "http://hl7.org/fhir/tools/StructureDefinition/inherit-obligations";
  static final String EXT_DAR = "http://hl7.org/fhir/StructureDefinition/data-absent-reason";
  static final String EXT_NF = "http://hl7.org/fhir/StructureDefinition/iso21090-nullFlavor";
  static final String EXT_OT = "http://hl7.org/fhir/StructureDefinition/originalText";
  static final String EXT_CQF_EXP = "http://hl7.org/fhir/StructureDefinition/cqf-expression";

  static final String EXT_PATTERN = "http://hl7.org/fhir/StructureDefinition/elementdefinition-pattern";
  static final String EXT_ALLOWEDRESOURCE = "http://hl7.org/fhir/StructureDefinition/questionnaire-referenceResource";
  static final String EXT_ALLOWABLE_UNITS = "http://hl7.org/fhir/StructureDefinition/elementdefinition-allowedUnits";
  static final String EXT_FHIRTYPE = "http://hl7.org/fhir/StructureDefinition/questionnaire-fhirType";
  static final String EXT_ALLOWED_TYPE =  "http://hl7.org/fhir/StructureDefinition/operationdefinition-allowed-type";
  static final String EXT_BEST_PRACTICE = "http://hl7.org/fhir/StructureDefinition/elementdefinition-bestpractice"; 
  static final String EXT_BEST_PRACTICE_EXPLANATION = "http://hl7.org/fhir/StructureDefinition/elementdefinition-bestpractice-explanation"; 
  static final String EXT_BINDING_NAME = "http://hl7.org/fhir/StructureDefinition/elementdefinition-bindingName";
  static final String EXT_CONTROL = "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl";  
  static final String EXT_CS_COMMENT = "http://hl7.org/fhir/StructureDefinition/codesystem-concept-comments"; 
  static final String EXT_CS_KEYWORD = "http://hl7.org/fhir/StructureDefinition/codesystem-keyWord"; 
  static final String EXT_DEFINITION = "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition"; 
  static final String EXT_DISPLAY_HINT = "http://hl7.org/fhir/StructureDefinition/structuredefinition-display-hint";  
  static final String EXT_EXPAND_GROUP = "http://hl7.org/fhir/StructureDefinition/valueset-expand-group";
  static final String EXT_EXPAND_RULES = "http://hl7.org/fhir/StructureDefinition/valueset-expand-rules";
  static final String EXT_EXP_TOOCOSTLY = "http://hl7.org/fhir/StructureDefinition/valueset-toocostly";
  static final String EXT_FHIR_TYPE = "http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type";
  static final String EXT_FMM_DERIVED = "http://hl7.org/fhir/StructureDefinition/structuredefinition-conformance-derivedFrom";
  static final String EXT_FMM_LEVEL = "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm";
  static final String EXT_FMM_SUPPORT = "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm-support";
  static final String EXT_HIERARCHY = "http://hl7.org/fhir/StructureDefinition/structuredefinition-hierarchy"; 
  static final String EXT_ISSUE_SOURCE = "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-source";  
  static final String EXT_MAXOCCURS = "http://hl7.org/fhir/StructureDefinition/questionnaire-maxOccurs"; 
  static final String EXT_MAX_DECIMALS = "http://hl7.org/fhir/StructureDefinition/maxDecimalPlaces";
  static final String EXT_MAX_SIZE = "http://hl7.org/fhir/StructureDefinition/maxSize";
  static final String EXT_MAX_VALUESET = "http://hl7.org/fhir/StructureDefinition/elementdefinition-maxValueSet";
  static final String EXT_MINOCCURS = "http://hl7.org/fhir/StructureDefinition/questionnaire-minOccurs";  
  static final String EXT_MIN_LENGTH = "http://hl7.org/fhir/StructureDefinition/minLength";
  static final String EXT_MIN_VALUESET = "http://hl7.org/fhir/StructureDefinition/elementdefinition-minValueSet";
  static final String EXT_MUST_SUPPORT = "http://hl7.org/fhir/StructureDefinition/elementdefinition-type-must-support";
  static final String EXT_NORMATIVE_VERSION = "http://hl7.org/fhir/StructureDefinition/structuredefinition-normative-version";
  static final String EXT_PROFILE_ELEMENT = "http://hl7.org/fhir/StructureDefinition/elementdefinition-profile-element";
  static final String EXT_QTYPE = "http://hl7.org/fhir/StructureDefinition/questionnnaire-baseType";
  static final String EXT_Q_UNIT = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit";
  static final String EXT_REFERENCEFILTER = "http://hl7.org/fhir/StructureDefinition/questionnaire-referenceFilter"; 
  static final String EXT_REGEX = "http://hl7.org/fhir/StructureDefinition/regex";  
  static final String EXT_RENDERED_VALUE = "http://hl7.org/fhir/StructureDefinition/rendered-value";
  static final String EXT_REPLACED_BY = "http://hl7.org/fhir/StructureDefinition/codesystem-replacedby";
  static final String EXT_RESOURCE_CATEGORY = "http://hl7.org/fhir/StructureDefinition/structuredefinition-category";
  static final String EXT_RESOURCE_INTERFACE = "http://hl7.org/fhir/StructureDefinition/structuredefinition-interface";
  static final String EXT_SEC_CAT = "http://hl7.org/fhir/StructureDefinition/structuredefinition-security-category";
  static final String EXT_STANDARDS_STATUS = "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status";
  static final String EXT_STANDARDS_STATUS_REASON = "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status-reason";
  static final String EXT_TABLE_NAME = "http://hl7.org/fhir/StructureDefinition/structuredefinition-table-name";
  static final String EXT_TARGET_ID = "http://hl7.org/fhir/StructureDefinition/targetElement";
  static final String EXT_TARGET_PATH = "http://hl7.org/fhir/StructureDefinition/targetPath";
  static final String EXT_TRANSLATABLE = "http://hl7.org/fhir/StructureDefinition/elementdefinition-translatable";
  static final String EXT_TRANSLATION = "http://hl7.org/fhir/StructureDefinition/translation"; 
  static final String EXT_UNCLOSED = "http://hl7.org/fhir/StructureDefinition/valueset-unclosed";
  static final String EXT_VALUESET_SYSTEM = "http://hl7.org/fhir/StructureDefinition/valueset-system";
  static final String EXT_VS_COMMENT = "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments"; 
  static final String EXT_VS_KEYWORD = "http://hl7.org/fhir/StructureDefinition/valueset-keyWord";  
  static final String EXT_WORKGROUP = "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg";
  static final String EXT_XML_NAMESPACE_DEPRECATED = "http://hl7.org/fhir/StructureDefinition/elementdefinition-namespace";
  static final String EXT_XML_NAMESPACE = "http://hl7.org/fhir/tools/StructureDefinition/xml-namespace";
  static final String EXT_OLD_CONCEPTMAP_EQUIVALENCE = "http://hl7.org/fhir/1.0/StructureDefinition/extension-ConceptMap.element.target.equivalence";
  static final String EXT_Q_IS_SUBJ = "http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-isSubject"; 
  static final String EXT_Q_HIDDEN = "http://hl7.org/fhir/StructureDefinition/questionnaire-hidden";
  static final String EXT_Q_OTP_DISP = "http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-optionalDisplay"; 
  static final String EXT_O_LINK_PERIOD = "http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaire-observationLinkPeriod"; 
  static final String EXT_Q_CHOICE_ORIENT = "http://hl7.org/fhir/StructureDefinition/questionnaire-choiceOrientation";
  static final String EXT_Q_DISPLAY_CAT = "http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory";
  static final String EXT_REND_MD = "http://hl7.org/fhir/StructureDefinition/rendering-markdown";
  static final String EXT_CAP_STMT_EXPECT = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation";
  static final String EXT_ED_HEIRARCHY = "http://hl7.org/fhir/StructureDefinition/elementdefinition-heirarchy";
  static final String EXT_SD_IMPOSE_PROFILE = "http://hl7.org/fhir/StructureDefinition/structuredefinition-imposeProfile";
  static final String EXT_SD_COMPLIES_WITH_PROFILE = "http://hl7.org/fhir/StructureDefinition/structuredefinition-compliesWithProfile";
  static final String EXT_DEF_TYPE = "http://hl7.org/fhir/StructureDefinition/elementdefinition-defaulttype";
  static final String EXT_TYPE_SPEC = "http://hl7.org/fhir/tools/StructureDefinition/type-specifier";
  static final String EXT_TYPE_CHARACTERISTICS = "http://hl7.org/fhir/StructureDefinition/structuredefinition-type-characteristics";
  
  // in the tooling IG
  static final String EXT_PRIVATE_BASE = "http://hl7.org/fhir/tools/";
  static final String EXT_BINDING_ADDITIONAL = "http://hl7.org/fhir/tools/StructureDefinition/additional-binding";
  static final String EXT_JSON_PROP_KEY = "http://hl7.org/fhir/tools/StructureDefinition/json-property-key";
  static final String EXT_JSON_EMPTY = "http://hl7.org/fhir/tools/StructureDefinition/json-empty-behavior";
  static final String EXT_JSON_NULLABLE = "http://hl7.org/fhir/tools/StructureDefinition/json-nullable";
  static final String EXT_IMPLIED_PREFIX = "http://hl7.org/fhir/tools/StructureDefinition/implied-string-prefix";
  static final String EXT_DATE_FORMAT = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-date-format";
  static final String EXT_ID_EXPECTATION = "http://hl7.org/fhir/tools/StructureDefinition/id-expectation";
  static final String EXT_JSON_PRIMITIVE_CHOICE = "http://hl7.org/fhir/tools/StructureDefinition/json-primitive-choice";
  static final String EXT_SUMMARY = "http://hl7.org/fhir/StructureDefinition/structuredefinition-summary";
  static final String EXT_BINDING_DEFINITION = "http://hl7.org/fhir/tools/StructureDefinition/binding-definition";


  // unregistered? - don't know what these are used for 
  static final String EXT_MAPPING_PREFIX = "http://hl7.org/fhir/tools/StructureDefinition/logical-mapping-prefix";
  static final String EXT_MAPPING_SUFFIX = "http://hl7.org/fhir/tools/StructureDefinition/logical-mapping-suffix";

  // for the v2 mapping project 
  static final String EXT_MAPPING_NAME = "http://hl7.org/fhir/tools/StructureDefinition/conceptmap-source-name";
  static final String EXT_MAPPING_TYPE = "http://hl7.org/fhir/tools/StructureDefinition/conceptmap-source-type";
  static final String EXT_MAPPING_CARD = "http://hl7.org/fhir/tools/StructureDefinition/conceptmap-source-cardinality";
  static final String EXT_MAPPING_TGTTYPE = "http://hl7.org/fhir/tools/StructureDefinition/conceptmap-target-type";
  static final String EXT_MAPPING_TGTCARD = "http://hl7.org/fhir/tools/StructureDefinition/conceptmap-target-cardinality";
  
  static final String WEB_EXTENSION_STYLE = "http://build.fhir.org/ig/FHIR/fhir-tools-ig/format-extensions.html#extension-related-extensions";
  static final String WEB_BINDING_STYLE = "http://build.fhir.org/ig/FHIR/fhir-tools-ig/StructureDefinition-binding-style.html";
  static final String EXT_IGDEP_COMMENT = "http://hl7.org/fhir/tools/StructureDefinition/implementationguide-dependency-comment";
  static final String EXT_XPATH_CONSTRAINT = "http://hl7.org/fhir/4.0/StructureDefinition/extension-ElementDefinition.constraint.xpath";
  static final String EXT_OBLIGATION_TOOLS = "http://hl7.org/fhir/tools/StructureDefinition/obligation";
  static final String EXT_OBLIGATION_CORE = "http://hl7.org/fhir/StructureDefinition/obligation";
  static final String EXT_NO_BINDING = "http://hl7.org/fhir/tools/StructureDefinition/no-binding";
  static final String EXT_ID_CHOICE_GROUP = "http://hl7.org/fhir/tools/StructureDefinition/xml-choice-group";
  static final String EXT_DATE_RULES = "http://hl7.org/fhir/tools/StructureDefinition/elementdefinition-date-rules";
  static final String EXT_PROFILE_STYLE = "http://hl7.org/fhir/tools/StructureDefinition/type-profile-style";
  static final String EXT_RESOURCE_NAME = "http://hl7.org/fhir/StructureDefinition/resource-instance-name";
  static final String EXT_RESOURCE_DESC = "http://hl7.org/fhir/StructureDefinition/resource-instance-description";
  static final String EXT_ARTIFACT_NAME = "http://hl7.org/fhir/StructureDefinition/artifact-name";
  static final String EXT_ARTIFACT_DESC = "http://hl7.org/fhir/StructureDefinition/artifact-description";  
  static final String EXT_ED_SUPPRESS = "http://hl7.org/fhir/StructureDefinition/elementdefinition-suppress";
  
  // specific extension helpers

  static r5.FhirExtension makeIssueSource(Source source) {
    r5.FhirExtension ex = new r5.FhirExtension();
    // todo: write this up and get it published with the pack (and handle the redirect?)
    ex = ex.copyWith(url: FhirUri(EXT_ISSUE_SOURCE),valueString: source.toString());
    return ex;
  }

  static r5.FhirExtension makeIssueMessageId(String msgId) {
    r5.FhirExtension ex = new r5.FhirExtension();
    // todo: write this up and get it published with the pack (and handle the redirect?)
        ex = ex.copyWith(url: FhirUri(EXT_ISSUE_MSG_ID),valueCode: FhirCode(msgId));
    return ex;
  }

  static bool hasExtension(r5.Resource resource, String url) {
    return getExtension(resource, url) != null;
  }

  //  void addStringExtension(r5.Resource dr, String url, String content) {
  //    if (!StringUtils.isBlank(content)) {
  //      r5.FhirExtension ex = getExtension(dr, url);
  //      if (ex != null)
  //        ex.setValue(new StringType(content));
  //      else
  //        dr.getExtension().add(Factory.newExtension(url, new StringType(content), true));   
  //    }
  //  }

  void addMarkdownExtension(r5.Resource dr, String url, String content) {
    if (!StringUtils.isBlank(content)) {
      r5.FhirExtension ex = getExtension(dr, url);
      if (ex != null)
        ex.setValue(new StringType(content));
      else
        dr.getExtension().add(Factory.newExtension(url, new MarkdownType(content), true));   
    }
  }

  void addStringExtension(Element e, String url, String content) {
    if (!StringUtils.isBlank(content)) {
      r5.FhirExtension ex = getExtension(e, url);
      if (ex != null)
        ex.setValue(new StringType(content));
      else
        e.getExtension().add(Factory.newExtension(url, new StringType(content), true));   
    }
  }

  void addCodeExtension(Element e, String url, String content) {
    if (!StringUtils.isBlank(content)) {
      r5.FhirExtension ex = getExtension(e, url);
      if (ex != null)
        ex.setValue(new CodeType(content));
      else
        e.getExtension().add(Factory.newExtension(url, new CodeType(content), true));   
    }
  }

  void addStringExtension(r5.Resource e, String url, String content) {
    if (!StringUtils.isBlank(content)) {
      r5.FhirExtension ex = getExtension(e, url);
      if (ex != null)
        ex.setValue(new StringType(content));
      else
        e.getExtension().add(Factory.newExtension(url, new StringType(content), true));   
    }
  }


  void addBooleanExtension(Element e, String url, bool content) {
    r5.FhirExtension ex = getExtension(e, url);
    if (ex != null)
      ex.setValue(new BooleanType(content));
    else
      e.getExtension().add(Factory.newExtension(url, new BooleanType(content), true));   
  }

  void addBooleanExtension(r5.Resource e, String url, bool content) {
    r5.FhirExtension ex = getExtension(e, url);
    if (ex != null)
      ex.setValue(new BooleanType(content));
    else
      e.getExtension().add(Factory.newExtension(url, new BooleanType(content), true));   
  }

  void addIntegerExtension(r5.Resource dr, String url, int value) {
    r5.FhirExtension ex = getExtension(dr, url);
    if (ex != null)
      ex.setValue(new IntegerType(value));
    else
      dr.getExtension().add(Factory.newExtension(url, new IntegerType(value), true));   
  }

  void addCodeExtension(r5.Resource dr, String url, String value) {
    r5.FhirExtension ex = getExtension(dr, url);
    if (ex != null)
      ex.setValue(new CodeType(value));
    else
      dr.getExtension().add(Factory.newExtension(url, new CodeType(value), true));   
  }

  void addVSComment(ConceptSetComponent nc, String comment) {
    if (!StringUtils.isBlank(comment))
      nc.getExtension().add(Factory.newExtension(EXT_VS_COMMENT, Factory.newString_(comment), true));   
  }
  void addVSComment(ConceptReferenceComponent nc, String comment) {
    if (!StringUtils.isBlank(comment))
      nc.getExtension().add(Factory.newExtension(EXT_VS_COMMENT, Factory.newString_(comment), true));   
  }

  void addCSComment(ConceptDefinitionComponent nc, String comment) {
    if (!StringUtils.isBlank(comment))
      nc.getExtension().add(Factory.newExtension(EXT_CS_COMMENT, Factory.newString_(comment), true));   
  }

  //  void markDeprecated(Element nc) {
  //    setDeprecated(nc);   
  //  }
  //

  void addDefinition(Element nc, String definition) {
    if (!StringUtils.isBlank(definition))
      nc.getExtension().add(Factory.newExtension(EXT_DEFINITION, Factory.newString_(definition), true));   
  }

  void addDisplayHint(Element def, String hint) {
    if (!StringUtils.isBlank(hint))
      def.getExtension().add(Factory.newExtension(EXT_DISPLAY_HINT, Factory.newString_(hint), true));   
  }

  static String getDisplayHint(Element def) {
    return readStringExtension(def, EXT_DISPLAY_HINT);    
  }

  static String readStringExtension(Element c, String... uris) {
    for (String uri : uris) {
      if (hasExtension(c, uri)) {
        return readStringExtension(c, uri);
      }
    }
    return null;
  }
  static String readStringExtension(Element c, String uri) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(c, uri);
    if (ex == null)
      return null;
    if (ex.getValue() instanceof UriType)
      return ((UriType) ex.getValue()).getValue();
    if (ex.getValue() instanceof CanonicalType)
      return ((CanonicalType) ex.getValue()).getValue();
    if (ex.getValue() instanceof CodeType)
      return ((CodeType) ex.getValue()).getValue();
    if (ex.getValue() instanceof IntegerType)
      return ((IntegerType) ex.getValue()).asStringValue();
    if (ex.getValue() instanceof Integer64Type)
      return ((Integer64Type) ex.getValue()).asStringValue();
    if (ex.getValue() instanceof DecimalType)
      return ((DecimalType) ex.getValue()).asStringValue();
    if ((ex.getValue() instanceof MarkdownType))
      return ((MarkdownType) ex.getValue()).getValue();
    if ((ex.getValue() instanceof PrimitiveType))
      return ((PrimitiveType) ex.getValue()).primitiveValue();
    if (!(ex.getValue() instanceof StringType))
      return null;
    return ((StringType) ex.getValue()).getValue();
  }

  static String readStringExtension(r5.Resource c, String... uris) {
    for (String uri : uris) {
      if (hasExtension(c, uri)) {
        return readStringExtension(c, uri);
      }
    }
    return null;
  }
  static String readStringExtension(r5.Resource c, String uri) {
    r5.FhirExtension ex = getExtension(c, uri);
    if (ex == null)
      return null;
    if ((ex.getValue() instanceof StringType))
      return ((StringType) ex.getValue()).getValue();
    if ((ex.getValue() instanceof UriType))
      return ((UriType) ex.getValue()).getValue();
    if (ex.getValue() instanceof CodeType)
      return ((CodeType) ex.getValue()).getValue();
    if (ex.getValue() instanceof IntegerType)
      return ((IntegerType) ex.getValue()).asStringValue();
    if (ex.getValue() instanceof Integer64Type)
      return ((Integer64Type) ex.getValue()).asStringValue();
    if (ex.getValue() instanceof DecimalType)
      return ((DecimalType) ex.getValue()).asStringValue();
    if ((ex.getValue() instanceof MarkdownType))
      return ((MarkdownType) ex.getValue()).getValue();
    return null;
  }

  @SuppressWarnings("unchecked")
  static PrimitiveType<DataType> readPrimitiveExtension(r5.Resource c, String uri) {
    r5.FhirExtension ex = getExtension(c, uri);
    if (ex == null)
      return null;
    return (PrimitiveType<DataType>) ex.getValue();
  }

  static bool findStringExtension(Element c, String uri) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(c, uri);
    if (ex == null)
      return false;
    if (!(ex.getValue() instanceof StringType))
      return false;
    return !StringUtils.isBlank(((StringType) ex.getValue()).getValue());
  }

  static Boolean readBooleanExtension(Element c, String uri) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(c, uri);
    if (ex == null)
      return null;
    if (!(ex.getValue() instanceof BooleanType))
      return null;
    return ((BooleanType) ex.getValue()).getValue();
  }

  static bool findBooleanExtension(Element c, String uri) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(c, uri);
    if (ex == null)
      return false;
    if (!(ex.getValue() instanceof BooleanType))
      return false;
    return true;
  }

  static Boolean readBooleanExtension(r5.Resource c, String uri) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(c, uri);
    if (ex == null)
      return null;
    if (!(ex.getValue() instanceof BooleanType))
      return null;
    return ((BooleanType) ex.getValue()).getValue();
  }

  static bool readBoolExtension(r5.Resource c, String uri) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(c, uri);
    if (ex == null)
      return false;
    if (!(ex.getValue() instanceof BooleanType))
      return false;
    return ((BooleanType) ex.getValue()).getValue();
  }

  static bool readBoolExtension(Element e, String uri) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(e, uri);
    if (ex == null)
      return false;
    if (!(ex.getValue() instanceof BooleanType))
      return false;
    if (!(ex.getValue().hasPrimitiveValue()))
      return false;
    return ((BooleanType) ex.getValue()).getValue();
  }

  static bool findBooleanExtension(r5.Resource c, String uri) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(c, uri);
    if (ex == null)
      return false;
    if (!(ex.getValue() instanceof BooleanType))
      return false;
    return true;
  }

  static String getCSComment(ConceptDefinitionComponent c) {
    return readStringExtension(c, EXT_CS_COMMENT);    
  }
  //
  //  static Boolean getDeprecated(Element c) {
  //    return readBooleanExtension(c, EXT_DEPRECATED);    
  //  }

  static bool hasCSComment(ConceptDefinitionComponent c) {
    return findStringExtension(c, EXT_CS_COMMENT);    
  }

  //  static bool hasDeprecated(Element c) {
  //    return findBooleanExtension(c, EXT_DEPRECATED);    
  //  }

  void addFlyOver(QuestionnaireItemComponent item, String text, String linkId){
    if (!StringUtils.isBlank(text)) {
      QuestionnaireItemComponent display = item.addItem();
      display.setType(QuestionnaireItemType.DISPLAY);
      display.setText(text);
      display.setLinkId(linkId);
      display.getExtension().add(Factory.newExtension(EXT_CONTROL, Factory.newCodeableConcept("flyover", "http://hl7.org/fhir/questionnaire-item-control", "Fly-over"), true));
    }
  }

  void addMin(QuestionnaireItemComponent item, int min) {
    item.getExtension().add(Factory.newExtension(EXT_MINOCCURS, Factory.newInteger(min), true));
  }

  void addMax(QuestionnaireItemComponent item, int max) {
    item.getExtension().add(Factory.newExtension(EXT_MAXOCCURS, Factory.newInteger(max), true));
  }

  void addFhirType(QuestionnaireItemComponent group, String value) {
    group.getExtension().add(Factory.newExtension(EXT_FHIRTYPE, Factory.newString_(value), true));       
  }

  void addControl(QuestionnaireItemComponent group, String value) {
    group.getExtension().add(Factory.newExtension(EXT_CONTROL, Factory.newCodeableConcept(value, "http://hl7.org/fhir/questionnaire-item-control", value), true));
  }

  void addAllowedResource(QuestionnaireItemComponent group, String value) {
    group.getExtension().add(Factory.newExtension(EXT_ALLOWEDRESOURCE, Factory.newCode(value), true));       
  }

  void addReferenceFilter(QuestionnaireItemComponent group, String value) {
    group.getExtension().add(Factory.newExtension(EXT_REFERENCEFILTER, Factory.newString_(value), true));       
  }

  //  void addIdentifier(Element element, Identifier value) {
  //    element.getExtension().add(Factory.newExtension(EXT_IDENTIFIER, value, true));       
  //  }

  /**
   * @param name the identity of the extension of interest
   * @return The extension, if on this element, else null
   */
  static r5.FhirExtension? getExtension(r5.Resource resource, String name) {
    if (resource == null || name == null)
      return null;
    if (!resource.hasExtension())
      return null;
    for (r5.FhirExtension e : resource.getExtension()) {
      if (name.equals(e.getUrl()))
        return e;
    }
    return null;
  }

  static r5.FhirExtension getExtension(Element el, String name) {
    if (name == null)
      return null;
    if (!el.hasExtension())
      return null;
    for (r5.FhirExtension e : el.getExtension()) {
      if (name.equals(e.getUrl()))
        return e;
    }
    return null;
  }

  void setStringExtension(r5.Resource resource, String uri, String value) {
    if (Utilities.noString(value))
      return;
    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new StringType(value));
    else
      resource.getExtension().add(new r5.FhirExtension(uri).setValue(new StringType(value)));
  }

  void setStringExtension(Element resource, String uri, String value) {
    if (Utilities.noString(value))
      return;
    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new StringType(value));
    else
      resource.getExtension().add(new r5.FhirExtension(uri).setValue(new StringType(value)));
  }

  void setUriExtension(r5.Resource resource, String uri, String value) {
    if (Utilities.noString(value))
      return;
    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new UriType(value));
    else
      resource.getExtension().add(new r5.FhirExtension(uri).setValue(new UriType(value)));
  }

  void setUriExtension(Element resource, String uri, String value) {
    if (Utilities.noString(value))
      return;
    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new UriType(value));
    else
      resource.getExtension().add(new r5.FhirExtension(uri).setValue(new UriType(value)));
  }

  void setUrlExtension(r5.Resource resource, String uri, String value) {
    if (Utilities.noString(value))
      return;
    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new UrlType(value));
    else
      resource.getExtension().add(new r5.FhirExtension(uri).setValue(new UrlType(value)));
  }

  void setUrlExtension(Element resource, String uri, String value) {
    if (Utilities.noString(value))
      return;
    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new UrlType(value));
    else
      resource.getExtension().add(new r5.FhirExtension(uri).setValue(new UrlType(value)));
  }

  void setCodeExtension(r5.Resource resource, String uri, String value) {
    if (Utilities.noString(value))
      return;

    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new CodeType(value));
    else
      resource.getExtension().add(new r5.FhirExtension(uri).setValue(new CodeType(value)));
  }

  void setCodeExtensionMod(r5.Resource resource, String uri, String value) {
    if (Utilities.noString(value))
      return;

    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new CodeType(value));
    else
      resource.getModifierExtension().add(new r5.FhirExtension(uri).setValue(new CodeType(value)));
  }

  void setCodeExtensionMod(BackboneElement resource, String uri, String value) {
    if (Utilities.noString(value))
      return;

    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new CodeType(value));
    else
      resource.getModifierExtension().add(new r5.FhirExtension(uri).setValue(new CodeType(value)));
  }

  void setCodeExtension(Element element, String uri, String value) {
    if (Utilities.noString(value))
      return;

    r5.FhirExtension ext = getExtension(element, uri);
    if (ext != null)
      ext.setValue(new CodeType(value));
    else
      element.getExtension().add(new r5.FhirExtension(uri).setValue(new CodeType(value)));
  }

  void setIntegerExtension(r5.Resource resource, String uri, int value) {
    r5.FhirExtension ext = getExtension(resource, uri);
    if (ext != null)
      ext.setValue(new IntegerType(value));
    else
      resource.getExtension().add(new r5.FhirExtension(uri).setValue(new IntegerType(value)));
  }

  //  static String getOID(CodeSystem define) {
  //    return readStringExtension(define, EXT_OID);    
  //  }
  //
  //  static String getOID(ValueSet vs) {
  //    return readStringExtension(vs, EXT_OID);    
  //  }
  //
  //  void setOID(CodeSystem define, String oid) throws FHIRFormatError, URISyntaxException {
  //    if (!oid.startsWith("urn:oid:"))
  //      throw new FHIRFormatError("Error in OID format");
  //    if (oid.startsWith("urn:oid:urn:oid:"))
  //      throw new FHIRFormatError("Error in OID format");
  //    if (!hasExtension(define, EXT_OID))
  //    define.getExtension().add(Factory.newExtension(EXT_OID, Factory.newUri(oid), false));       
  //    else if (!oid.equals(readStringExtension(define, EXT_OID)))
  //      throw new Error("Attempt to assign multiple OIDs to a code system");
  //  }
  //  void setOID(ValueSet vs, String oid) throws FHIRFormatError, URISyntaxException {
  //    if (!oid.startsWith("urn:oid:"))
  //      throw new FHIRFormatError("Error in OID format");
  //    if (oid.startsWith("urn:oid:urn:oid:"))
  //      throw new FHIRFormatError("Error in OID format");
  //    if (!hasExtension(vs, EXT_OID))
  //    vs.getExtension().add(Factory.newExtension(EXT_OID, Factory.newUri(oid), false));       
  //    else if (!oid.equals(readStringExtension(vs, EXT_OID)))
  //      throw new Error("Attempt to assign multiple OIDs to value set "+vs.getName()+" ("+vs.getUrl()+"). Has "+readStringExtension(vs, EXT_OID)+", trying to add "+oid);
  //  }

  static bool hasLanguageTranslation(Element element, String lang) {
    for (r5.FhirExtension e : element.getExtension()) {
      if (e.getUrl().equals(EXT_TRANSLATION)) {
        r5.FhirExtension e1 = ExtensionHelper.getExtension(e, "lang");

        if (e1 != null && e1.getValue() instanceof CodeType && ((CodeType) e.getValue()).getValue().equals(lang))
          return true;
      }
    }
    return false;
  }

  static String getLanguageTranslation(Element element, String lang) {
    for (r5.FhirExtension e : element.getExtension()) {
      if (e.getUrl().equals(EXT_TRANSLATION)) {
        r5.FhirExtension e1 = ExtensionHelper.getExtension(e, "lang");

        if (e1 != null && e1.getValue() instanceof CodeType && ((CodeType) e.getValue()).getValue().equals(lang)) {
          e1 = ExtensionHelper.getExtension(e, "content");
          return ((StringType) e.getValue()).getValue();
        }
      }
    }
    return null;
  }

  void addLanguageTranslation(Element element, String lang, String value) {
    if (Utilities.noString(lang) || Utilities.noString(value))
      return;

    r5.FhirExtension extension = new r5.FhirExtension().setUrl(EXT_TRANSLATION);
    extension.addExtension().setUrl("lang").setValue(new CodeType(lang));
    extension.addExtension().setUrl("content").setValue(new StringType(value));
    element.getExtension().add(extension);
  }

  static bool hasAllowedUnits(ElementDefinition eld) {
    for (r5.FhirExtension e : eld.getExtension()) 
      if (e.getUrl().equals(EXT_ALLOWABLE_UNITS)) 
        return true;
    return false;
  }

  static DataType getAllowedUnits(ElementDefinition eld) {
    for (r5.FhirExtension e : eld.getExtension()) 
      if (e.getUrl().equals(EXT_ALLOWABLE_UNITS)) 
        return e.getValue();
    return null;
  }

  void setAllowableUnits(ElementDefinition eld, CodeableConcept cc) {
    for (r5.FhirExtension e : eld.getExtension()) 
      if (e.getUrl().equals(EXT_ALLOWABLE_UNITS)) {
        e.setValue(cc);
        return;
      }
    eld.getExtension().add(new r5.FhirExtension().setUrl(EXT_ALLOWABLE_UNITS).setValue(cc));
  }

  static List<r5.FhirExtension> getExtensions(Element element, String url) {
    List<r5.FhirExtension> results = new ArrayList<r5.FhirExtension>();
    for (r5.FhirExtension ex : element.getExtension())
      if (ex.getUrl().equals(url))
        results.add(ex);
    return results;
  }

  static List<r5.FhirExtension> getExtensions(r5.Resource resource, String url) {
    List<r5.FhirExtension> results = new ArrayList<r5.FhirExtension>();
    for (r5.FhirExtension ex : resource.getExtension())
      if (ex.getUrl().equals(url))
        results.add(ex);
    return results;
  }

  //  void addDEReference(DataElement de, String value) {
  //    for (r5.FhirExtension e : de.getExtension()) 
  //      if (e.getUrl().equals(EXT_CIMI_REFERENCE)) {
  //        e.setValue(new UriType(value));
  //        return;
  //      }
  //    de.getExtension().add(new r5.FhirExtension().setUrl(EXT_CIMI_REFERENCE).setValue(new UriType(value)));
  //  }

  //  void setDeprecated(Element nc) {
  //    for (r5.FhirExtension e : nc.getExtension()) 
  //      if (e.getUrl().equals(EXT_DEPRECATED)) {
  //        e.setValue(new BooleanType(true));
  //        return;
  //      }
  //    nc.getExtension().add(new r5.FhirExtension().setUrl(EXT_DEPRECATED).setValue(new BooleanType(true)));    
  //  }

  void setExtension(Element focus, String url, Coding c) {
    for (r5.FhirExtension e : focus.getExtension()) 
      if (e.getUrl().equals(url)) {
        e.setValue(c);
        return;
      }
    focus.getExtension().add(new r5.FhirExtension().setUrl(url).setValue(c));    
  }

  void removeExtension(r5.Resource focus, String url) {
    Iterator<r5.FhirExtension> i = focus.getExtension().iterator();
    while (i.hasNext()) {
      r5.FhirExtension e = i.next(); // must be called before you can call i.remove()
      if (e.getUrl().equals(url)) {
        i.remove();
      }
    }
  }

  void removeExtension(Element focus, String url) {
    Iterator<r5.FhirExtension> i = focus.getExtension().iterator();
    while (i.hasNext()) {
      r5.FhirExtension e = i.next(); // must be called before you can call i.remove()
      if (e.getUrl().equals(url)) {
        i.remove();
      }
    }
  }

  static int readIntegerExtension(r5.Resource dr, String uri, int defaultValue) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(dr, uri);
    if (ex == null)
      return defaultValue;
    if (ex.getValue() instanceof IntegerType)
      return ((IntegerType) ex.getValue()).getValue();
    throw new Error("Unable to read extension "+uri+" as an integer");
  }

  static int readIntegerExtension(Element e, String uri, int defaultValue) {
    r5.FhirExtension ex = ExtensionHelper.getExtension(e, uri);
    if (ex == null)
      return defaultValue;
    if (ex.getValue() instanceof IntegerType)
      return ((IntegerType) ex.getValue()).getValue();
    throw new Error("Unable to read extension "+uri+" as an integer");
  }

  static Map<String, String> getLanguageTranslations(Element e) {
    Map<String, String> res = new HashMap<String, String>();
    for (r5.FhirExtension ext : e.getExtension()) {
      if (ext.getUrl().equals(EXT_TRANSLATION)) {
        String lang = readStringExtension(ext, "lang");
        String value = readStringExtension(ext, "content");
        res.put(lang,  value);
      }
    }
    return res;
  }

  static StandardsStatus getStandardsStatus(r5.Resource dr) throws FHIRException {
    return StandardsStatus.fromCode(readStringExtension(dr, EXT_STANDARDS_STATUS));
  }

  static StandardsStatus getStandardsStatus(Element e) throws FHIRException {
    return StandardsStatus.fromCode(readStringExtension(e, EXT_STANDARDS_STATUS));
  }

  void setStandardsStatus(r5.Resource dr, StandardsStatus status, String normativeVersion) {
    if (status == null)
      removeExtension(dr, EXT_STANDARDS_STATUS);
    else
      setCodeExtension(dr, EXT_STANDARDS_STATUS, status.toCode());
    if (normativeVersion == null)
      removeExtension(dr, EXT_NORMATIVE_VERSION);
    else
      setCodeExtension(dr, EXT_NORMATIVE_VERSION, normativeVersion);
  }

  void setStandardsStatus(Element dr, StandardsStatus status, String normativeVersion) {
    if (status == null)
      removeExtension(dr, EXT_STANDARDS_STATUS);
    else
      setCodeExtension(dr, EXT_STANDARDS_STATUS, status.toCode());
    if (normativeVersion == null)
      removeExtension(dr, EXT_NORMATIVE_VERSION);
    else
      setCodeExtension(dr, EXT_NORMATIVE_VERSION, normativeVersion);
  }

  static ValidationMessage readValidationMessage(OperationOutcomeIssueComponent issue, Source source) {
    ValidationMessage vm = new ValidationMessage();
    vm.setSource(source);
    vm.setLevel(mapSeverity(issue.getSeverity()));
    vm.setType(mapType(issue.getCode()));
    if (issue.hasExtension(EXT_ISSUE_LINE))
      vm.setLine(readIntegerExtension(issue, EXT_ISSUE_LINE, 0));
    if (issue.hasExtension(EXT_ISSUE_COL))
      vm.setCol(readIntegerExtension(issue, EXT_ISSUE_COL, 0));
    if (issue.hasExpression())
      vm.setLocation(issue.getExpression().get(0).asStringValue());
    vm.setMessage(issue.getDetails().getText());
    if (issue.hasExtension("http://hl7.org/fhir/StructureDefinition/rendering-xhtml"))
      vm.setHtml(readStringExtension(issue, "http://hl7.org/fhir/StructureDefinition/rendering-xhtml"));
    return vm;
  }

  private static IssueType mapType(org.hl7.fhir.r5.model.OperationOutcome.IssueType code) {
    switch (code) {
    case BUSINESSRULE: return IssueType.BUSINESSRULE;
    case CODEINVALID: return IssueType.CODEINVALID;
    case CONFLICT: return IssueType.CONFLICT;
    case DELETED: return IssueType.DELETED;
    case DUPLICATE: return IssueType.DUPLICATE;
    case EXCEPTION: return IssueType.EXCEPTION;
    case EXPIRED: return IssueType.EXPIRED;
    case EXTENSION: return IssueType.EXTENSION;
    case FORBIDDEN: return IssueType.FORBIDDEN;
    case INCOMPLETE: return IssueType.INCOMPLETE;
    case INFORMATIONAL: return IssueType.INFORMATIONAL;
    case INVALID: return IssueType.INVALID;
    case INVARIANT: return IssueType.INVARIANT;
    case LOCKERROR: return IssueType.LOCKERROR;
    case LOGIN: return IssueType.LOGIN;
    case MULTIPLEMATCHES: return IssueType.MULTIPLEMATCHES;
    case NOSTORE: return IssueType.NOSTORE;
    case NOTFOUND: return IssueType.NOTFOUND;
    case NOTSUPPORTED: return IssueType.NOTSUPPORTED;
    case NULL: return IssueType.NULL;
    case PROCESSING: return IssueType.PROCESSING;
    case REQUIRED: return IssueType.REQUIRED;
    case SECURITY: return IssueType.SECURITY;
    case STRUCTURE: return IssueType.STRUCTURE;
    case SUPPRESSED: return IssueType.SUPPRESSED;
    case THROTTLED: return IssueType.THROTTLED;
    case TIMEOUT: return IssueType.TIMEOUT;
    case TOOCOSTLY: return IssueType.TOOCOSTLY;
    case TOOLONG: return IssueType.TOOLONG;
    case TRANSIENT: return IssueType.TRANSIENT;
    case UNKNOWN: return IssueType.UNKNOWN;
    case VALUE: return IssueType.VALUE;
    default: return null;
    }
  }

  private static IssueSeverity mapSeverity(org.hl7.fhir.r5.model.OperationOutcome.IssueSeverity severity) {
    switch (severity) {
    case ERROR: return IssueSeverity.ERROR;
    case FATAL: return IssueSeverity.FATAL;
    case INFORMATION: return IssueSeverity.INFORMATION;
    case WARNING: return IssueSeverity.WARNING;
    default: return null;
    }
  }

  static String getPresentation(PrimitiveType<?> type) {
    if (type.hasExtension(EXT_RENDERED_VALUE))
      return readStringExtension(type, EXT_RENDERED_VALUE);
    return type.primitiveValue();
  }

  static String getPresentation(Element holder, PrimitiveType<?> type) {
    if (holder.hasExtension(EXT_RENDERED_VALUE))
      return readStringExtension(holder, EXT_RENDERED_VALUE);
    if (type.hasExtension(EXT_RENDERED_VALUE))
      return readStringExtension(type, EXT_RENDERED_VALUE);
    return type.primitiveValue();
  }

  //  static bool hasOID(ValueSet vs) {
  //    return hasExtension(vs, EXT_OID);
  //  }
  //  
  //  static bool hasOID(CodeSystem cs) {
  //    return hasExtension(cs, EXT_OID);
  //  }
  //  
  void addUrlExtension(Element e, String url, String content) {
    if (!StringUtils.isBlank(content)) {
      r5.FhirExtension ex = getExtension(e, url);
      if (ex != null)
        ex.setValue(new UrlType(content));
      else
        e.getExtension().add(Factory.newExtension(url, new UrlType(content), true));   
    }
  }

  void addUrlExtension(r5.Resource dr, String url, String value) {
    r5.FhirExtension ex = getExtension(dr, url);
    if (ex != null)
      ex.setValue(new UrlType(value));
    else
      dr.getExtension().add(Factory.newExtension(url, new UrlType(value), true));   
  }

  void addUriExtension(Element e, String url, String content) {
    if (!StringUtils.isBlank(content)) {
      r5.FhirExtension ex = getExtension(e, url);
      if (ex != null)
        ex.setValue(new UriType(content));
      else
        e.getExtension().add(Factory.newExtension(url, new UriType(content), true));   
    }
  }

  void addUriExtension(r5.Resource dr, String url, String value) {
    r5.FhirExtension ex = getExtension(dr, url);
    if (ex != null)
      ex.setValue(new UriType(value));
    else
      dr.getExtension().add(Factory.newExtension(url, new UriType(value), true));   
  }

  static bool usesExtension(String url, Base base) {
    if ("Extension".equals(base.fhirType())) {
      Property p = base.getNamedProperty("url");
      for (Base b : p.getValues()) {
        if (url.equals(b.primitiveValue())) {
          return true;
        }
      }
    }

    for (Property p : base.children() ) {
      for (Base v : p.getValues()) {
        if (usesExtension(url, v)) {
          return true;
        }
      }
    }
    return false;
  }

  private static Set<String> cachedConsts;
  
  static Set<String> allConsts() {
    if (cachedConsts == null) {
      Set<String> list = new HashSet<>();
      for (Field field : class.getDeclaredFields()) {
        int modifiers = field.getModifiers();
        if (Modifier.isStatic(modifiers) && Modifier.isFinal(modifiers)) {
          try {
            list.add(field.get(field.getType()).toString());
          } catch (Exception e) {
          }
        }
      }
      cachedConsts = list;
    }
    return cachedConsts;
  }

  static bool hasAnyOfExtensions(Element d, String... urls) {
    for (String url : urls) {
      if (d.hasExtension(url)) {
        return true;
      }
    }
    return false;
  }

  static bool hasAnyOfExtensions(r5.Resource dr, String... urls) {
    for (String url : urls) {
      if (dr.hasExtension(url)) {
        return true;
      }
    }
    return false;
  }

  static int countExtensions(ElementDefinition d, String... urls) {
    int res = 0;
    for (String url : urls) {
      if (d.hasExtension(url)) {
        res++;
      }
    }
    return res;
  }

}