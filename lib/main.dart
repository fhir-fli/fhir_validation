import 'package:fhir/r4.dart';

import 'structure_definition_maps/structure_definitions/structureDefinitions.dart';
import 'utils/utils.dart';
import 'validation/validate.dart';

Future main() async {
  print(jsonPrettyPrint(await validateFhirMaps(
    mapToValidate: thisPatient.toJson(),
    structureDefinition: StructureDefinition.fromJson(patient),
    type: 'Patient',
    startPath: 'Patient',
    online: false,
  )));
  // print(jsonPrettyPrint(await validateFhirMaps(
  //   mapToValidate: resource,
  //   structureDefinition: StructureDefinition.fromJson(bundle),
  //   type: 'Bundle',
  //   startPath: 'Bundle',
  //   online: false,
  // )));
}

final thisPatient = Patient(
  resourceType: R4ResourceType.Patient,
  name: [
    HumanName(family: 'Faulkenberry'),
  ],
  birthDate: FhirDate('1981-09-18'),
);

final resource = {
  "resourceType": "Bundle",
  "id": ["bundle-transaction", "yet-another-bundle"],
  "somethingElse": "thisThingHere",
  "meta": {
    "lastUpdated": "2014-08-18T01:43:30Z",
    "tag": [
      {
        "system": "http://terminology.hl7.org/CodeSystem/v3-ActReason",
        "code": "HTEST",
        "display": "test health data"
      }
    ]
  },
  "type": "transaction",
  "entry": [
    {
      "fullUrl": "urn:uuid:61ebe359-bfdc-4613-8bf2-c5e300945f0a",
      "resource": {
        "resourceType": "Patient",
        "text": {
          "status": "generated",
          "div":
              "\u003cdiv xmlns\u003d\"http://www.w3.org/1999/xhtml\"\u003eSome narrative\u003c/div\u003e"
        },
        "active": true,
        "name": [
          {
            "use": "official",
            "family": "Chalmers",
            "given": ["Peter", "James"]
          }
        ],
        "gender": "male",
        "birthDate": "1974-12-25"
      },
      "request": {"method": "POST", "url": "Patient"}
    },
    {
      "fullUrl": "urn:uuid:88f151c0-a954-468a-88bd-5ae15c08e059",
      "resource": {
        "resourceType": "Patient",
        "text": {
          "div":
              "\u003cdiv xmlns\u003d\"http://www.w3.org/1999/xhtml\"\u003eSome narrative\u003c/div\u003e"
        },
        "identifier": [
          {"system": "http:/example.org/fhir/ids", "value": "234234"}
        ],
        "active": true,
        "name": [
          {
            "use": "official",
            "family": "Chalmers",
            "given": ["Peter", "James"]
          }
        ],
        "gender": "male",
        "birthDate": "1974-12-25"
      },
      "request": {
        "method": "POST",
        "url": "Patient",
        "ifNoneExist": "identifier\u003dhttp:/example.org/fhir/ids|234234"
      }
    },
    {
      "fullUrl": "http://example.org/fhir/Patient/123",
      "resource": {
        "resourceType": "Patient",
        "id": "123",
        "text": {
          "status": "generated",
          "div":
              "\u003cdiv xmlns\u003d\"http://www.w3.org/1999/xhtml\"\u003eSome narrative\u003c/div\u003e"
        },
        "active": true,
        "name": [
          {
            "use": "official",
            "family": "Chalmers",
            "given": ["Peter", "James"]
          }
        ],
        "gender": "male",
        "birthDate": 1974
      },
      "request": {"method": "PUT", "url": "Patient/123"}
    },
    {
      "fullUrl": "urn:uuid:74891afc-ed52-42a2-bcd7-f13d9b60f096",
      "resource": {
        "resourceType": "Patient",
        "text": {
          "status": "generated",
          "div":
              "\u003cdiv xmlns\u003d\"http://www.w3.org/1999/xhtml\"\u003eSome narrative\u003c/div\u003e"
        },
        "identifier": [
          {"system": "http:/example.org/fhir/ids", "value": "456456"}
        ],
        "active": true,
        "name": [
          {
            "use": "official",
            "family": "Chalmers",
            "given": ["Peter", "James"]
          }
        ],
        "gender": "cis-het-male",
        "birthDate": "1974-12-25"
      },
      "request": {
        "method": "PUT",
        "url": "Patient?identifier\u003dhttp:/example.org/fhir/ids|456456"
      }
    },
    {
      "fullUrl": "http://example.org/fhir/Patient/123a",
      "resource": {
        "resourceType": "Patient",
        "id": "123a",
        "text": {
          "status": "generated",
          "div":
              "\u003cdiv xmlns\u003d\"http://www.w3.org/1999/xhtml\"\u003eSome narrative\u003c/div\u003e"
        },
        "active": true,
        "name": [
          {
            "use": "official",
            "family": "Chalmers",
            "given": ["Peter", "James"]
          }
        ],
        "gender": "male",
        "birthDate": "1974-12-25"
      },
      "request": {"method": "PUT", "url": "Patient/123a", "ifMatch": "W/\"2\""}
    },
    {
      "request": {"method": "DELETE", "url": "Patient/234"}
    },
    {
      "request": {"method": "DELETE", "url": "Patient?identifier\u003d123456"}
    },
    {
      "fullUrl": "urn:uuid:79378cb8-8f58-48e8-a5e8-60ac2755b674",
      "resource": {
        "resourceType": "Parameters",
        "id": ["p1", "p2"],
        "parameter": [
          {
            "name": "coding",
            "valueCoding": {
              "system": "http://loinc.org",
              "code": ["1963-8", "1963-8"]
            }
          }
        ]
      },
      "request": {"method": "POST", "url": r"ValueSet/$lookup"}
    },
    {
      "request": {"method": "GET", "url": "Patient?name\u003dpeter"}
    },
    {
      "request": {
        "method": "GET",
        "url": "Patient/12334",
        "ifNoneMatch": "W/\"4\"",
        "ifModifiedSince": "2015-08-31T08:14:33+10:00"
      }
    }
  ]
};
