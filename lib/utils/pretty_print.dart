import 'dart:convert';

/// Returns a pretty printed JSON string.
const JsonEncoder jsonEncoder = JsonEncoder.withIndent('    ');

/// Returns a pretty printed JSON string.
String jsonPrettyPrint(Map<String, dynamic> map) => jsonEncoder.convert(map);

/// Returns a pretty printed JSON string.
String prettyPrintJson(Map<String, dynamic> map) => jsonEncoder.convert(map);

/// Returns a pretty printed JSON string.
String prettyPrintAnything(dynamic anything) => jsonEncoder.convert(anything);
