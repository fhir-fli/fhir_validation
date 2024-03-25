import 'package:fhir_primitives/fhir_primitives.dart';
import 'package:fhir_r5/fhir_r5.dart' as r5;

import '../validation.dart';

class ValueSetUtilities {
  static bool isServerSide(String url) {
    return ['http://hl7.org/fhir/sid/cvx'].contains(url);
  }

  r5.ValueSet makeShareable(r5.ValueSet vs) {
    if (vs.experimental == null) {
      vs = vs.copyWith(experimental: FhirBoolean(false));
    }
    if (vs.meta == null) vs = vs.copyWith(meta: r5.FhirMeta());

    for (FhirCanonical c in vs.meta?.profile ?? <FhirCanonical>[])
      if (c.value?.toString() ==
          "http://hl7.org/fhir/StructureDefinition/shareablevalueset") {
        return vs;
      }
    vs = vs.copyWith(
        meta: vs.meta?.copyWith(profile: <FhirCanonical>[
      ...vs.meta?.profile ?? <FhirCanonical>[],
      FhirCanonical('http://hl7.org/fhir/StructureDefinition/shareablevalueset')
    ]));
    return vs;
  }

  bool makeVSShareable(r5.ValueSet vs) {
    if (vs.meta == null) {
      return true;
    }
    for (FhirCanonical c in vs.meta?.profile ?? <FhirCanonical>[])
      if (c.value?.toString() ==
          "http://hl7.org/fhir/StructureDefinition/shareablevalueset") {
        return false;
      }
    return true;
  }

  void checkShareable(r5.ValueSet vs) {
    if (vs.meta == null) {
      throw Exception("ValueSet ${vs.url} is not shareable");
    }
    for (FhirCanonical t in vs.meta?.profile ?? <FhirCanonical>[]) {
      if (t.value.toString() ==
          "http://hl7.org/fhir/StructureDefinition/shareablevalueset") {
        return;
      }
    }
    throw Exception("ValueSet ${vs.url} is not shareable");
  }

  bool hasOID(r5.ValueSet vs) {
    return getOID(vs) != null;
  }

  String? getOID(r5.ValueSet vs) {
    for (r5.Identifier id in vs.identifier ?? <r5.Identifier>[]) {
      if ("urn:ietf:rfc:3986" == id.system.toString() &&
          id.value != null &&
          id.value.toString().startsWith("urn:oid:")) {
        return id.value.toString().substring(8);
      }
    }
    return null;
  }

  void setOID(r5.ValueSet vs, String oid) {
    if (!oid.startsWith("urn:oid:")) oid = "urn:oid:" + oid;
    for (int i = 0; i < (vs.identifier?.length ?? 0); i++) {
      r5.Identifier? id = vs.identifier?[i];
      if ("urn:ietf:rfc:3986" == id?.system.toString() &&
          id?.value != null &&
          (id!.value?.startsWith("urn:oid:") ?? false)) {
        id = id.copyWith(value: oid);
        return;
      }
    }
    vs = vs.copyWith(identifier: <r5.Identifier>[
      ...vs.identifier ?? <r5.Identifier>[],
      r5.Identifier(system: FhirUri('urn:ietf:rfc:3986'), value: oid)
    ]);
  }

