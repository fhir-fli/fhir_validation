class ValidationOptions {
  AcceptLanguageHeader? langs;
  bool useServer = true;
  bool useClient = true;
  bool guessSystem = false;
  bool membershipOnly = false;
  bool displayWarningMode = false;
  bool vsAsUrl = false;
  bool versionFlexible = true;
  bool useValueSetDisplays = false;
  bool englishOk = true;
  bool activeOnly = false;
  late FhirPublication fhirVersion;

  ValidationOptions(this.fhirVersion);

  ValidationOptions.withLang(this.fhirVersion, String? language) {
    if (!Utilities.noString(language)) {
      langs = AcceptLanguageHeader(language!, false);
    }
  }

  static ValidationOptions defaults() {
    return ValidationOptions(FhirPublication.R5)
      ..langs = AcceptLanguageHeader('en, en-US', false);
  }

  bool hasLanguages() {
    return langs != null && !Utilities.noString(langs!.source);
  }

  bool getVsAsUrl() {
    return vsAsUrl;
  }

  bool isDisplayWarningMode() {
    return displayWarningMode;
  }

  ValidationOptions copy() {
    var n = ValidationOptions(fhirVersion)
      ..langs = langs == null ? null : langs!.copy()
      ..useServer = useServer
      ..useClient = useClient
      ..guessSystem = guessSystem
      ..activeOnly = activeOnly
      ..vsAsUrl = vsAsUrl
      ..versionFlexible = versionFlexible
      ..membershipOnly = membershipOnly
      ..useValueSetDisplays = useValueSetDisplays
      ..displayWarningMode = displayWarningMode;
    return n;
  }

  String toJson() {
    return '"langs":"${langs == null ? "" : langs.toString()}", "useServer":"${useServer.toString()}", "useClient":"${useClient.toString()}", ' +
        '"guessSystem":"${guessSystem.toString()}", "activeOnly":"${activeOnly.toString()}", "membershipOnly":"${membershipOnly.toString()}", "displayWarningMode":"${displayWarningMode.toString()}", "versionFlexible":"${versionFlexible.toString()}"';
  }

  String langSummary() {
    if (langs == null) {
      return "--";
    } else {
      var s = langs!.toString();
      if (Utilities.noString(s)) {
        s = "--";
      }
      return s;
    }
  }

  FhirPublication getFhirVersion() {
    return fhirVersion;
  }
}
