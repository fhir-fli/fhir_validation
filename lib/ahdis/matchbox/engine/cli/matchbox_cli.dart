// import '../../matchbox.dart';

// class MatchboxCli {
//   static const String HTTP_PROXY_HOST = 'http.proxyHost';
//   static const String HTTP_PROXY_PORT = 'http.proxyPort';
//   static const String HTTP_PROXY_USER = 'http.proxyUser';
//   static const String HTTP_PROXY_PASS = 'http.proxyPassword';
//   static const String JAVA_DISABLED_TUNNELING_SCHEMES =
//       'jdk.http.auth.tunneling.disabledSchemes';
//   static const String JAVA_DISABLED_PROXY_SCHEMES =
//       'jdk.http.auth.proxying.disabledSchemes';
//   static const String JAVA_USE_SYSTEM_PROXIES = 'java.net.useSystemProxies';

//   static MatchboxService matchboxService = MatchboxService();

//   static void main(List<String> args) {
//     var tt = TimeTracker();
//     var tts = tt.start('Loading');

//     print(VersionUtil.getPoweredBy());
//     Display.displaySystemInfo(stdout);

//     if (args.map((e) => e.toLowerCase()).toList().contains('proxy')) {
//       final index = args.indexWhere((element) => element.toLowerCase() == 'proxy');
//       var p = args[index].split(':');
//       System.setProperty(HTTP_PROXY_HOST, p[0]);
//       System.setProperty(HTTP_PROXY_PORT, p[1]);
//     }
    
//     if (Params.hasParam(args, Params.PROXY_AUTH)) {
//       assert(Params.getParam(args, Params.PROXY) != null);
//       assert(Params.getParam(args, Params.PROXY_AUTH) != null);
//       var p = Params.getParam(args, Params.PROXY_AUTH)!.split(':');
//       var authUser = p[0];
//       var authPass = p[1];

//       Authenticator.setDefault(
//         Authenticator() {
//           @override
//           PasswordAuthentication getPasswordAuthentication() {
//             return PasswordAuthentication(authUser, authPass.characters.toList());
//           }
//         },
//       );

//       System.setProperty(HTTP_PROXY_USER, authUser);
//       System.setProperty(HTTP_PROXY_PASS, authPass);
//       System.setProperty(JAVA_USE_SYSTEM_PROXIES, 'true');

//       System.setProperty(JAVA_DISABLED_TUNNELING_SCHEMES, '');
//       System.setProperty(JAVA_DISABLED_PROXY_SCHEMES, '');
//     }

//     var cliContext = Params.loadCliContext(args);

//     FileFormat.checkCharsetAndWarnIfNotUTF8(stdout);

//     if (shouldDisplayHelpToUser(args)) {
//       Display.displayHelpDetails(stdout, 'help/help.txt');
//     } else if (Params.hasParam(args, Params.TEST)) {
//       parseTestParamsAndExecute(args);
//     } else {
//       Display.printCliParamsAndInfo(args);
//       doValidation(tt, tts, cliContext);
//     }
//   }

//   static void parseTestParamsAndExecute(List<String> args) {
//     final testModuleParam = Params.getParam(args, Params.TEST_MODULES);
//     final testClassnameFilter = Params.getParam(args, Params.TEST_NAME_FILTER);
//     final testCasesDirectory = Params.getParam(args, Params.TEST);
//     final txCacheDirectory = Params.getParam(args, Params.TERMINOLOGY_CACHE);
//     assert(TestExecutorParams.isValidModuleParam(testModuleParam));
//     final moduleNamesArg = TestExecutorParams.parseModuleParam(testModuleParam!);

//     assert(TestExecutorParams.isValidClassnameFilterParam(testClassnameFilter));

//     TestExecutor(moduleNamesArg).executeTests(
//       testClassnameFilter!,
//       txCacheDirectory,
//       testCasesDirectory!,
//     );

//     exit(0);
//   }

//   static bool shouldDisplayHelpToUser(List<String> args) {
//     return (args.isEmpty ||
//         Params.hasParam(args, Params.HELP) ||
//         Params.hasParam(args, '?') ||
//         Params.hasParam(args, '-?') ||
//         Params.hasParam(args, '/?'));
//   }

//   static void doValidation(TimeTracker tt, TimeTracker.Session tts, CliContext cliContext) async {
//     if (cliContext.sv == null) {
//       cliContext.sv = matchboxService.determineVersion(cliContext);
//     }
//     if (cliContext.jurisdiction == null) {
//       stdout.writeln('  Jurisdiction: None specified (locale = ${Locale.getDefault().country})');
//       stdout.writeln('  Note that exceptions and validation failures may happen in the absence of a locale');
//     } else {
//       stdout.writeln('  Jurisdiction: ${JurisdictionUtilities.displayJurisdiction(cliContext.jurisdiction!)}');
//     }

//     stdout.writeln('Loading');
//     var definitions = cliContext.sv == 'dev'
//         ? 'hl7.fhir.r5.core#current'
//         : '${VersionUtilities.packageForVersion(cliContext.sv!)}#${VersionUtilities.getCurrentVersion(cliContext.sv!)}';

//     var validator = matchboxService.initializeValidator(cliContext, definitions, tt);
//     tts.end();
//     switch (cliContext.mode) {
//       case EngineMode.transform:
//         matchboxService.transform(cliContext, validator);
//         break;
//       case EngineMode.compile:
//         matchboxService.compile(cliContext, validator);
//         break;
//       case EngineMode.narrative:
//         matchboxService.generateNarrative(cliContext, validator);
//         break;
//       case EngineMode.snapshot:
//         matchboxService.generateSnapshot(cliContext, validator);
//         break;
//       case EngineMode.convert:
//         matchboxService.convertSources(cliContext, validator);
//         break;
//       case EngineMode.fhirpath:
//         matchboxService.evaluateFhirpath(cliContext, validator);
//         break;
//       case EngineMode.version:
//         matchboxService.transformVersion(cliContext, validator);
//         break;
//       case EngineMode.validation:
//       case EngineMode.scan:
//       default:
//         for (var s in cliContext.profiles) {
//           if (!validator.context.hasResource(StructureDefinition, s) &&
//               !validator.context.hasResource(ImplementationGuide, s)) {
//             stdout.writeln('  Fetch Profile from $s');
//             validator.loadProfile(cliContext.locations[s] ?? s);
//           }
//         }
//         stdout.writeln('Validating');
//         if (cliContext.mode == EngineMode.scan) {
//           var validationScanner = Scanner(
//             validator.context,
//             validator.validator(null),
//             validator.igLoader,
//             validator.fhirPathEngine,
//           );
//           validationScanner.validateScan(cliContext.output, cliContext.sources);
//         } else {
//           matchboxService.validateSources(cliContext, validator);
//         }
//         break;
//     }
//     stdout.writeln('Done. ${tt.report()}. Max Memory = ${Utilities.describeSize(Runtime.getRuntime().maxMemory())}');
//   }
// }


