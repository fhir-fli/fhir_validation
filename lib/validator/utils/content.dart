import '../validation.dart';

class Content {
  List<int>?
      _focus; // Using List<int> to represent binary data, assuming ByteProvider's equivalent
  FhirFormat? _cntType;

  // Constructor, if needed, can be added here
  Content({List<int>? focus, FhirFormat? cntType})
      : _focus = focus,
        _cntType = cntType;

  // Getters and setters
  List<int>? get focus => _focus;
  set focus(List<int>? focus) => _focus = focus;

  FhirFormat? get cntType => _cntType;
  set cntType(FhirFormat? cntType) => _cntType = cntType;

  // Example file name getter
  String get exampleFileName {
    if (_cntType != null) {
      return "file.${_cntType!.extension}";
    } else {
      return "file.bin";
    }
  }
}
