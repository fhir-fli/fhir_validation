class Params {
  // Constants for command-line parameters
  static const String VERSION = "-version";
  static const String ALT_VERSION = "-alt-version";
  static const String OUTPUT = "-output";
  static const String OUTPUT_SUFFIX = "-";
  static const String HTML_OUTPUT = "-html-output";
  static const String PROXY = "-proxy";
  // ... and many more ...

  // Method to check if a parameter is present in the command line arguments
  static bool hasParam(List<String> args, String param) {
    return args.contains(param);
  }

  // Method to get the value of a parameter from the command line arguments
  static String? getParam(List<String> args, String param) {
    for (int i = 0; i < args.length - 1; i++) {
      if (args[i] == param) return args[i + 1];
    }
    return null;
  }

  // ... Previous constants and methods ...

  // Method to load CLI context from command line arguments
  static Future<CliContext> loadCliContext(List<String> args) async {
    final cliContext = CliContext();

    // Load parameters from command line arguments
    for (int i = 0; i < args.length; i++) {
      if (args[i] == VERSION) {
        cliContext.sv = VersionUtilities.getCurrentPackageVersion(args[++i]);
      } else if (args[i] == FHIR_SETTINGS_PARAM) {
        final fhirSettingsFilePath = args[++i];
        if (!File(fhirSettingsFilePath).existsSync()) {
          throw Error("Cannot find fhir-settings file: $fhirSettingsFilePath");
        }
        cliContext.fhirSettingsFile = fhirSettingsFilePath;
      } else if (args[i] == OUTPUT) {
        if (i + 1 == args.length)
          throw Error("Specified -output without indicating output file");
        else
          cliContext.output = args[++i];
      } else if (args[i] == OUTPUT_SUFFIX) {
        if (i + 1 == args.length)
          throw Error(
              "Specified -outputSuffix without indicating output suffix");
        else
          cliContext.outputSuffix = args[++i];
      }
      // ... More parameter handling ...
    }

    return cliContext;
  }

  // ... Other methods ...
}