  void markStatus(
      r5.ValueSet vs,
      String? wg,
      StandardsStatus status,
      String pckage,
      String fmm,
      IWorkerContext context,
      String normativeVersion) {
    if (vs.userData.containsKey("external.url")) return;

    if (wg != null) {
      if (!ToolingExtensions.hasExtension(vs, ToolingExtensions.extWorkgroup) ||
          (!Utilities.existsInList(
                  ToolingExtensions.readStringExtension(
                      vs, ToolingExtensions.extWorkgroup),
                  ["fhir", "vocab"]) &&
              Utilities.existsInList(wg, ["fhir", "vocab"]))) {
        ToolingExtensions.setCodeExtension(
            vs, ToolingExtensions.extWorkgroup, wg);
      }
    }
    if (status != null) {
      var ss = ToolingExtensions.getStandardsStatus(vs);
      if (ss == null || ss.isLowerThan(status))
        ToolingExtensions.setStandardsStatus(vs, status, normativeVersion);
      if (pckage != null) {
        if (!vs.userData.containsKey("ballot.package")) {
          vs.userData["ballot.package"] = pckage;
        } else if (pckage != vs.userData["ballot.package"]) {
          if ("infrastructure" != vs.userData["ballot.package"]) {
            print(
                "Value Set ${vs.url}: ownership clash $pckage vs ${vs.userData['ballot.package']}");
          }
        }
      }
      if (status == StandardsStatus.normative) {
        vs = vs.copyWith(experimental: FhirBoolean(false));
        vs = vs.copyWith(status: r5.PublicationStatus.active);
      }
    }
    if (fmm != null) {
      var sfmm = ToolingExtensions.readStringExtension(
          vs, ToolingExtensions.extFmmLevel);
      if (sfmm.isEmpty || int.parse(sfmm) < int.parse(fmm)) {
        ToolingExtensions.setIntegerExtension(
            vs, ToolingExtensions.extFmmLevel, int.parse(fmm));
      }
      if (int.parse(fmm) <= 1) {
        vs = vs.copyWith(experimental: FhirBoolean(true));
      }
    }
    // Assume `vs.userData["cs"]` is of type CodeSystem. You might need a safe cast or check.
    if (vs.userData.containsKey("cs")) {
      // Assume CodeSystemUtilities.markStatus exists
      // CodeSystemUtilities.markStatus(vs.userData["cs"] as r5.CodeSystem, wg, status, pckage, fmm, normativeVersion);
    } else if (status == StandardsStatus.normative && context != null) {
      for (var csc in vs.compose.include) {
        if (csc.system != null) {
          // Fetch the CodeSystem from the context. You need to implement context.fetchCodeSystem.
          var cs = context.fetchCodeSystem(csc.system);
          if (cs != null) {
            // CodeSystemUtilities.markStatus(cs, wg, status, pckage, fmm, normativeVersion);
          }
        }
      }
    }
  }

  // private static int ssval(String status) {
  //   if ("Draft".equals("status"))
  //     return 1;
  //   if ("Informative".equals("status"))
  //     return 2;
  //   if ("External".equals("status"))
  //     return 3;
  //   if ("Trial Use".equals("status"))
  //     return 3;
  //   if ("Normative".equals("status"))
  //     return 4;
  //   return -1;
  // }

  //  r5.ValueSet generateImplicitValueSet(String uri) {
  //   if (uri.startsWith("http://snomed.info/sct"))
  //     return generateImplicitSnomedValueSet(uri);
  //   if (uri.startsWith("http://loinc.org/vs"))
  //     return generateImplicitLoincValueSet(uri);
  //   if (uri.equals("http://hl7.org/fhir/ValueSet/mimetypes")) {
  //     return generateImplicitMimetypesValueSet(uri);
  //   }
  //   return null;
  // }

  // private static r5.ValueSet generateImplicitMimetypesValueSet(String theUri) {
  //   r5.ValueSet valueSet = new r5.ValueSet();
  //   valueSet.setStatus(PublicationStatus.ACTIVE);
  //   valueSet.setUrl(theUri);
  //   valueSet.setDescription("This value set includes all possible codes from BCP-13 (http://tools.ietf.org/html/bcp13)");
  //   valueSet.getCompose()
  //     .addInclude().setSystem("urn:ietf:bcp:13");
  //   return valueSet;
  // }

  // private static r5.ValueSet generateImplicitLoincValueSet(String uri) {
  //   if ("http://loinc.org/vs".equals(uri))
  //     return makeLoincValueSet();
  //   if (uri.startsWith("http://loinc.org/vs/LL"))
  //     return makeAnswerList(makeLoincValueSet(), uri);
  //   return null;
  // }

  // private static r5.ValueSet makeAnswerList(r5.ValueSet vs, String uri) {
  //   vs.setUrl(uri);
  //   String c = uri.substring(20);
  //   vs.setName("LOINCAnswers"+c);
  //   vs.setTitle("LOINC Answer Codes for "+c);
  //   vs.getCompose().getIncludeFirstRep().addFilter().setProperty("LIST").setOp(FilterOperator.EQUAL).setValue(c);
  //   return vs;
  // }

