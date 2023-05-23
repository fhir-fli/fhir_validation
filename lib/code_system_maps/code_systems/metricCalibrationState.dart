const metricCalibrationState = {"resourceType":"CodeSystem","id":"metric-calibration-state","meta":{"lastUpdated":"2022-05-28T13:47:40.239+11:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      \n      <h2>DeviceMetricCalibrationState</h2>\n      \n      <div>\n        \n        <p>Describes the state of a metric calibration.</p>\n\n      \n      </div>\n      \n      <p>This code system http://hl7.org/fhir/metric-calibration-state defines the following codes:</p>\n      \n      <table class=\"codes\">\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">\n            \n            <b>Code</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Display</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Definition</b>\n          \n          </td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">not-calibrated\n            \n            <a name=\"metric-calibration-state-not-calibrated\"> </a>\n          \n          </td>\n          \n          <td>Not Calibrated</td>\n          \n          <td>The metric has not been calibrated.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">calibration-required\n            \n            <a name=\"metric-calibration-state-calibration-required\"> </a>\n          \n          </td>\n          \n          <td>Calibration Required</td>\n          \n          <td>The metric needs to be calibrated.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">calibrated\n            \n            <a name=\"metric-calibration-state-calibrated\"> </a>\n          \n          </td>\n          \n          <td>Calibrated</td>\n          \n          <td>The metric has been calibrated.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">unspecified\n            \n            <a name=\"metric-calibration-state-unspecified\"> </a>\n          \n          </td>\n          \n          <td>Unspecified</td>\n          \n          <td>The state of calibration of this metric is unspecified.</td>\n        \n        </tr>\n      \n      </table>\n    \n    </div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"dev"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"trial-use"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":1}],"url":"http://hl7.org/fhir/metric-calibration-state","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.4.653"}],"version":"4.3.0","name":"DeviceMetricCalibrationState","title":"DeviceMetricCalibrationState","status":"draft","experimental":false,"date":"2021-01-17T07:06:13+11:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"Describes the state of a metric calibration.","caseSensitive":true,"valueSet":"http://hl7.org/fhir/ValueSet/metric-calibration-state","content":"complete","concept":[{"code":"not-calibrated","display":"Not Calibrated","definition":"The metric has not been calibrated."},{"code":"calibration-required","display":"Calibration Required","definition":"The metric needs to be calibrated."},{"code":"calibrated","display":"Calibrated","definition":"The metric has been calibrated."},{"code":"unspecified","display":"Unspecified","definition":"The state of calibration of this metric is unspecified."}]};