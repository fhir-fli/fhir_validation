// ignore_for_file: prefer_single_quotes, public_member_api_docs, lines_longer_than_80_chars

const resource1a = {
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
  "meta": {
    "profile": [
      "http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient",
    ],
  },
  "birthDate": "2007-02-20",
  "gender": "female",
  "telecom": [
    {"value": "555-555-5555", "system": "phone", "use": "home"},
    {"system": "email", "value": "amy.shaw@example.com"},
  ],
  "id": "example",
};

const response1a = {
  "resourceType": "OperationOutcome",
  "issue": [
    {
      "extension": [
        {
          "url":
              "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line",
          "valueInteger": 1,
        },
        {
          "url":
              "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col",
          "valueInteger": 1,
        }
      ],
      "severity": "warning",
      "code": "processing",
      "diagnostics":
          "Constraint failed: dom-6: 'A resource should have narrative for robust management' (defined in http://hl7.org/fhir/StructureDefinition/DomainResource) (Best Practice Recommendation)",
      "location": [
        "Patient",
        "Line[1] Col[1]",
      ],
    },
    {
      "extension": [
        {
          "url":
              "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line",
          "valueInteger": 1,
        },
        {
          "url":
              "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col",
          "valueInteger": 1,
        },
      ],
      "severity": "error",
      "code": "processing",
      "diagnostics":
          "Patient.identifier: minimum required = 1, but only found 0 (from http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|3.0.1)",
      "location": [
        "Patient.identifier",
        "Line[1] Col[1]",
      ],
    },
    {
      "extension": [
        {
          "url":
              "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-line",
          "valueInteger": 1,
        },
        {
          "url":
              "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-col",
          "valueInteger": 1,
        },
      ],
      "severity": "error",
      "code": "processing",
      "diagnostics":
          "Patient.name: minimum required = 1, but only found 0 (from http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient|3.0.1)",
      "location": [
        "Patient.name",
        "Line[1] Col[1]",
      ],
    },
  ],
};
