import 'package:fhir/r5.dart';

class MeasureContext {
  static const String userDataElm = 'validator.ELM';
  final List<Library> _libraries = [];
  final Measure? measure;
  final Element? report;

  MeasureContext({this.measure, this.report});

  void seeLibrary(Library library) {
    _libraries.add(library);
    for (final attachment in library.content ?? []) {
      if (attachment.contentType?.value == 'application/elm+xml') {
        try {
          // Assuming you have a function to parse XML to DOM-like structure in Dart.
          // XML parsing and manipulation is a bit different in Dart and may require using packages like 'xml'.
          final elmData = parseXmlToDom(attachment.data?.value ?? '');
          library.setUserData(userDataElm, elmData);
        } catch (e) {
          library.setUserData(userDataElm, e.toString());
        }
      }
    }
  }

  List<MeasureGroup>? groups() => measure?.group;

  String? reportType() => report?.getChildValue('type');
  String? scoring() => measure?.scoring?.coding?.first.code?.value;
  List<Library> get libraries => _libraries;

  // Assuming a function that mimics the XML parsing in Java. This is just a placeholder.
  dynamic parseXmlToDom(String xmlData) {
    // Implement XML parsing or use an existing library
    return null;
  }
}