  // private static r5.ValueSet makeLoincValueSet() {
  //   r5.ValueSet vs = new r5.ValueSet();
  //   vs.setUrl("http://loinc.org/vs");
  //   vs.setName("LOINCCodes");
  //   vs.setTitle("All LOINC codes");
  //   vs.setCopyright("This content LOINC® is copyright © 1995 Regenstrief Institute, Inc. and the LOINC Committee, and available at no cost under the license at http://loinc.org/terms-of-use");
  //   vs.setStatus(PublicationStatus.ACTIVE);
  //   vs.getCompose().addInclude().setSystem("http://loinc.org");
  //   return vs;
  // }

  // private static r5.ValueSet generateImplicitSnomedValueSet(String uri) {
  //   if ("http://snomed.info/sct?fhir_vs".equals(uri))
  //     return makeImplicitSnomedValueSet(uri);
  //   return null;
  // }

  // private static r5.ValueSet makeImplicitSnomedValueSet(String uri) {
  //   r5.ValueSet vs = new r5.ValueSet();
  //   vs.setUrl(uri);
  //   vs.setName("SCTValueSet");
  //   vs.setTitle("SCT ValueSet");
  //   vs.setDescription("All SNOMED CT Concepts");
  //   vs.setCopyright("This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (SNOMED International), and distributed by agreement between SNOMED International and HL7. Implementer use of SNOMED CT is not covered by this agreement");
  //   vs.setStatus(PublicationStatus.ACTIVE);
  //   vs.getCompose().addInclude().setSystem("http://snomed.info/sct");
  //   return vs;
  // }

  //  void setDeprecated(List<ValueSetExpansionPropertyComponent> vsProp,  ValueSetExpansionContainsComponent n) {
  //   n.addProperty().setCode("status").setValue(new CodeType("deprecated"));
  //   for (ValueSetExpansionPropertyComponent o : vsProp) {
  //     if ("status".equals(o.getCode())) {
  //       return;
  //     }
  //   }
  //   vsProp.add(new ValueSetExpansionPropertyComponent().setCode("status").setUri("http://hl7.org/fhir/concept-properties#status"));
  // }

  //  class ConceptReferenceComponentSorter implements Comparator<ConceptReferenceComponent> {

  //   @Override
  //   public int compare(ConceptReferenceComponent o1, ConceptReferenceComponent o2) {
  //     return o1.getCode().compareToIgnoreCase(o2.getCode());
  //   }
  // }

  //  void sortInclude(ConceptSetComponent inc) {
  //   Collections.sort(inc.getConcept(), new ConceptReferenceComponentSorter());
  // }

  //  String getAllCodesSystem(r5.ValueSet vs) {
  //   if (vs.hasCompose()) {
  //     ValueSetComposeComponent c = vs.getCompose();
  //     if (c.getExclude().isEmpty() && c.getInclude().size() == 1) {
  //       ConceptSetComponent i = c.getIncludeFirstRep();
  //       if (i.hasSystem() && !i.hasValueSet() && !i.hasConcept() && !i.hasFilter()) {
  //         return i.getSystem();
  //       }
  //     }
  //   }
  //   return null;
  // }

  //  bool isDeprecated(r5.ValueSet vs, ValueSetExpansionContainsComponent c) {
  //   try {
  //     for (org.hl7.fhir.r5.model.ValueSet.ConceptPropertyComponent p : c.getProperty()) {
  //       if ("status".equals(p.getCode()) && p.hasValue() && p.hasValueCodeType() && "deprecated".equals(p.getValueCodeType().getCode())) {
  //         return true;
  //       }
  //       // this, though status should also be set
  //       if ("deprecationDate".equals(p.getCode()) && p.hasValue() && p.getValue() instanceof DateTimeType)
  //         return ((DateTimeType) p.getValue()).before(new DateTimeType(Calendar.getInstance()));
  //       // legacy
  //       if ("deprecated".equals(p.getCode()) && p.hasValue() && p.getValue() instanceof BooleanType)
  //         return ((BooleanType) p.getValue()).getValue();
  //     }
  //     StandardsStatus ss = ToolingExtensions.getStandardsStatus(c);
  //     if (ss == StandardsStatus.DEPRECATED) {
  //       return true;
  //     }
  //     return false;
  //   } catch (FHIRException e) {
  //     return false;
  //   }
  // }

