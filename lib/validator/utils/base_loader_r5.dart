import 'dart:async';
import 'package:fhir/r5.dart';

abstract class BaseLoaderR5 implements IContextResourceLoader {
  final String urlBase = "http://hl7.org/fhir/";
  final String urlElementDefNamespace =
      "http://hl7.org/fhir/StructureDefinition/elementdefinition-namespace";
  bool patchUrls = false;
  bool killPrimitives = false;
  List<String> types = [];
  ILoaderKnowledgeProviderR5 lkp;
  bool loadProfiles = true;

  BaseLoaderR5(List<String> types, ILoaderKnowledgeProviderR5 lkp) {
    this.types.addAll(types);
    this.lkp = lkp;
  }

  Future<String> getResourcePath(Resource resource) async {
    return lkp.getResourcePath(resource);
  }

  Future<void> setPath(Resource r) async {
    String path = await lkp.getResourcePath(r);
    r.userData['webroot'] = lkp.getWebRoot() ?? '';
    r.webPath = path;
  }

  String patchUrl(String url, String type) {
    if (!patchUrls) {
      return url;
    } else if (url.startsWith("http://hl7.org/fhir/$type/")) {
      return "http://hl7.org/fhir/${versionString()}/${url.substring(20)}";
    } else if (type == "CodeSystem" && url.startsWith("http://hl7.org/fhir/")) {
      return "http://hl7.org/fhir/${versionString()}/${url.substring(20)}";
    } else {
      return url;
    }
  }

  void doPatchUrls(Resource resource);

  // The abstract method versionString needs to be implemented by subclasses
  String versionString();

  Future<IContextResourceLoader> setLoadProfiles(bool value) async {
    loadProfiles = value;
    return this;
  }
}
