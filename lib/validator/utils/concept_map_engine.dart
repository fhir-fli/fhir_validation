import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fhir/r5.dart';

import '../validation.dart';

class ConceptMapEngine {
  ConceptMapEngine();

  Future<Coding?> translate(Coding source, String url) async {
    final response = await http.get(Uri.parse(url));
    final ConceptMap? cm = ConceptMap.fromJson(json.decode(response.body));
    if (cm == null) {
      throw Exception("Unable to find ConceptMap '$url'");
    }
    if (source.system != null) {
      return translateBySystem(
          cm, source.system!.toString(), source.code!.toString());
    } else {
      return translateByJustCode(cm, source.code!.toString());
    }
  }

  Future<Coding?> translateByJustCode(ConceptMap cm, String code) async {
    ConceptMapElement? ct;
    ConceptMapGroup? cg;
    for (var g in cm.group!) {
      for (var e in g.element) {
        if (code == e.code) {
          if (ct != null) {
            throw Exception(
                "Unable to process translate $code because multiple candidate matches were found in concept map ${cm.url}");
          }
          ct = e;
          cg = g;
        }
      }
    }
    if (ct == null) {
      return null;
    }
    ConceptMapTarget? tt;
    for (var t in ct.target!) {
      if ((t.dependsOn?.isEmpty ?? true) &&
          (t.product?.isEmpty ?? true) &&
          isOkRelationship(t.relationship)) {
        if (tt != null) {
          throw Exception(
              "Unable to process translate $code because multiple targets were found in concept map ${cm.url}");
        }
        tt = t;
      }
    }
    if (tt == null) {
      return null;
    }
    // Assuming CanonicalPair is a Dart class to handle the system URL and version parsing
    final cp = CanonicalPair(cg!.target?.toString());
    return Coding(
        system: cp.url == null ? null : FhirUri(cp.url),
        version: cp.version,
        code: tt.code,
        display: tt.display);
  }

  bool isOkRelationship(FhirCode? relationship) {
    return relationship != null && relationship != FhirCode('not-related-to');
  }

  Future<Coding> translateBySystem(
      ConceptMap cm, String system, String code) async {
    throw UnimplementedError("Not done yet");
  }
}
