class ValidationEngine
    implements
        IValidatorResourceFetcher,
        IValidationPolicyAdvisor,
        IPackageInstaller,
        IWorkerContextManagerIPackageLoadingTracker {
  bool anyExtensionsAllowed = false;
  bool debug = false;
  bool? allowDoubleQuotesInFHIRPath;
  bool? allowExampleUrls;
  bool? assumeValidRestReferences;
  bool? crumbTrails;
  bool? displayWarnings;
  bool? doImplicitFHIRPathStringConversion;
  bool? doNative;
  bool? forPublication;
  bool? hintAboutNonMustSupport;
  bool? noExtensibleBindingMessages;
  bool? noInvariantChecks;
  bool? noUnicodeBiDiControlChars;
  bool? securityChecks;
  bool? showMessagesFromReferences;
  bool? showTimes;
  bool? wantInvariantInMessage;
  Coding? jurisdiction;
  ContextUtilities? cu;
  FHIRPathEngine? fhirPathEngine;
  FilesystemPackageCacheManager? pcm;
  HtmlInMarkdownCheck? htmlInMarkdownCheck;
  IgLoader? igLoader;
  IValidationPolicyAdvisor? policyAdvisor;
  IValidatorResourceFetcher? fetcher;
  IWorkerContextManagerICanonicalResourceLocator? locator;
  List<BundleValidationRule> bundleValidationRules = [];
  List<ImplementationGuide> igs = [];
  List<String> extensionDomains = [];
  Locale? locale;
  Map<String, Uint8List> binaries = {};
  Map<String, ValidationControl> validationControl = {};
  PrintWriter? mapLog;
  QuestionnaireMode? questionnaireMode;
  SimpleWorkerContext? context;
  String? language;
  String? version;
  ValidationLevel level = ValidationLevel.HINTS;

  ValidationEngine.clone(ValidationEngine other) {
    context = SimpleWorkerContext(other.context);
    binaries.addAll(other.binaries);
    doNative = other.doNative;
    noInvariantChecks = other.noInvariantChecks;
    wantInvariantInMessage = other.wantInvariantInMessage;
    hintAboutNonMustSupport = other.hintAboutNonMustSupport;
    anyExtensionsAllowed = other.anyExtensionsAllowed;
    version = other.version;
    language = other.language;
    pcm = other.pcm;
    mapLog = other.mapLog;
    debug = other.debug;
    fetcher = other.fetcher;
    policyAdvisor = other.policyAdvisor;
    locator = other.locator;
    assumeValidRestReferences = other.assumeValidRestReferences;
    noExtensibleBindingMessages = other.noExtensibleBindingMessages;
    noUnicodeBiDiControlChars = other.noUnicodeBiDiControlChars;
    securityChecks = other.securityChecks;
    crumbTrails = other.crumbTrails;
    forPublication = other.forPublication;
    allowExampleUrls = other.allowExampleUrls;
    showMessagesFromReferences = other.showMessagesFromReferences;
    doImplicitFHIRPathStringConversion =
        other.doImplicitFHIRPathStringConversion;
    htmlInMarkdownCheck = other.htmlInMarkdownCheck;
    allowDoubleQuotesInFHIRPath = other.allowDoubleQuotesInFHIRPath;
    locale = other.locale;
    igs.addAll(other.igs);
    extensionDomains.addAll(other.extensionDomains);
    showTimes = other.showTimes;
    bundleValidationRules.addAll(other.bundleValidationRules);
    questionnaireMode = other.questionnaireMode;
    level = other.level;
    fhirPathEngine = other.fhirPathEngine;
    igLoader = other.igLoader;
    jurisdiction = other.jurisdiction;
  }

  Map<String, ValidationControl> getValidationControl() {
    return validationControl;
  }

  void setValidationControl(Map<String, ValidationControl> value) {
    validationControl = value;
  }

  Map<String, bool> getResolvedUrls() {
    return resolvedUrls;
  }

  void setResolvedUrls(Map<String, bool> value) {
    resolvedUrls = value;
  }
}

class ValidationEngineBuilder {
  String? terminologyCachePath;
  String? userAgent;
  String? version;
  String? txServer;
  String? txLog;
  FhirPublication? txVersion;
  TimeTracker? timeTracker;
  bool canRunWithoutTerminologyServer = false;
  IWorkerContextILoggingService? loggingService;
  bool THO = true;

