import 'element.dart'; // Assuming you have an Element class defined
import 'node_stack.dart'; // Assuming you have a NodeStack class defined
import 'validation_context.dart'; // Assuming you have a ValidationContext class defined
import 'structure_definition.dart'; // Assuming you have a StructureDefinition class defined

class ResolvedReference {
  Element? resource;
  Element? focus;
  bool external = false;
  NodeStack? stack;

  ResolvedReference setResource(Element resource) {
    this.resource = resource;
    return this;
  }

  Element? getResource() => resource;

  ResolvedReference setFocus(Element focus) {
    this.focus = focus;
    return this;
  }

  Element? getFocus() => focus;

  bool isExternal() => external;

  ResolvedReference setExternal(bool external) {
    this.external = external;
    return this;
  }

  ResolvedReference setStack(NodeStack stack) {
    this.stack = stack;
    return this;
  }

  NodeStack? getStack() => stack;

  String getType() => focus?.fhirType() ?? '';

  ValidationContext valContext(
      ValidationContext valContext, StructureDefinition profile) {
    if (external) {
      return valContext.forRemoteReference(profile, resource!);
    } else {
      return valContext.forLocalReference(profile, resource!);
    }
  }
}
