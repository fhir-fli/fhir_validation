import 'package:fhir_r5/fhir_r5.dart' as r5;

import 'validation.dart';

class BaseValidator implements IValidationContextResourceLoader {
  final String META = "meta";
  final String ENTRY = "entry";
  final String LINK = "link";
  final String DOCUMENT = "document";
  final String RESOURCE = "resource";
  final String MESSAGE = "message";
  final String SEARCHSET = "searchset";
  final String ID = "id";
  final String FULL_URL = "fullUrl";
  final String PATH_ARG = ":0";
  final String TYPE = "type";
  final String BUNDLE = "Bundle";
  final String LAST_UPDATED = "lastUpdated";

  BaseValidator? parent;
  Source? source;
  IWorkerContext context;
  ValidationTimeTracker timeTracker = new ValidationTimeTracker();
  XVerExtensionManager xverManager;
  List<TrackedLocationRelatedMessage> trackedMessages =
      <TrackedLocationRelatedMessage>[];
  List<ValidationMessage> errors = <ValidationMessage>[];
  ValidationLevel level = ValidationLevel.hints;
  r5.Coding? jurisdiction;
  bool? allowExamples;
  bool? forPublication;
  bool debug;
  bool? warnOnDraftOrExperimental;
  Set<String> statusWarnings = <String>{};
  BestPracticeWarningLevel bpWarnings = BestPracticeWarningLevel.Warning;
  Map<String, ValidationControl> validationControl =
      <String, ValidationControl>{};
  String urlRegex;

  // BaseValidator(this.context, XVerExtensionManager? xverManager, this.debug):
  //   this.xverManager = xverManager ?? XVerExtensionManager(context),
  //   this.urlRegex = Constants.URI_REGEX_XVER.replaceFirst("$$", context.getResourceNames().join("|"));

  BaseValidator.fromParent(BaseValidator parent)
      : context = parent.context,
        xverManager = parent.xverManager,
        debug = parent.debug,
        urlRegex = parent.urlRegex;

  bool doingLevel(IssueSeverity? error) {
    switch (error) {
      case IssueSeverity.error:
        return level == ValidationLevel.errors ||
            level == ValidationLevel.warnings ||
            level == ValidationLevel.hints;
      case IssueSeverity.fatal:
        return level == ValidationLevel.errors ||
            level == ValidationLevel.warnings ||
            level == ValidationLevel.hints;
      case IssueSeverity.warning:
        return level == ValidationLevel.warnings ||
            level == ValidationLevel.hints;
      case IssueSeverity.information:
        return level == ValidationLevel.hints;
      case null:
        return true;
      default:
        return true;
    }
  }

  bool doingErrors() {
    return doingLevel(IssueSeverity.error);
  }

  bool doingWarnings() {
    return doingLevel(IssueSeverity.warning);
  }

  bool doingHints() {
    return doingLevel(IssueSeverity.information);
  }

  bool fail({
    required DateTime ruleDate,
    required IssueType type,
    int? line,
    int? col,
    String? path,
    required bool thePass,
    String? msg,
    String? theMessage,
    List<Object>? messageArguments,
  }) {
    if (!thePass && doingErrors()) {
      final String effectiveMessage = formatMessage(
        theMessage ?? msg ?? '',
        messageArguments,
      );
      addValidationMessage(
        ruleDate: ruleDate,
        type: type,
        line: line,
        col: col,
        path: path,
        message: effectiveMessage,
        severity: IssueSeverity.fatal,
      );
    }
    return thePass;
  }

  String formatMessage(String message, List<Object>? arguments) {
    // Dummy implementation for message formatting.
    // You can replace it with your actual message formatting logic.
    return message; // Replace with actual formatting logic.
  }

  ValidationMessage addValidationMessage({
    required DateTime ruleDate,
    required IssueType type,
    int? line,
    int? col,
    String? path,
    required String message,
    required IssueSeverity severity,
    String? invId,
    String? id,
    String? txLink,
    String? html,
  }) {
    return ValidationMessage(
      ruleDate: ruleDate,
      type: type,
      line: line,
      col: col,
      location: path,
      message: message,
      level: severity,
      invId: invId,
      messageId: id,
      txLink: txLink,
      html: html,
    );
  }