  ValidationEngineBuilder({
    required this.terminologyCachePath,
    required this.userAgent,
    required this.version,
    required this.txServer,
    required this.txLog,
    required this.txVersion,
    required this.timeTracker,
    required this.canRunWithoutTerminologyServer,
    required this.loggingService,
    required this.THO,
  });

  ValidationEngineBuilder withTxServer(String? txServer, String? txLog, FhirPublication? txVersion) {
    return ValidationEngineBuilder(
      terminologyCachePath: terminologyCachePath,
      userAgent: userAgent,
      version: version,
      txServer: txServer,
      txLog: txLog,
      txVersion: txVersion,
      timeTracker: timeTracker,
      canRunWithoutTerminologyServer: canRunWithoutTerminologyServer,
      loggingService: loggingService,
      THO: THO,
    );
  }

  ValidationEngineBuilder withNoTerminologyServer() {
    return ValidationEngineBuilder(
      terminologyCachePath: terminologyCachePath,
      userAgent: userAgent,
      version: version,
      txServer: null,
      txLog: null,
      txVersion: txVersion,
      timeTracker: timeTracker,
      canRunWithoutTerminologyServer: true,
      loggingService: loggingService,
      THO: THO,
    );
  }

  ValidationEngine fromNothing() {
    var engine = ValidationEngine();
    var contextBuilder = SimpleWorkerContext.SimpleWorkerContextBuilder().withLoggingService(loggingService);
    if (terminologyCachePath != null) {
      contextBuilder = contextBuilder.withTerminologyCachePath(terminologyCachePath!);
    }
    engine.context = contextBuilder.build();
    engine.initContext(timeTracker);
    engine.igLoader = IgLoader(engine.getPcm(), engine.context, engine.version,
  }
}

// Class ValidationEngineBuilder
class ValidationEngineBuilder {
  String? terminologyCachePath;
  String? userAgent;
  String? version;
  String? txServer;
  String? txLog;
  FhirPublication? txVersion;
  TimeTracker? timeTracker;
  bool canRunWithoutTerminologyServer = false;
  IWorkerContextILoggingService? loggingService;
  bool THO = true;

  ValidationEngineBuilder(
    this.terminologyCachePath,
    this.userAgent,
    this.version,
    this.txServer,
    this.txLog,
    this.txVersion,
    this.timeTracker,
    this.canRunWithoutTerminologyServer,
    this.loggingService,
    this.THO,
  );

  ValidationEngineBuilder withTxServer(String? txServer, String? txLog, FhirPublication? txVersion) {
    return ValidationEngineBuilder(
      terminologyCachePath,
      userAgent,
      version,
      txServer,
      txLog,
      txVersion,
      timeTracker,
      canRunWithoutTerminologyServer,
      loggingService,
      THO,
    );
  }

  ValidationEngineBuilder withNoTerminologyServer() {
    return ValidationEngineBuilder(
      terminologyCachePath,
      userAgent,
      version,
      null,
      null,
      txVersion,
      timeTracker,
      true,
      loggingService,
      THO,
    );
  }

  ValidationEngine fromNothing() {
    var engine = ValidationEngine();
    var contextBuilder = SimpleWorkerContext.SimpleWorkerContextBuilder().withLoggingService(loggingService);
    if (terminologyCachePath != null) {
      contextBuilder = contextBuilder.withTerminologyCachePath(terminologyCachePath!);
    }
    engine.context = contextBuilder.build();
    engine.initContext(timeTracker);
    engine.igLoader = IgLoader(engine.getPcm(), engine.context, engine.version, engine.debug);
    engine.loadTx(engine);
    if (VersionUtilities.isR5Plus(engine.version)) {
      engine.loadPackage("hl7.fhir.uv.extensions", null);
    }
    return engine;
  }

  ValidationEngine fromSource(String src) {
    var engine = ValidationEngine();
    engine.loadCoreDefinitions(src, false, terminologyCachePath, userAgent, timeTracker, loggingService);
    engine.context!.setCanRunWithoutTerminology(canRunWithoutTerminologyServer);
    engine.context!.setPackageTracker(engine);
    if (txServer != null) {
      engine.setTerminologyServer(txServer, txLog, txVersion);
    }
    engine.version = version;
    engine.igLoader = IgLoader(engine.getPcm(), engine.context, engine.version, engine.debug);
    if (THO) {
      engine.loadTx(engine);
    }
    if (VersionUtilities.isR5Plus(engine.version)) {
      engine.loadPackage("hl7.fhir.uv.extensions", "1.0.0");
    }
    return engine;
  }

