import 'dart:convert';
import 'package:http/http.dart' as http;

class OnlineRetrievalService {
  Future<Map<String, dynamic>?> requestFromCanonical(String canonical) async {
    try {
      final response = await http.get(Uri.parse(canonical),
          headers: {'Accept': 'application/fhir+json'});
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Handle exceptions or logging here
    }
    return null;
  }
}
