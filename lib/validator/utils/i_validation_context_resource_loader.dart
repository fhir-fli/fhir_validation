import 'package:fhir_r5/fhir_r5.dart';

import '../validation.dart';

abstract class IValidationContextResourceLoader {
  Resource? loadContainedResource(List<ValidationMessage> errors, String path,
      Element resource, String id, Type type);
}

class ValidationContextResourceProxy {
  Resource? resource;
  Element? element;
  IValidationContextResourceLoader? loader;
  List<ValidationMessage>? errors;
  String? path;

  ValidationContextResourceProxy({this.resource});

  ValidationContextResourceProxy.fromElement({
    this.errors,
    this.path,
    this.element,
    this.loader,
  });

  Resource? loadContainedResource(String id, Type type) {
    if (resource == null && loader != null) {
      return loader!.loadContainedResource(errors!, path!, element!, id, type);
    } else if (resource != null) {
      for (var r in (resource?.contained ?? <Resource>[])) {
        if (r.id == id && r.runtimeType == type) {
          return r;
        }
      }
    }
    return null;
  }
}

class ValidationContextCarrier {
  List<ValidationContextResourceProxy> resources = [];

  List<ValidationContextResourceProxy> getResources() => resources;
}
