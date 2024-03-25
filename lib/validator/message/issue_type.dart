enum IssueType {
  invalid,
  structure,
  required,
  value,
  invariant,
  security,
  login,
  unknown,
  expired,
  forbidden,
  suppressed,
  processing,
  notSupported,
  duplicate,
  notFound,
  tooLong,
  codeInvalid,
  extension,
  tooCostly,
  businessRule,
  conflict,
  incomplete,
  transient,
  lockError,
  noStore,
  exception,
  timeout,
  throttled,
  informational,
  none;

  String toCode() {
    switch (this) {
      case IssueType.invalid:
        return "invalid";
      case IssueType.structure:
        return "structure";
      case IssueType.required:
        return "required";
      case IssueType.value:
        return "value";
      case IssueType.invariant:
        return "invariant";
      case IssueType.security:
        return "security";
      case IssueType.login:
        return "login";
      case IssueType.unknown:
        return "unknown";
      case IssueType.expired:
        return "expired";
      case IssueType.forbidden:
        return "forbidden";
      case IssueType.suppressed:
        return "suppressed";
      case IssueType.processing:
        return "processing";
      case IssueType.notSupported:
        return "not-supported";
      case IssueType.duplicate:
        return "duplicate";
      case IssueType.notFound:
        return "not-found";
      case IssueType.tooLong:
        return "too-long";
      case IssueType.codeInvalid:
        return "code-invalid";
      case IssueType.extension:
        return "extension";
      case IssueType.tooCostly:
        return "too-costly";
      case IssueType.businessRule:
        return "business-rule";
      case IssueType.conflict:
        return "conflict";
      case IssueType.incomplete:
        return "incomplete";
      case IssueType.transient:
        return "transient";
      case IssueType.lockError:
        return "lock-error";
      case IssueType.noStore:
        return "no-store";
      case IssueType.exception:
        return "exception";
      case IssueType.timeout:
        return "timeout";
      case IssueType.throttled:
        return "throttled";
      case IssueType.informational:
        return "informational";
      case IssueType.none:
        return "none";
    }
  }

  String getSystem() {
    return "http://hl7.org/fhir/issue-type";
  }

  String getDefinition() {
    switch (this) {
      case IssueType.invalid:
        return "Content invalid against the specification or a profile.";
      case IssueType.structure:
        return "A structural issue in the content such as wrong namespace, or unable to parse the content completely, or invalid json syntax.";
      case IssueType.required:
        return "A required element is missing.";
      case IssueType.value:
        return "An element value is invalid.";
      case IssueType.invariant:
        return "A content validation rule failed - e.g. a schematron rule.";
      case IssueType.security:
        return "An authentication/authorization/permissions issue of some kind.";
      case IssueType.login:
        return "The client needs to initiate an authentication process.";
      case IssueType.unknown:
        return "The user or system was not able to be authenticated (either there is no process, or the proferred token is unacceptable).";
      case IssueType.expired:
        return "User session expired; a login may be required.";
      case IssueType.forbidden:
        return "User rights or system permissions issue.";
      case IssueType.suppressed:
        return "The system was capable of returning a response (or not) but chose not to return it (as opposed to failing to do so).";
      case IssueType.processing:
        return "The processing is not complete, the server is not yet capable of returning a response.";
      case IssueType.notSupported:
        return "The server does not support the functionality required to fulfill the request.";
      case IssueType.duplicate:
        return "An attempt was made to create a duplicate record.";
      case IssueType.notFound:
        return "The reference provided was not found.";
      case IssueType.tooLong:
        return "Provided content is too long (typically, this is a denial of service protection type of error).";
      case IssueType.codeInvalid:
        return "The code or system could not be understood, or it was not valid in the context of a particular ValueSet.";
      case IssueType.extension:
        return "An extension was found that was not acceptable, could not be resolved, or a modifierExtension that was not recognized.";
      case IssueType.tooCostly:
        return "The operation was stopped to protect server resources; e.g. a request for a value set expansion on all of SNOMED CT.";
      case IssueType.businessRule:
        return "The content/operation failed to pass some business rule, and so could not proceed.";
      case IssueType.conflict:
        return "Content could not be accepted because of an edit conflict.";
      case IssueType.incomplete:
        return "One or more operations issued against multiple resources were stopped because the entire set would have failed.";
      case IssueType.transient:
        return "Transient processing issues. The system receiving the error may be able to resubmit the same content once an underlying issue is resolved.";
      case IssueType.lockError:
        return "A resource/record locking failure.";
      case IssueType.noStore:
        return "An error occurred in the storage layer that may be recoverable.";
      case IssueType.exception:
        return "An unexpected internal error.";
      case IssueType.timeout:
        return "An internal timeout occurred.";
      case IssueType.throttled:
        return "The system is doing excessive processing, and the processing has been stopped.";
      case IssueType.informational:
        return "A message unrelated to the processing success of the completed operation (examples of the latter include things like reminders of password expiry, system maintenance, etc.).";
      case IssueType.none:
        return '';
    }
  }

  String getDisplay() {
    switch (this) {
      case IssueType.invalid:
        return "Invalid Content";
      case IssueType.structure:
        return "Structural Issue";
      case IssueType.required:
        return "Required element missing";
      case IssueType.value:
        return "Element value invalid";
      case IssueType.invariant:
        return "Validation rule failed";
      case IssueType.security:
        return "Security Problem";
      case IssueType.login:
        return "Login Required";
      case IssueType.unknown:
        return "Unknown User";
      case IssueType.expired:
        return "Session Expired";
      case IssueType.forbidden:
        return "Forbidden";
      case IssueType.suppressed:
        return "Information not available";
      case IssueType.processing:
        return "Processing Failure";
      case IssueType.notSupported:
        return "Not Supported";
      case IssueType.duplicate:
        return "Duplicate";
      case IssueType.notFound:
        return "Not Found";
      case IssueType.tooLong:
        return "Too Long";
      case IssueType.codeInvalid:
        return "Code Invalid";
      case IssueType.extension:
        return "Extension";
      case IssueType.tooCostly:
        return "Too Costly";
      case IssueType.businessRule:
        return "Business Rule";
      case IssueType.conflict:
        return "Edit Conflict";
      case IssueType.incomplete:
        return "Incomplete";
      case IssueType.transient:
        return "Transient Issue";
      case IssueType.lockError:
        return "Lock Error";
      case IssueType.noStore:
        return "No Store";
      case IssueType.exception:
        return "Exception";
      case IssueType.timeout:
        return "Timeout";
      case IssueType.throttled:
        return "Throttled";
      case IssueType.informational:
        return "Informational Note";
      case IssueType.none:
        return '';
    }
  }
}