  void loadTx(ValidationEngine engine) {
    String? pid;
    if (VersionUtilities.isR3Ver(engine.version)) {
      pid = "hl7.terminology.r3";
    }
    if (VersionUtilities.isR4Ver(engine.version)) {
      pid = "hl7.terminology.r4";
    }
    if (VersionUtilities.isR4BVer(engine.version)) {
      pid = "hl7.terminology.r4";
    }
    if (VersionUtilities.isR5Plus(engine.version)) {
      pid = "hl7.terminology.r5";
    }
    if (pid != null) {
      engine.loadPackage(pid, "5.0.0");
    }
  }


void loadCoreDefinitions(
  String src,
  bool recursive,
  String? terminologyCachePath,
  String? userAgent,
  TimeTracker? tt,
  IWorkerContextILoggingService? loggingService,
) {
  var npm = getPcm().loadPackage(src, null);
  if (npm != null) {
    version = npm.fhirVersion();
    var contextBuilder = SimpleWorkerContext.SimpleWorkerContextBuilder().withLoggingService(loggingService);
    if (terminologyCachePath != null) {
      contextBuilder = contextBuilder.withTerminologyCachePath(terminologyCachePath);
    }
    if (userAgent != null) {
      contextBuilder.withUserAgent(userAgent);
    }
    context = contextBuilder.fromPackage(npm, ValidatorUtils.loaderForVersion(version), false);
  } else {
    var source = igLoader.loadIgSource(src, recursive, true);
    if (version == null) {
      version = getVersionFromPack(source);
    }
    var contextBuilder = SimpleWorkerContext.SimpleWorkerContextBuilder();
    if (terminologyCachePath != null) {
      contextBuilder = contextBuilder.withTerminologyCachePath(terminologyCachePath);
    }
    if (userAgent != null) {
      contextBuilder.withUserAgent(userAgent);
    }
    context = contextBuilder.fromDefinitions(source, ValidatorUtils.loaderForVersion(version), PackageInformation(src, DateTime.now()));
    ValidatorUtils.grabNatives(getBinaries(), source, "http://hl7.org/fhir");
  }

  try {
    var classLoader = ValidationEngine.getClassLoader();
    var ue = classLoader.getResourceAsStream("ucum-essence.xml");
    context.setUcumService(UcumEssenceService(ue));
  } catch (e) {
    throw FHIRException("Error loading UCUM from embedded ucum-essence.xml: ${e.message}", e);
  }

  initContext(tt);
}

void initContext(TimeTracker? tt) {
  context.setCanNoTS(true);
  context.setCacheId(Uuid().v4());
  context.setAllowLoadingDuplicates(true); // because of Forge
  context.setExpansionProfile(makeExpProfile());
  if (tt != null) {
    context.setClock(tt);
  }
  var npmX = getPcm().loadPackage(CommonPackages.ID_XVER, CommonPackages.VER_XVER);
  context.loadFromPackage(npmX, null);

  fhirPathEngine = FHIRPathEngine(context);
  fhirPathEngine.setAllowDoubleQuotes(false);
}

String getVersionFromPack(Map<String, List<int>> source) {
  if (source.containsKey("version.info")) {
    var vi = IniFile(InputStream(removeBom(source["version.info"]!)));
    return vi.getStringProperty("FHIR", "version");
  } else {
    throw Error("Missing version.info?");
  }
}

List<int> removeBom(List<int> bs) {
  if (bs.length > 3 && bs[0] == -17 && bs[1] == -69 && bs[2] == -65) {
    return bs.sublist(3, bs.length);
  } else {
    return bs;
  }
}

Parameters makeExpProfile() {
  var ep = Parameters();
  ep.addParameter("profile-url", "http://hl7.org/fhir/ExpansionProfile/dc8fd4bc-091a-424a-8a3b-6198ef146891"); // change this to blow the cache
  // all defaults....
  return ep;
}

String connectToTSServer(String url, String log, FhirPublication version) {
  return connectToTSServer(url, log, null, version);
}

String connectToTSServer(String? url, String log, String? txCachePath, FhirPublication version) {
  context.setTlogging(false);
  if (url == null) {
    context.setCanRunWithoutTerminology(true);
    context.setNoTerminologyServer(true);
    return "n/a: No Terminology Server";
  } else {
    try {
      return context.connectToTSServer(TerminologyClientFactory.makeClient("Tx-Server", url, context.getUserAgent(), version), log);
    } catch (e) {
      if (context.isCanRunWithoutTerminology()) {
        return "n/a: Running without Terminology Server (error: ${e.message})";
      } else {
        throw e;
      }
    }
  }
}


























}

