// ignore_for_file: prefer_single_quotes, public_member_api_docs

const resource1 = {
  "address": [
    {
      "state": "OK",
      "postalCode": "74047",
      "country": "US",
      "city": "Mounds",
      "line": ["49 Meadow St"],
    }
  ],
  "active": true,
  "resourceType": "Patient",
  "birthDate": "2007-02-20",
  "gender": "female",
  "telecom": [
    {"value": "555-555-5555", "system": "phone", "use": "home"},
    {"system": "email", "value": "amy.shaw@example.com"},
  ],
  "id": "example",
};

const response1 = <String, dynamic>{
  'resourceType': 'OperationOutcome',
  'issue': [
    {
      'extension': [
        {
          'url':
              'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line',
          'valueInteger': 1,
        },
        {
          'url':
              'http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col',
          'valueInteger': 1,
        }
      ],
      'severity': 'information',
      'code': 'processing',
      'diagnostics':
          'Invariant violation: A resource should have narrative for robust management (from http://hl7.org/fhir/StructureDefinition/Patient|4.3.0)',
      'location': ['Patient', 'Line[1] Col[1]'],
    }
  ],
};
