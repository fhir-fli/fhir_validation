class ElementInfo {

  List<ValidationMessage> sliceInfo;
  int index; // order of definition in overall order. all slices get the index of the slicing definition
  int sliceindex; // order of the definition in the slices (if slice != null)
  int count;
  ElementDefinition definition;
  ElementDefinition slice;
  bool additionalSlice; // If true, indicates that this element is an additional slice
  private Element element;
  private String name;
  private String path;

  ElementInfo(String name, Element element, String path, int count) {
    this.name = name;
    this.element = element;
    this.path = path;
    this.count = count;
  }


  bool isAdditionalSlice() {
    return additionalSlice;
  }


  int col() {
    return element.col();
  }

  int line() {
    return element.line();
  }

  @override
  String toString() {
    return path;
  }
}