extension IssueTypeExtension on IssueType {
  static IssueType fromCode(String code) {
    switch (code) {
      case "invalid":
        return IssueType.invalid;
      case "structure":
        return IssueType.structure;
      case "required":
        return IssueType.required;
      case "value":
        return IssueType.value;
      case "invariant":
        return IssueType.invariant;
      case "security":
        return IssueType.security;
      case "login":
        return IssueType.login;
      case "unknown":
        return IssueType.unknown;
      case "expired":
        return IssueType.expired;
      case "forbidden":
        return IssueType.forbidden;
      case "suppressed":
        return IssueType.suppressed;
      case "processing":
        return IssueType.processing;
      case "not-supported":
        return IssueType.notSupported;
      case "duplicate":
        return IssueType.duplicate;
      case "not-found":
        return IssueType.notFound;
      case "too-long":
        return IssueType.tooLong;
      case "code-invalid":
        return IssueType.codeInvalid;
      case "extension":
        return IssueType.extension;
      case "too-costly":
        return IssueType.tooCostly;
      case "business-rule":
        return IssueType.businessRule;
      case "conflict":
        return IssueType.conflict;
      case "incomplete":
        return IssueType.incomplete;
      case "transient":
        return IssueType.transient;
      case "lock-error":
        return IssueType.lockError;
      case "no-store":
        return IssueType.noStore;
      case "exception":
        return IssueType.exception;
      case "timeout":
        return IssueType.timeout;
      case "throttled":
        return IssueType.throttled;
      case "informational":
        return IssueType.informational;
      case "none":
        return IssueType.none;
      default:
        throw Exception('Unknown IssueType code: $code');
    }
  }
}
