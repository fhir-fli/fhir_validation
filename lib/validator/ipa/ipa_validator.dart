import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class IPAValidator {
  final String address;
  final String token;
  final String urn;
  // Assuming InstanceValidator is a class from a Dart FHIR library that you're using
  final InstanceValidator validator;

  IPAValidator(this.address, this.token, this.urn, this.validator);

  Future<void> validate() async {
    var patients = await searchPatients();
    if (patients.isNotEmpty) {
      // Implement further validation logic here
    }
  }

  Future<List<Element>> searchPatients() async {
    print("Searching Patients");
    var bundle = await makeRequest("/Patient");
    var list = <Element>[];
    if (bundle != null) {
      // Assume checkSelfLink() is implemented elsewhere
      checkSelfLink(bundle);
      var entries = bundle['entry'] as List<dynamic>?;
      if (entries != null) {
        for (var i = 0; i < entries.length; i++) {
          var entry = entries[i];
          var resource = entry['resource'];
          if (resource != null && resource['resourceType'] == 'Patient') {
            // Assuming validate method exists and works similarly to Java's version
            validator.validate("Bundle.entry[$i].resource", resource,
                "http://hl7.org/fhir/uv/ipa/StructureDefinition/ipa-patient");
            list.add(
                resource); // Assuming Element class exists in your Dart FHIR library
          }
        }
      }
    }
    // Handle validation messages as appropriate
    return list;
  }

  // Implement checkSelfLink() based on the Java version

  Future<dynamic> makeRequest(String url) async {
    try {
      var response = await http.get(Uri.parse('$address$url'), headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/fhir+json',
      });
      if (response.statusCode >= 300) {
        // Handle HTTP errors
        return null;
      } else if (response.body.isEmpty) {
        // Handle no content
        return null;
      } else {
        return json.decode(response.body);
      }
    } catch (e) {
      // Handle exceptions
      return null;
    }
  }
}