  bool hint({
    required DateTime ruleDate,
    required IssueType type,
    int? line,
    int? col,
    String? path,
    required bool thePass,
    String? msg,
    String? theMessage,
    List<Object>? messageArguments,
    String? invId, // For hintInv variant.
    NodeStack? stack, // For the variant that accepts a NodeStack.
  }) {
    if (!thePass && doingHints()) {
      final effectivePath = stack?.getLiteralPath() ?? path;
      final effectiveLine = stack?.line() ?? line;
      final effectiveCol = stack?.col() ?? col;
      final String effectiveMessage = formatMessage(
        theMessage ?? msg ?? '',
        messageArguments,
      );
      final validationMessage = addValidationMessage(
        ruleDate: ruleDate,
        type: type,
        line: effectiveLine,
        col: effectiveCol,
        path: effectivePath,
        message: effectiveMessage,
        severity: IssueSeverity.information,
        invId: invId,
      );
      if (invId != null) {
        validationMessage.invId = invId;
      }
    }
    return thePass;
  }

  bool warning({
    required DateTime ruleDate,
    required IssueType type,
    int? line,
    int? col,
    String? path,
    bool? thePass,
    String? msg,
    String? theMessage,
    List<Object>? messageArguments,
    String? invId, // For warningInv variant.
    NodeStack? stack, // For the variant that accepts a NodeStack.
    String? id, // For variants that include an ID.
    String? txLink, // For the txWarning variant.
  }) {
    if (!(thePass ?? false) && doingWarnings()) {
      final effectivePath = stack?.getLiteralPath() ?? path;
      final effectiveLine = stack?.line() ?? line;
      final effectiveCol = stack?.col() ?? col;
      final String effectiveMessage = formatMessage(
        theMessage ?? msg ?? '',
        messageArguments,
      );
      final validationMessage = addValidationMessage(
        ruleDate: ruleDate,
        type: type,
        line: effectiveLine,
        col: effectiveCol,
        path: effectivePath,
        message: effectiveMessage,
        severity: IssueSeverity.warning,
        id: id,
        invId: invId,
        txLink: txLink,
      );
      if (invId != null) {
        validationMessage.invId = invId;
      }
      if (txLink != null) {
        validationMessage.txLink = txLink;
      }
    }
    return thePass ?? false;
  }

  bool txWarning({
    required DateTime ruleDate,
    required String txLink,
    required IssueType type,
    int? line,
    int? col,
    required String path,
    bool? thePass,
    String? msg,
    List<Object>? messageArguments,
  }) {
    if (!(thePass ?? false) && doingWarnings()) {
      final String nmsg = formatMessage(msg ?? '', messageArguments);
      final ValidationMessage vmsg = ValidationMessage(
        source: Source.terminologyEngine,
        type: type,
        line: line,
        col: col,
        location: path,
        message: nmsg,
        level: IssueSeverity.warning,
      )
        ..txLink = txLink
        ..ruleDate = ruleDate;
      if (checkMsgId(msg, vmsg)) {
        errors.add(vmsg);
      }
    }
    return thePass ?? false;
  }

  ValidationMessage txIssue({
    required DateTime ruleDate,
    required String txLink,
    required int line,
    required int col,
    required String path,
    required r5.OperationOutcomeIssue issue,
  }) {
    final IssueType? code = issue.code?.value == null
        ? null
        : IssueTypeExtension.fromCode(issue.code!.value!);
    final IssueSeverity? severity = issue.severity?.value == null
        ? null
        : IssueSeverityExtension.fromCode(issue.severity!.value!);
    final ValidationMessage vmsg = ValidationMessage(
      source: Source.terminologyEngine,
      type: code,
      line: line,
      col: col,
      location: path,
      message: issue.details?.text,
      level: severity,
    )
      ..txLink = txLink
      ..ruleDate = ruleDate;
    errors.add(vmsg);
    return vmsg;
  }

  bool txWarningForLaterRemoval({
    required Object location,
    required DateTime ruleDate,
    required String txLink,
    required IssueType type,
    required int line,
    required int col,
    required String path,
    bool? thePass,
    String? msg,
    List<Object>? messageArguments,
  }) {
    if (!(thePass ?? false) && doingWarnings()) {
      final String nmsg = formatMessage(msg ?? '', messageArguments);
      final ValidationMessage vmsg = ValidationMessage(
        source: Source.terminologyEngine,
        type: type,
        line: line,
        col: col,
        location: path,
        message: nmsg,
        level: IssueSeverity.warning,
      )
        ..txLink = txLink
        ..ruleDate = ruleDate;
      if (checkMsgId(msg, vmsg)) {
        errors.add(vmsg);
      }
      trackedMessages.add(TrackedLocationRelatedMessage(location, vmsg));
    }
    return thePass ?? false;
  }

