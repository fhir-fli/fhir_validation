const actionType = {"resourceType":"CodeSystem","id":"action-type","meta":{"lastUpdated":"2022-05-28T13:47:40.239+11:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      \n      <p>This code system http://terminology.hl7.org/CodeSystem/action-type defines the following codes:</p>\n      \n      <table class=\"codes\">\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">\n            \n            <b>Code</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Display</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Definition</b>\n          \n          </td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">create\n            \n            <a name=\"action-type-create\"> </a>\n          \n          </td>\n          \n          <td>Create</td>\n          \n          <td>The action is to create a new resource.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">update\n            \n            <a name=\"action-type-update\"> </a>\n          \n          </td>\n          \n          <td>Update</td>\n          \n          <td>The action is to update an existing resource.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">remove\n            \n            <a name=\"action-type-remove\"> </a>\n          \n          </td>\n          \n          <td>Remove</td>\n          \n          <td>The action is to remove an existing resource.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">fire-event\n            \n            <a name=\"action-type-fire-event\"> </a>\n          \n          </td>\n          \n          <td>Fire Event</td>\n          \n          <td>The action is to fire a specific event.</td>\n        \n        </tr>\n      \n      </table>\n    \n    </div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"cds"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"trial-use"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":3}],"url":"http://terminology.hl7.org/CodeSystem/action-type","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.1.1246"}],"version":"4.3.0","name":"ActionType","title":"ActionType","status":"draft","experimental":false,"date":"2020-12-28T16:55:11+11:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"The type of action to be performed.","caseSensitive":true,"valueSet":"http://hl7.org/fhir/ValueSet/action-type","content":"complete","concept":[{"code":"create","display":"Create","definition":"The action is to create a new resource."},{"code":"update","display":"Update","definition":"The action is to update an existing resource."},{"code":"remove","display":"Remove","definition":"The action is to remove an existing resource."},{"code":"fire-event","display":"Fire Event","definition":"The action is to fire a specific event."}]};