  //  bool hasCodeInExpansion(r5.ValueSet vs, Coding code) {
  //   return hasCodeInExpansion(vs.getExpansion().getContains(), code);
  // }

  // private static bool hasCodeInExpansion(List<ValueSetExpansionContainsComponent> list, Coding code) {
  //   for (ValueSetExpansionContainsComponent c : list) {
  //     if (c.getSystem().equals(code.getSystem()) && c.getCode().equals(code.getCode())) {
  //       return true;
  //     }
  //     if (hasCodeInExpansion(c.getContains(), code)) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  //  void addProperty(r5.ValueSet vs, ValueSetExpansionContainsComponent ctxt, String url, String code, String value) {
  //   if (value != null) {
  //     addProperty(vs, ctxt, url, code, new StringType(value));
  //   }
  // }

  //  void addProperty(r5.ValueSet vs, ValueSetExpansionContainsComponent ctxt, String url, String code, Integer value) {
  //   if (value != null) {
  //     addProperty(vs, ctxt, url, code, new IntegerType(value));
  //   }
  // }

  //  void addProperty(r5.ValueSet vs, ValueSetExpansionContainsComponent ctxt, String url, String code, DataType value) {
  //   code = defineProperty(vs, url, code);
  //   org.hl7.fhir.r5.model.ValueSet.ConceptPropertyComponent p = getProperty(ctxt.getProperty(),  code);
  //   if (p != null)
  //     p.setValue(value);
  //   else
  //     ctxt.addProperty().setCode(code).setValue(value);

  // }

  // private static org.hl7.fhir.r5.model.ValueSet.ConceptPropertyComponent getProperty(List<org.hl7.fhir.r5.model.ValueSet.ConceptPropertyComponent> list, String code) {
  //   for (org.hl7.fhir.r5.model.ValueSet.ConceptPropertyComponent t : list) {
  //     if (code.equals(t.getCode())) {
  //       return t;
  //     }
  //   }
  //   return null;
  // }

  // private static String defineProperty(r5.ValueSet vs, String url, String code) {
  //   for (ValueSetExpansionPropertyComponent p : vs.getExpansion().getProperty()) {
  //     if (p.hasUri() && p.getUri().equals(url)) {
  //       return p.getCode();
  //     }
  //   }
  //   for (ValueSetExpansionPropertyComponent p : vs.getExpansion().getProperty()) {
  //     if (p.hasCode() && p.getCode().equals(code)) {
  //       p.setUri(url);
  //       return code;
  //     }
  //   }
  //   ValueSetExpansionPropertyComponent p = vs.getExpansion().addProperty();
  //   p.setUri(url);
  //   p.setCode(code);
  //   return code;
  // }

  //  int countExpansion(r5.ValueSet valueset) {
  //   int i = valueset.getExpansion().getContains().size();
  //   for (ValueSetExpansionContainsComponent t : valueset.getExpansion().getContains()) {
  //     i = i + countExpansion(t);
  //   }
  //   return i;
  // }

  // private static int countExpansion(ValueSetExpansionContainsComponent c) {
  //   int i = c.getContains().size();
  //   for (ValueSetExpansionContainsComponent t : c.getContains()) {
  //     i = i + countExpansion(t);
  //   }
  //   return i;
  // }

  //  Set<String> listSystems(IWorkerContext ctxt, r5.ValueSet vs) {
  //   Set<String> systems = new HashSet<>();
  //   for (ConceptSetComponent inc : vs.getCompose().getInclude()) {
  //     for (CanonicalType ct : inc.getValueSet()) {
  //       r5.ValueSet vsr = ctxt.fetchResource(ValueSet.class, ct.asStringValue(), vs);
  //       if (vsr != null) {
  //         systems.addAll(listSystems(ctxt, vsr));
  //       }
  //     }
  //     if (inc.hasSystem()) {
  //       systems.add(inc.getSystem());
  //     }
  //   }
  //   return systems;
  // }
}