  bool rule({
    required DateTime ruleDate,
    required IssueType type,
    int? line,
    int? col,
    String? path,
    required bool thePass,
    String? msg,
    String? theMessage,
    List<Object>? messageArguments,
    String? invId, // For the ruleInv variant.
    NodeStack? stack, // For variants that include NodeStack.
  }) {
    if (!thePass && doingErrors()) {
      final effectivePath = stack?.getLiteralPath() ?? path;
      final effectiveLine = stack?.line() ?? line;
      final effectiveCol = stack?.col() ?? col;
      final String effectiveMessage = formatMessage(
        theMessage ?? msg ?? '',
        messageArguments,
      );
      final validationMessage = addValidationMessage(
        ruleDate: ruleDate,
        type: type,
        line: effectiveLine,
        col: effectiveCol,
        path: effectivePath,
        message: effectiveMessage,
        severity: IssueSeverity.error,
        id: invId,
      );
      if (invId != null) {
        validationMessage.invId = invId;
      }
    }
    return thePass;
  }

  bool txRule({
    required DateTime ruleDate,
    required String txLink,
    required IssueType type,
    int? line,
    int? col,
    String? path,
    required bool thePass,
    String? theMessage,
    List<Object>? messageArguments,
    NodeStack? stack, // If you have a class representing NodeStack
  }) {
    if (!thePass && doingErrors()) {
      final effectivePath = stack?.getLiteralPath() ?? path;
      final effectiveLine = stack?.line() ?? line;
      final effectiveCol = stack?.col() ?? col;
      final String effectiveMessage = formatMessage(
        theMessage ?? '',
        messageArguments,
      );
      final validationMessage = addValidationMessage(
        ruleDate: ruleDate,
        type: type,
        line: effectiveLine,
        col: effectiveCol,
        path: effectivePath,
        message: effectiveMessage,
        severity: IssueSeverity.error,
        txLink: txLink, // Assuming addValidationMessage can handle txLink
      );
      // TODO(Dokotela): Logic to handle the message ID and checkMsgId might go here if applicable
    }
    return thePass;
  }

  bool checkMsgId(String? id, ValidationMessage vm) {
    if (id != null && validationControl.containsKey(id)) {
      ValidationControl? control = validationControl[id];
      if (control?.level != null) {
        vm.level = control!.level;
        return control.allowed;
      } else {
        return false;
      }
    }
    return true;
  }

  bool suppressedWarning(
    DateTime ruleDate,
    IssueType type,
    String path,
    bool thePass,
    String msg, {
    String? html,
    List<Object>? messageArguments,
  }) {
    if (!thePass && doingWarnings()) {
      String nmsg = context.formatMessage(msg, messageArguments ?? []);

      addValidationMessage(
        ruleDate: ruleDate,
        type: type,
        path: path,
        html: html,
        severity: IssueSeverity.information,
        message: nmsg,
      );
    }
    return thePass;
  }

  r5.ValueSet? resolveBindingReference(
    r5.Resource ctxt,
    String? reference,
    String uri,
    r5.Resource src,
  ) {
    if (reference == null) return null;
    if (reference == "http://www.rfc-editor.org/bcp/bcp13.txt") {
      reference = "http://hl7.org/fhir/ValueSet/mimetypes";
    }
    if (reference.startsWith("#")) {
      for (var c in ctxt.contained ?? <r5.Resource>[]) {
        if (c.id == reference.substring(1) && c is r5.ValueSet) return c;
      }
      return null;
    } else {
      var fr = context.fetchResource<r5.ValueSet>(reference, src);
      if (fr == null && !Utilities.isAbsoluteUrl(reference)) {
        reference = resolve(uri, reference);
        fr = context.fetchResource<r5.ValueSet>(reference, src);
      }
      fr ??= ValueSetUtilities.generateImplicitValueSet(reference);
      return fr;
    }
  }

  String resolve(String uri, String ref) {
    if (uri.isEmpty) return ref;
    var up = uri.split("/");
    var rp = ref.split("/");
    if (context.resourceNames.contains(up[up.length - 2]) &&
        context.resourceNames.contains(rp[0])) {
      var b = StringBuffer();
      for (int i = 0; i < up.length - 2; i++) {
        b.write(up[i]);
        b.write("/");
      }
      b.write(ref);
      return b.toString();
    } else {
      return ref;
    }
  }

