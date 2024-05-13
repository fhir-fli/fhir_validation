abstract class IElementDefinitionSummary {
  String get elementName;

  bool get isCollection;

  bool get isRequired;

  bool get inSummary;

  bool get isChoiceElement;

  bool get isResource;

  /// If this modifies the meaning of other elements
  bool get isModifier;

  List<ITypeSerializationInfo> get type;

  /// Logical Models where a choice type is represented by ElementDefinition.representation
  /// = typeAttr might define a default type (elementdefinition-defaulttype extension).
  /// null in most cases.
  String get defaultTypeName;

  /// This is the namespace used for the xml node representing this element. Only need
  /// to be set if different from "http://hl7.org/fhir".
  String get nonDefaultNamespace;

  /// The kind of node used to represent this element in XML. Default is Hl7.Fhir.Specification.XmlRepresentation.XmlElement.
  XmlRepresentation get representation;

  int get order;
}
