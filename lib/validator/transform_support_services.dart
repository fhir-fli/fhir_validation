import 'validation.dart';

class TransformSupportServices {
  final List<dynamic>
      outputs; // Base class does not exist in Dart, use dynamic or a specific class if available.
  final void Function(String message)?
      mapLog; // Replace PrintWriter with a Dart function callback for logging.
  final dynamic
      context; // SimpleWorkerContext does not exist in Dart, use dynamic or specific class.

  TransformSupportServices(this.outputs, this.mapLog, this.context);

  void log(String message) {
    mapLog?.call(message);
    print(message); // Dart's print function used for logging to console.
  }

  dynamic createType(dynamic appInfo, String name) {
    // Assuming fetchResource and build are implemented or wrapped from a Dart FHIR library.
    // var sd = fetchResource(context,
    //     name);
    // return build(context,
    //     sd);
  }

  dynamic createResource(dynamic appInfo, dynamic res, bool atRootOfTransform) {
    if (atRootOfTransform) outputs.add(res);
    return res;
  }

  dynamic translate(dynamic appInfo, dynamic source, String conceptMapUrl) {
    var cme = ConceptMapEngine();
    return cme.translate(source, conceptMapUrl);
  }

  dynamic resolveReference(dynamic appContext, String url) {
    throw UnsupportedError("resolveReference is not supported yet");
  }

  List<dynamic> performSearch(dynamic appContext, String url) {
    throw UnsupportedError("performSearch is not supported yet");
  }
}
