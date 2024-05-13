import 'package:fhir_primitives/fhir_primitives.dart';
import 'package:fhir_r4/fhir_r4.dart';

import 'src/systems/structure_definition_maps/structure_definitions/structureDefinitions.dart';
import 'src/utils/utils.dart';
import 'validation/validate.dart';

Future main() async {
  // print(jsonPrettyPrint(await validateFhirMaps(
  //   mapToValidate: thisPatient.toJson(),
  //   structureDefinition: StructureDefinition.fromJson(patient),
  //   type: 'Patient',
  //   startPath: 'Patient',
  //   online: false,
  // )));
  print(jsonPrettyPrint(await validateFhirMaps(
    mapToValidate: resource,
    structureDefinition: StructureDefinition.fromJson(bundle),
    type: 'Bundle',
    startPath: 'Bundle',
    online: false,
  )));
  // print(jsonPrettyPrint(await validateFhirMaps(
  //   mapToValidate: thisObservation.toJson(),
  //   structureDefinition: StructureDefinition.fromJson(observation),
  //   type: 'Observation',
  //   startPath: 'Observation',
  //   online: false,
  // )));
  print(jsonPrettyPrint(await validateFhirMaps(
    mapToValidate: thisQuestionnaire.toJson(),
    structureDefinition: StructureDefinition.fromJson(questionnaire),
    type: 'Questionnaire',
    startPath: 'Questionnaire',
    online: false,
  )));
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

final thisObservation = Observation.fromJson({
  "resourceType": "Observation",
  "id": "1955381",
  "meta": {
    "versionId": "1",
    "lastUpdated": "2021-03-18T13:03:46.677+00:00",
    "source": "#VOERTEym8OBEHPuv"
  },
  "status": "final",
  "category": [
    {
      "coding": [
        {
          "system":
              "http://terminology.hl7.org/CodeSystem/observation-category",
          "code": "vital-signs",
          "display": "vital-signs"
        }
      ],
      "text": "vital-signs"
    }
  ],
  "code": {
    "coding": [
      {
        "system": "urn:oid:2.16.840.1.113883.6.96",
        "code": "46680005",
        "display": "Vital signs"
      }
    ]
  },
  "subject": {"reference": "Patient/1955296"},
  "effectivePeriod": {
    "start": "2017-06-20T13:00:07+05:30",
    "end": "2017-06-20T13:00:07+05:30"
  },
  "component": [
    {
      "code": {
        "coding": [
          {"system": "urn:oid:2.16.840.1.113883.6.1", "code": "3141-9"},
          {
            "system": "urn:oid:1.2.840.113619.21.3.2527",
            "code": "61",
            "display": "weight E&M - 3141-9"
          }
        ]
      },
      "valueQuantity": {"value": 144.0, "unit": "[lb_av]"},
      "interpretation": [
        {
          "coding": [
            {"system": "urn:oid:"}
          ]
        },
        {
          "coding": [
            {"system": "urn:oid:"}
          ]
        },
        {
          "coding": [
            {"system": "urn:oid:"}
          ]
        }
      ]
    }
  ]
});

final thisQuestionnaire = Questionnaire.fromJson({
  "resourceType": "Questionnaire",
  "id": "cage",
  "url": "https://mayjuun.com/fhir/Questionnaire/cage",
  "name": "cage",
  "title": "CAGE Substance Abuse Screening Tool",
  "status": "active",
  "publisher": "MayJuun LLC",
  "contact": [
    {
      "name": "MayJuun LLC",
      "telecom": [
        {"system": "email", "value": "info@mayjuun.com", "use": "work"}
      ]
    }
  ],
  "item": [
    {
      "extension": [
        {
          "url":
              "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl",
          "valueCodeableConcept": {
            "coding": [
              {
                "system": "http://hl7.org/fhir/questionnaire-item-control",
                "code": "header",
                "display": "Header"
              }
            ],
            "text":
                "The group is to be continuously visible at the top of the questionnaire"
          }
        }
      ],
      "linkId": "/cage",
      "text":
          "CAGE is a substance abuse screening tool. Please answer questions below as yes or no. ",
      "type": "group",
      "item": [
        {
          "linkId": "/cage/question1",
          "text": "Have you ever felt you should cut down on your drinking?",
          "type": "choice",
          "required": true,
          "answerOption": [
            {
              "valueCoding": {
                "extension": [
                  {
                    "url":
                        "http://hl7.org/fhir/StructureDefinition/ordinalValue",
                    "valueDecimal": 1
                  }
                ],
                "code": "Yes",
                "display": "Yes",
                "_display": {"extension": []}
              }
            },
            {
              "valueCoding": {
                "extension": [
                  {
                    "url":
                        "http://hl7.org/fhir/StructureDefinition/ordinalValue",
                    "valueDecimal": 0
                  }
                ],
                "code": "No",
                "display": "No",
                "_display": {"extension": []}
              }
            }
          ]
        },
        {
          "linkId": "/cage/question2",
          "text": "Have people annoyed you by criticizing your drinking?",
          "type": "choice",
          "required": true,
          "answerOption": [
            {
              "valueCoding": {
                "extension": [
                  {
                    "url":
                        "http://hl7.org/fhir/StructureDefinition/ordinalValue",
                    "valueDecimal": 1
                  }
                ],
                "code": "Yes",
                "display": "Yes",
                "_display": {"extension": []}
              }
            },
            {
              "valueCoding": {
                "extension": [
                  {
                    "url":
                        "http://hl7.org/fhir/StructureDefinition/ordinalValue",
                    "valueDecimal": 0
                  }
                ],
                "code": "No",
                "display": "No",
                "_display": {"extension": []}
              }
            }
          ]
        },
        {
          "linkId": "/cage/question3",
          "text": "Have you ever felt bad or guilty about your drinking?",
          "type": "choice",
          "required": true,
          "answerOption": [
            {
              "valueCoding": {
                "extension": [
                  {
                    "url":
                        "http://hl7.org/fhir/StructureDefinition/ordinalValue",
                    "valueDecimal": 1
                  }
                ],
                "code": "Yes",
                "display": "Yes",
                "_display": {"extension": []}
              }
            },
            {
              "valueCoding": {
                "extension": [
                  {
                    "url":
                        "http://hl7.org/fhir/StructureDefinition/ordinalValue",
                    "valueDecimal": 0
                  }
                ],
                "code": "No",
                "display": "No",
                "_display": {"extension": []}
              }
            }
          ]
        },
        {
          "linkId": "/cage/question4",
          "text":
              "Have you ever had a drink first thing in the morning to steady your nerves or to get rid of a hangover (eye-opener)?",
          "type": "choice",
          "required": true,
          "answerOption": [
            {
              "valueCoding": {
                "extension": [
                  {
                    "url":
                        "http://hl7.org/fhir/StructureDefinition/ordinalValue",
                    "valueDecimal": 1
                  }
                ],
                "code": "Yes",
                "display": "Yes",
                "_display": {"extension": []}
              }
            },
            {
              "valueCoding": {
                "extension": [
                  {
                    "url":
                        "http://hl7.org/fhir/StructureDefinition/ordinalValue",
                    "valueDecimal": 0
                  }
                ],
                "code": "No",
                "display": "No",
                "_display": {"extension": []}
              }
            }
          ]
        }
      ]
    }
  ]
});
