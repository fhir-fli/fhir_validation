const actionParticipantType = {"resourceType":"CodeSystem","id":"action-participant-type","meta":{"lastUpdated":"2022-05-28T13:47:40.239+11:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      \n      <p>This code system http://hl7.org/fhir/action-participant-type defines the following codes:</p>\n      \n      <table class=\"codes\">\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">\n            \n            <b>Code</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Display</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Definition</b>\n          \n          </td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">patient\n            \n            <a name=\"action-participant-type-patient\"> </a>\n          \n          </td>\n          \n          <td>Patient</td>\n          \n          <td>The participant is the patient under evaluation.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">practitioner\n            \n            <a name=\"action-participant-type-practitioner\"> </a>\n          \n          </td>\n          \n          <td>Practitioner</td>\n          \n          <td>The participant is a practitioner involved in the patient's care.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">related-person\n            \n            <a name=\"action-participant-type-related-person\"> </a>\n          \n          </td>\n          \n          <td>Related Person</td>\n          \n          <td>The participant is a person related to the patient.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">device\n            \n            <a name=\"action-participant-type-device\"> </a>\n          \n          </td>\n          \n          <td>Device</td>\n          \n          <td>The participant is a system or device used in the care of the patient.</td>\n        \n        </tr>\n      \n      </table>\n    \n    </div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"cds"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"trial-use"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":3}],"url":"http://hl7.org/fhir/action-participant-type","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.1.812"}],"version":"4.3.0","name":"ActionParticipantType","title":"ActionParticipantType","status":"draft","experimental":false,"date":"2021-01-05T10:01:24+11:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"The type of participant for the action.","caseSensitive":true,"valueSet":"http://hl7.org/fhir/ValueSet/action-participant-type","content":"complete","concept":[{"code":"patient","display":"Patient","definition":"The participant is the patient under evaluation."},{"code":"practitioner","display":"Practitioner","definition":"The participant is a practitioner involved in the patient's care."},{"code":"related-person","display":"Related Person","definition":"The participant is a person related to the patient."},{"code":"device","display":"Device","definition":"The participant is a system or device used in the care of the patient."}]};