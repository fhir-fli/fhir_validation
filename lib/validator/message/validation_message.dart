import 'message.dart';

class ValidationMessage implements Comparable<ValidationMessage> {
  // Assuming Source is an enum or class you've defined elsewhere
  Source? source;
  String? server;
  int? line;
  int? col;
  String? location; // fhirPath
  String? message;
  String? messageId; // source, for grouping
  IssueType? type;
  IssueSeverity? level;
  String? html;
  String? locationLink;
  String? txLink;
  String? sliceHtml;
  List<String>? sliceText;
  bool slicingHint = false;
  bool signpost = false;
  bool criticalSignpost = false;
  DateTime? ruleDate;
  static final String? noRuleDate = null;
  bool matched = false; // internal use counting matching filters
  bool ignorableError = false;
  String? invId;
  String? comment;
  List<ValidationMessage>? sliceInfo;

  ValidationMessage({
    this.source,
    this.server,
    this.line,
    this.col,
    this.location,
    this.message,
    this.messageId,
    this.type,
    this.level,
    this.html,
    this.locationLink,
    this.txLink,
    this.sliceHtml,
    this.sliceText,
    this.slicingHint = false,
    this.signpost = false,
    this.criticalSignpost = false,
    this.ruleDate,
    this.matched = false,
    this.ignorableError = false,
    this.invId,
    this.comment,
    this.sliceInfo,
  });

  @override
  int compareTo(ValidationMessage other) {
    // Implement comparison logic based on your requirements
    return 0;
  }

  bool get isSignpost {
    return signpost || criticalSignpost;
  }

  // Method to determine the level based on the path
  IssueSeverity determineLevel(String path) {
    if (isGrandfathered(path)) {
      return IssueSeverity.warning;
    } else {
      return IssueSeverity.error;
    }
  }

  // Method to check if a path is grandfathered
  bool isGrandfathered(String path) {
    var grandfatheredPaths = [
      "xds-documentmanifest.",
      "observation-device-metric-devicemetricobservation.",
      "medicationadministration-immunization-vaccine.",
      "elementdefinition-de-dataelement.",
      "dataelement-sdc-sdcelement.",
      "questionnaireresponse-sdc-structureddatacaptureanswers.",
      "valueset-sdc-structureddatacapturevalueset.",
      "dataelement-sdc-de-sdcelement.",
      "do-uslab-uslabdo.",
    ];
    return grandfatheredPaths.any((gp) => path.startsWith(gp));
  }

  // Method to generate a summary of the message
  String summary() {
    var locInfo = location != null ? " @ $location" : "";
    var lineColInfo =
        (line != null && col != null) ? " (line $line, col $col)" : "";
    var serverInfo = server != null ? " (src = $server)" : "";
    return "${level.toString()}$locInfo$lineColInfo: $message$serverInfo";
  }

  // Assuming you will handle HTML escape on your own or using a library
  String getHtml() {
    return html ?? _escapeXml(message!);
  }

  // Method to get a displayable string representing this message
  String getDisplay() {
    var locDisplay =
        location != null && location!.isNotEmpty ? "$location: " : "";
    return "${level.toString()}: $locDisplay$message";
  }

  // Method toString is omitted because Dart's Object class already includes a toString method.
  // You can override it if you need a specific representation.

  // Method to compare two ValidationMessages (compareTo already defined in the interface implementation).

  // Additional method for HTML escaping, conceptual only
  String _escapeXml(String input) {
    // Placeholder: implement XML/HTML escape of 'input' as needed or use a library
    return input;
  }

  factory ValidationMessage.fromJson(Map<String, dynamic> json) {
    return ValidationMessage(
      source: json['source'] as Source,
      server: json['server'] as String,
      line: json['line'] as int,
      col: json['col'] as int,
      location: json['location'] as String,
      message: json['message'] as String,
      messageId: json['messageId'] as String,
      type: json['type'] == null
          ? null
          : IssueTypeExtension.fromCode(json['type']),
      level: json['level'] == null
          ? null
          : IssueSeverityExtension.fromCode(json['level']),
      html: json['html'] as String,
      locationLink: json['locationLink'] as String,
      txLink: json['txLink'] as String,
      sliceHtml: json['sliceHtml'] as String,
      sliceText: json['sliceText'] as List<String>,
      slicingHint: json['slicingHint'] as bool,
      signpost: json['signpost'] as bool,
      criticalSignpost: json['criticalSignpost'] as bool,
      ruleDate: json['ruleDate'] == null
          ? null
          : DateTime.parse(json['ruleDate'] as String),
      matched: json['matched'] as bool,
      ignorableError: json['ignorableError'] as bool,
      invId: json['invId'] as String,
      comment: json['comment'] as String,
      sliceInfo: (json['sliceInfo'] as List<dynamic>?)
          ?.map((e) => ValidationMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'server': server,
      'line': line,
      'col': col,
      'location': location,
      'message': message,
      'messageId': messageId,
      'type': type?.toCode(),
      'level': level?.toCode(),
      'html': html,
      'locationLink': locationLink,
      'txLink': txLink,
      'sliceHtml': sliceHtml,
      'sliceText': sliceText,
      'slicingHint': slicingHint,
      'signpost': signpost,
      'criticalSignpost': criticalSignpost,
      'ruleDate': ruleDate?.toIso8601String(),
      'matched': matched,
      'ignorableError': ignorableError,
      'invId': invId,
      'comment': comment,
      'sliceInfo': sliceInfo?.map((e) => e.toJson()).toList(),
    };
  }
}