  String describeReference(String? reference) {
    return reference ?? 'null';
  }

// A placeholder function for hintOrError, assuming its implementation is defined elsewhere.
  void hintOrError(
      bool isError,
      List<dynamic> errors,
      DateTime ruleDate,
      String issueType,
      dynamic stack,
      bool thePass,
      String i18nConstant,
      String ref,
      String name) {
    // Implementation depends on the application's error handling logic.
  }

  r5.Resource? resolveInBundle({
    required r5.Bundle bundle,
    required String ref,
    String? fullUrl,
    String? type,
    String? id,
    // NodeStack stack, assuming it's defined according to your application's structure.
    List<dynamic>?
        errors, // Assuming a generic type for demonstration; this should be tailored to your error handling structure.
    required String name,
    r5.Resource? source,
    required bool isWarning,
  }) {
    var foundResources = <r5.Resource>[];

    for (var entry in bundle.entry ?? []) {
      var entryResource = entry.resource;
      var entryFullUrl = entry.fullUrl?.value ?? '';

      if (entryResource != null) {
        var resourceType = entryResource.fhirType();
        var resourceId = entryResource.id;

        // Matching fullUrl or type/id combination.
        if (ref == entryFullUrl ||
            (type != null &&
                id != null &&
                ref == "$resourceType/$resourceId")) {
          foundResources.add(entryResource);
        }
      }
    }

    // Handling based on the number of resources found.
    if (foundResources.isEmpty) {
      // Log or handle the case when no resource is found.
      if (!isWarning) {
        // Assume this function is defined elsewhere according to your error handling logic.
        hintOrError(false, errors ?? [], DateTime.now(), "not-found", {}, false,
            "Resource not found: $ref", ref, name);
      }
      return null;
    } else if (foundResources.length == 1) {
      return foundResources.first;
    } else {
      // Handle the case when multiple resources are found.
      // This part depends on how you want to handle multiple matches, which might not be applicable or needs specific handling based on your application logic.
      // For simplicity, returning null here, but you should implement according to your needs.
      return null;
    }
  }

  String extractResourceType(String ref) {
    var parts = ref.split('/');
    return parts[parts.length - 2];
  }

// Adjusting the method signature and return type to fit Dart conventions and making assumptions on some parameter types.
  r5.BundleEntry? getFromBundle({
    required Bundle bundle,
    required String ref,
    String? fullUrl,
    required List<dynamic>
        errors, // Assuming dynamic for errors; should be adjusted according to your error handling structure.
    required String path,
    String? type,
    required bool isTransaction,
    required BooleanHolder
        bh, // Assuming BooleanHolder is defined elsewhere in your project.
  }) {
    String? targetUrl;
    String version = '';
    String? resourceType;
    if (ref.startsWith('http:') ||
        ref.startsWith('urn:') ||
        isAbsoluteUrl(ref)) {
      // Handle absolute reference
      if (ref.contains('/_history/')) {
        var parts = ref.split('/_history/');
        targetUrl = parts.first;
        version = parts[1];
      } else {
        targetUrl = ref;
      }
    } else if (fullUrl == null) {
      // Handle missing fullUrl
      // Assuming rule and warning are implemented to log or handle this case.
    } else {
      // Handle relative reference
      var id = ref.split('/').last;
      targetUrl =
          fullUrl.contains('urn:') ? fullUrl + ':' + id : fullUrl + '/' + id;
    }

    var entries =
        bundle.entry?.where((entry) => entry.fullUrl == targetUrl) ?? [];
    BundleEntry? match;
    var matchIndex = -1;

    for (var i = 0; i < entries.length; i++) {
      var we = entries.elementAt(i);
      var r = we.resource;
      if (r != null) {
        // Additional logic here to handle version matching and setting match if conditions are met
      }
    }

    // Additional logic to handle matching and errors based on your requirements

    return match;
  }

  bool isAbsoluteUrl(String url) {
    // Implement according to how you'd like to determine if a URL is absolute.
    return Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  String resolveUri(String uri, String ref) {
    // Implement the URI resolution logic here, similar to the `resolve` method in Java.
    // This is a placeholder implementation.
    return uri + '/' + ref;
  }
}

class TrackedLocationRelatedMessage {
  Object location;
  ValidationMessage vmsg;
  TrackedLocationRelatedMessage(this.location, this.vmsg);
}

class ValidationControl {
  bool allowed;
  IssueSeverity level;

  ValidationControl(this.allowed, this.level);
}

class BooleanHolder {
  bool value = true;

  BooleanHolder({bool value = true});

  void fail() {
    value = false;
  }

  bool ok() {
    return value;
  }

  void see(bool ok) {
    value = value && ok;
  }
}
