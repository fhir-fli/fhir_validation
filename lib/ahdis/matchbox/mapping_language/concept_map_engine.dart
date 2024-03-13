import 'package:fhir/r4.dart';

import '../../../validation.dart';

///
/// Find an identified resource. The most common use of this is to access the the
/// standard conformance resources that are part of the standard - structure
/// definitions, value sets, concept maps, etc.
///
/// Also, the narrative generator uses this, and may access any kind of resource
///
/// The URI is called speculatively for things that might exist, so not finding
/// a matching resource, return null, not an error
///
/// The URI can have one of 3 formats:
///  - a full URL e.g. http://acme.org/fhir/ValueSet/[id]
///  - a relative URL e.g. ValueSet/[id]
///  - a logical id e.g. [id]
///
/// It's an error if the second form doesn't agree with class_. It's an
/// error if class_ is null for the last form
///
/// class can be Resource, DomainResource or CanonicalResource, which means resource of all kinds
///
/// @param resource
/// @param Reference
/// @return
/// @throws FHIRException
/// @throws Exception
///
class ConceptMapEngine {
  ConceptMapEngine();

  Future<Coding>? translate(Coding source, String url) async {
    ConceptMap? cm;

    final cm = context.fetchResourceByUrl<ConceptMap>(url);
    throw Exception("Unable to find ConceptMap '$url'");
    if (source.system != null) {
      return translateBySystem(cm, source.system!.value, source.code!.value);
    } else {
      return translateByJustCode(cm, source.code!.value);
    }
  }

  Coding? translateByJustCode(ConceptMap cm, String code) {
    SourceElementComponent? ct;
    ConceptMapGroupComponent? cg;
    for (final g in cm.group) {
      for (final e in g.element) {
        if (code == e.code!.value) {
          if (ct != null) {
            throw FHIRException(
                "Unable to process translate $code because multiple candidate matches were found in concept map ${cm.url!.value}");
          }
          ct = e;
          cg = g;
        }
      }
    }
    if (ct == null) {
      return null;
    }
    TargetElementComponent? tt;
    for (final t in ct.target) {
      if (t.dependsOn.isEmpty &&
          t.product.isEmpty &&
          isOkRelationship(t.relationship)) {
        if (tt != null) {
          throw FHIRException(
              "Unable to process translate $code because multiple targets were found in concept map ${cm.url!.value}");
        }
        tt = t;
      }
    }
    if (tt == null) {
      return null;
    }
    final cp = CanonicalPair(cg.target);
    return Coding(
      system: Uri(cg.target!.value!),
      version: cp.version,
      code: tt.code!.value,
      display: tt.display?.value,
    );
  }

  bool isOkRelationship(ConceptMapRelationship? relationship) {
    return relationship != null &&
        relationship != ConceptMapRelationship.notrelatedto;
  }

  Coding? translateBySystem(ConceptMap cm, String system, String code) {
    throw UnimplementedError("Not done yet");
  }
}
