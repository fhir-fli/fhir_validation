const deviceStatusReason = {"resourceType":"CodeSystem","id":"device-status-reason","meta":{"lastUpdated":"2022-05-28T13:47:40.239+11:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      \n      <h2>FHIRDeviceStatusReason</h2>\n      \n      <div>\n        \n        <p>The availability status reason of the device.</p>\n\n      \n      </div>\n      \n      <p>This code system http://terminology.hl7.org/CodeSystem/device-status-reason defines the following codes:</p>\n      \n      <table class=\"codes\">\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">\n            \n            <b>Code</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Display</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Definition</b>\n          \n          </td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">online\n            \n            <a name=\"device-status-reason-online\"> </a>\n          \n          </td>\n          \n          <td>Online</td>\n          \n          <td>The device is off.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">paused\n            \n            <a name=\"device-status-reason-paused\"> </a>\n          \n          </td>\n          \n          <td>Paused</td>\n          \n          <td>The device is paused.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">standby\n            \n            <a name=\"device-status-reason-standby\"> </a>\n          \n          </td>\n          \n          <td>Standby</td>\n          \n          <td>The device is ready but not actively operating.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">offline\n            \n            <a name=\"device-status-reason-offline\"> </a>\n          \n          </td>\n          \n          <td>Offline</td>\n          \n          <td>The device is offline.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">not-ready\n            \n            <a name=\"device-status-reason-not-ready\"> </a>\n          \n          </td>\n          \n          <td>Not Ready</td>\n          \n          <td>The device is not ready.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">transduc-discon\n            \n            <a name=\"device-status-reason-transduc-discon\"> </a>\n          \n          </td>\n          \n          <td>Transducer Disconnected</td>\n          \n          <td>The device transducer is disconnected.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">hw-discon\n            \n            <a name=\"device-status-reason-hw-discon\"> </a>\n          \n          </td>\n          \n          <td>Hardware Disconnected</td>\n          \n          <td>The device hardware is disconnected.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">off\n            \n            <a name=\"device-status-reason-off\"> </a>\n          \n          </td>\n          \n          <td>Off</td>\n          \n          <td>The device is off.</td>\n        \n        </tr>\n      \n      </table>\n    \n    </div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"oo"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"trial-use"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":2}],"url":"http://terminology.hl7.org/CodeSystem/device-status-reason","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.4.1082"}],"version":"4.3.0","name":"FHIRDeviceStatusReason","title":"FHIRDeviceStatusReason","status":"draft","experimental":false,"date":"2021-01-17T07:06:13+11:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"The availability status reason of the device.","caseSensitive":true,"valueSet":"http://hl7.org/fhir/ValueSet/device-status-reason","content":"complete","concept":[{"code":"online","display":"Online","definition":"The device is off."},{"code":"paused","display":"Paused","definition":"The device is paused."},{"code":"standby","display":"Standby","definition":"The device is ready but not actively operating."},{"code":"offline","display":"Offline","definition":"The device is offline."},{"code":"not-ready","display":"Not Ready","definition":"The device is not ready."},{"code":"transduc-discon","display":"Transducer Disconnected","definition":"The device transducer is disconnected."},{"code":"hw-discon","display":"Hardware Disconnected","definition":"The device hardware is disconnected."},{"code":"off","display":"Off","definition":"The device is off."}]};