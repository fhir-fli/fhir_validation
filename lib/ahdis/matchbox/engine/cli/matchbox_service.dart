class MatchboxService {
  static const String CURRENT_DEFAULT_VERSION = '4.0';
  static const String CURRENT_DEFAULT_FULL_VERSION = '4.0.1';

  final SessionCache _sessionCache;

  MatchboxService() : _sessionCache = SessionCache();

  MatchboxService.withCache(SessionCache cache) : _sessionCache = cache;

  ValidationResponse validateSources(ValidationRequest request) {
    if (request.cliContext.sv == null) {
      String sv = determineVersion(request.cliContext, request.sessionId);
      request.cliContext.sv = sv;
    }

    String definitions =
        '${VersionUtilities.packageForVersion(request.cliContext.sv)}#${VersionUtilities.getCurrentVersion(request.cliContext.sv)}';

    String sessionId = initializeValidator(
        request.cliContext, definitions, TimeTracker(), request.sessionId);
    ValidationEngine validator =
        _sessionCache.fetchSessionValidatorEngine(sessionId);

    if (request.cliContext.profiles.isNotEmpty) {
      print(
          '  .. validate ${request.listSourceFiles()} against ${request.cliContext.profiles.toString()}');
    } else {
      print('  .. validate ${request.listSourceFiles()}');
    }

    ValidationResponse response = ValidationResponse().setSessionId(sessionId);

    for (FileInfo fp in request.filesToValidate) {
      List<ValidationMessage> messages = [];
      validator.validate(
          fp.fileContent.getBytes(),
          Manager.FhirFormat.getFhirFormat(fp.fileType),
          request.cliContext.profiles,
          messages);
      ValidationOutcome outcome = ValidationOutcome().setFileInfo(fp);
      messages.forEach(outcome.addMessage);
      response.addOutcome(outcome);
    }
    print('  Max Memory: ${Runtime.getRuntime().maxMemory()}');
    return response;
  }

  VersionSourceInformation scanForVersions(CliContext cliContext) {
  VersionSourceInformation versions = VersionSourceInformation();
  IgLoader igLoader = IgLoader(
    FilesystemPackageCacheManager(
        FilesystemPackageCacheManager.FilesystemPackageCacheMode.USER),
    SimpleWorkerContext.SimpleWorkerContextBuilder().fromNothing(),
    null,
  );
  for (String src in cliContext.igs) {
    igLoader.scanForIgVersion(
        src, cliContext.isRecursive(), versions);
  }
  igLoader.scanForVersions(cliContext.sources, versions);
  return versions;
}

void validateSources(CliContext cliContext, ValidationEngine validator) {
  var start = DateTime.now().millisecondsSinceEpoch;
  var records = <ValidationRecord>[];
  var refs = <ValidatorUtils.SourceFile>[];
  var r = validator.validate(
      cliContext.sources,
      cliContext.profiles,
      refs,
      records,
      null,
      true,
      0,
      true);
  var mbean = MemoryMXBean();
  print('Done. ' +
      validator.getContext().clock().report() +
      '. Memory = ' +
      Utilities.describeSize(
          mbean.heapMemoryUsage.used + mbean.nonHeapMemoryUsage.used));
  print();

  PrintStream? dst;
  if (cliContext.output == null) {
    dst = System.out;
  } else {
    dst = PrintStream(File(cliContext.output!));
  }

  var renderer = makeValidationOutputRenderer(cliContext);
  renderer.setOutput(dst!);
  renderer.setCrumbTrails(validator.isCrumbTrails());

  var ec = 0;

  if (r is Bundle) {
    if (renderer.handlesBundleDirectly()) {
      renderer.render(r);
    } else {
      renderer.start((r as Bundle).entry.length > 1);
      for (var e in (r as Bundle).entry) {
        var op = (e.getResource() as OperationOutcome);
        ec = ec + countErrors(op);
        renderer.render(op);
      }
      renderer.finish();
    }
  } else if (r == null) {
    ec = ec + 1;
    print('No output from validation - nothing to validate');
  } else {
    renderer.start(false);
    var op = r as OperationOutcome;
    ec = countErrors(op);
    renderer.render(r);
    renderer.finish();
  }

  if (cliContext.output != null) {
    dst.close();
  }

  if (cliContext.htmlOutput != null) {
    var html = HTMLOutputGenerator(records)
        .generate(DateTime.now().millisecondsSinceEpoch - start);
    TextFile.stringToFile(html, cliContext.htmlOutput!);
    print('HTML Summary in ' + cliContext.htmlOutput!);
  }
  exit(ec > 0 ? 1 : 0);
}

int countErrors(OperationOutcome oo) {
  int error = 0;
  for (var issue in oo.issue) {
    if (issue.severity == OperationOutcome_IssueSeverity.FATAL ||
        issue.severity == OperationOutcome_IssueSeverity.ERROR) error++;
  }
  return error;
}

ValidationOutputRenderer makeValidationOutputRenderer(CliContext cliContext) {
  var style = cliContext.outputStyle;
  if (Utilities.noString(style)) {
    if (cliContext.output == null) {
      return DefaultRenderer();
    } else if (cliContext.output!.endsWith('.json')) {
      return NativeRenderer(FhirFormat.JSON);
    } else {
      return NativeRenderer(FhirFormat.XML);
    }
  } else if (Utilities.existsInList(style, 'eslint-compact')) {
    return ESLintCompactRenderer();
  } else if (Utilities.existsInList(style, 'csv')) {
    return CSVRenderer();
  } else if (Utilities.existsInList(style, 'xml')) {
    return NativeRenderer(FhirFormat.XML);
  } else if (Utilities.existsInList(style, 'json')) {
    return NativeRenderer(FhirFormat.JSON);
  } else {
    print("Unknown output style '$style'");
    return DefaultRenderer();
  }
}

void convertSources(CliContext cliContext, ValidationEngine validator) {
  if (!((cliContext.output == null) ^
      (cliContext.outputSuffix == null))) {
    throw Exception(
        "Convert requires one of {-output, -outputSuffix} parameter to be set");
  }

  var sources = cliContext.sources;
  if ((sources.length == 1) && (cliContext.output != null)) {
    print(' ...convert');
    validator.convert(sources[0], cliContext.output!);
  } else {
    if (cliContext.outputSuffix == null) {
      throw Exception(
          "Converting multiple/wildcard sources requires a -outputSuffix parameter to be set");
    }
    for (var i = 0; i < sources.length; i++) {
      var output = sources[i] + '.' + cliContext.outputSuffix!;
      validator.convert(sources[i], output);
      print(' ...convert [$i] (${sources[i]} to $output)');
    }
  }
}

void evaluateFhirpath(CliContext cliContext, ValidationEngine validator) {
  print(' ...evaluating ${cliContext.fhirpath}');
  print(validator.evaluateFhirPath(cliContext.sources[0], cliContext.fhirpath!));
}

void generateSnapshot(CliContext cliContext, ValidationEngine validator) {
  if (!((cliContext.output == null) ^
      (cliContext.outputSuffix == null))) {
    throw Exception(
        "Snapshot generation requires one of {-output, -outputSuffix} parameter to be set");
  }

  var sources = cliContext.sources;
  if ((sources.length == 1) && (cliContext.output != null)) {
    var r = validator.snapshot(sources[0], cliContext.sv!);
    print(' ...generated snapshot successfully');
    validator.handleOutput(r, cliContext.output!, cliContext.sv!);
  } else {
    if (cliContext.outputSuffix == null) {
      throw Exception(
          "Snapshot generation for multiple/wildcard sources requires a -outputSuffix parameter to be set");
    }
    for (var i = 0; i < sources.length; i++) {
      var r = validator.snapshot(sources[i], cliContext.sv!);
      var output = sources[i] + '.' + cliContext.outputSuffix!;
      validator.handleOutput(r, output, cliContext.sv!);
      print(' ...generated snapshot [$i] successfully (${sources[i]} to $output)');
    }
  }
}

void generateNarrative(CliContext cliContext, ValidationEngine validator) {
  var r = validator.generate(cliContext.sources[0], cliContext.sv!);
  print(' ...generated narrative successfully');
  if (cliContext.output != null) {
    validator.handleOutput(r, cliContext.output!, cliContext.sv!);
  }
}

void transform(CliContext cliContext, ValidationEngine validator) {
  if (cliContext.sources.length > 1)
    throw Exception(
        "Can only have one source when doing a transform (found ${cliContext.sources})");
  if (cliContext.txServer == null)
    throw Exception("Must provide a terminology server when doing a transform");
  if (cliContext.map == null)
    throw Exception("Must provide a map when doing a transform");
  try {
    var cu = ContextUtilities(validator.getContext());
    var structures = cu.allStructures();
    for (var sd in structures) {
      if (!sd.hasSnapshot()) {
        if (sd.kind != null && sd.kind == StructureDefinitionKind.LOGICAL) {
          cu.generateSnapshot(sd, true);
        } else {
          cu.generateSnapshot(sd, false);
        }
      }
    }
    validator.setMapLog(cliContext.mapLog);
    var r = validator.transform(cliContext.sources[0], cliContext.map!);
    print(' ...success');
    if (cliContext.output != null) {
      var s = File(cliContext.output!).openWrite();
      if (cliContext.output != null && cliContext.output!.endsWith('.json'))
        org.hl7.fhir.r5.elementmodel.JsonParser(validator.getContext())
            .compose(r, s, IParser.OutputStyle.PRETTY, null);
      else
        org.hl7.fhir.r5.elementmodel.XmlParser(validator.getContext())
            .compose(r, s, IParser.OutputStyle.PRETTY, null);
      await s.close();
    }
  } catch (e) {
    print(' ...Failure: $e');
    printStackTrace(e);
  }
}


void compile(CliContext cliContext, ValidationEngine validator) {
  if (cliContext.sources.length > 0)
    throw Exception(
        "Cannot specify sources when compiling transform (found ${cliContext.sources})");
  if (cliContext.map == null)
    throw Exception("Must provide a map when compiling a transform");
  if (cliContext.output == null)
    throw Exception("Must provide an output name when compiling a transform");
  try {
    var cu = ContextUtilities(validator.getContext());
    var structures = cu.allStructures();
    for (var sd in structures) {
      if (!sd.hasSnapshot()) {
        if (sd.kind != null && sd.kind == StructureDefinitionKind.LOGICAL) {
          cu.generateSnapshot(sd, true);
        } else {
          cu.generateSnapshot(sd, false);
        }
      }
    }
    validator.setMapLog(cliContext.mapLog);
    var map = validator.compile(cliContext.map!);
    if (map == null)
      throw Exception("Unable to locate map ${cliContext.map}");
    validator.handleOutput(map, cliContext.output!, validator.getVersion());
    print(" ...success");
  } catch (e) {
    print(" ...Failure: $e");
    printStackTrace(e);
  }
}

void transformVersion(CliContext cliContext, ValidationEngine validator) {
  if (cliContext.sources.length > 1) {
    throw Exception(
        "Can only have one source when converting versions (found ${cliContext.sources})");
  }
  if (cliContext.targetVer == null) {
    throw Exception("Must provide a map when converting versions");
  }
  if (cliContext.output == null) {
    throw Exception("Must nominate an output when converting versions");
  }
  try {
    if (cliContext.mapLog != null) {
      validator.setMapLog(cliContext.mapLog);
    }
    var r = validator.transformVersion(
        cliContext.sources[0],
        cliContext.targetVer!,
        cliContext.output!.endsWith(".json")
            ? Manager.FhirFormat.JSON
            : Manager.FhirFormat.XML,
        cliContext.canDoNative!);
    print(" ...success");
    TextFile.bytesToFile(r, cliContext.output!);
  } catch (e) {
    print(" ...Failure: $e");
    printStackTrace(e);
  }
}

MatchboxEngine initializeValidator(
    CliContext cliContext, String definitions, TimeTracker tt) {
  return sessionCache.fetchSessionValidatorEngine(initializeValidator(
      cliContext, definitions, tt, null));
}

String initializeValidator(CliContext cliContext, String definitions,
    TimeTracker tt, String sessionId) {
  tt.milestone();
  sessionCache.removeExpiredSessions();
  if (!sessionCache.sessionExists(sessionId)) {
    print(
        "No such cached session exists for session id $sessionId, re-instantiating validator.");
      print(
        "  Initializing CdaMappingEngine for FHIR Version ${cliContext.sv}");
    var validator = CdaMappingEngine.CdaMappingEngineBuilder().getEngine();
    sessionId = sessionCache.cacheSession(validator);

    validator.setDebug(cliContext.doDebug);
    validator.getContext().setLogger(
        SystemOutLoggingService(cliContext.doDebug));
    for (var src in cliContext.igs) {
      validator.getIgLoader().loadIg(
          validator.getIgs(), validator.getBinaries(), src,
          cliContext.isRecursive);
    }
    validator.setQuestionnaireMode(cliContext.questionnaireMode);
    validator.setLevel(cliContext.level);
    validator.setDoNative(cliContext.doNative);
    validator.setHintAboutNonMustSupport(
        cliContext.hintAboutNonMustSupport);
    for (var s in cliContext.extensions) {
      if ("any" == s) {
        validator.setAnyExtensionsAllowed(true);
      } else {
        validator.getExtensionDomains().add(s);
      }
    }
    validator.setLanguage(cliContext.lang);
    validator.setLocale(cliContext.locale);
    validator.setSnomedExtension(cliContext.snomedCTCode);
    validator.setDisplayWarnings(cliContext.displayWarnings);
    validator.setAssumeValidRestReferences(
        cliContext.assumeValidRestReferences);
    validator.setShowMessagesFromReferences(
        cliContext.showMessagesFromReferences);
    validator.setDoImplicitFHIRPathStringConversion(
        cliContext.doImplicitFHIRPathStringConversion);
    validator.setHtmlInMarkdownCheck(
        cliContext.htmlInMarkdownCheck);
    validator.setNoExtensibleBindingMessages(
        cliContext.noExtensibleBindingMessages);
    validator.setNoUnicodeBiDiControlChars(
        cliContext.noUnicodeBiDiControlChars);
    validator.setNoInvariantChecks(cliContext.noInvariants);
    validator.setWantInvariantInMessage(
        cliContext.wantInvariantsInMessages);
    validator.setSecurityChecks(cliContext.securityChecks);
    validator.setCrumbTrails(cliContext.crumbTrails);
    validator.setForPublication(cliContext.forPublication);
    validator.setShowTimes(cliContext.showTimes);
    validator.setAllowExampleUrls(cliContext.allowExampleUrls);
    var fetcher = StandAloneValidatorFetcher(
        validator.getPcm(), validator.getContext(),
        IPackageInstaller() {
      // (https://github.com/ahdis/matchbox/issues/67)
      @override
      bool packageExists(String id, String ver) {
        return false;
      }

      @override
      void loadPackage(String id, String ver) {}
    });
    validator.setFetcher(fetcher);
    validator.getContext().setLocator(fetcher);
    validator.getBundleValidationRules().addAll(
        cliContext.bundleValidationRules);
    validator.setJurisdiction(
        CodeSystemUtilities.readCoding(cliContext.jurisdiction));
    validator.prepare(); // generate any missing snapshots
    print(" go (${tt.milestone()})");
  } else {
    print(
        "Cached session exists for session id $sessionId, returning stored validator session id.");
  }
  return sessionId;
}
String determineVersion(CliContext cliContext) {
  return determineVersionWithSession(cliContext, null);
}

String determineVersionWithSession(CliContext cliContext, String? sessionId) {
  if (cliContext.getMode() != EngineMode.VALIDATION) {
    return "current";
  }
  print("Scanning for versions (no -version parameter):");
  var versions = scanForVersions(cliContext);
  versions.getReport().forEach((s) {
    if (s != "(nothing found)") {
      print("  $s");
    }
  });
  if (versions.isEmpty()) {
    print("  No Version Info found: Using Default version '$CURRENT_DEFAULT_VERSION'");
    return CURRENT_DEFAULT_FULL_VERSION;
  }
  if (versions.length == 1) {
    print("-> use version ${versions.version()}");
    return versions.version();
  }
  throw Exception("-> Multiple versions found. Specify a particular version using the -version parameter");
}
}
