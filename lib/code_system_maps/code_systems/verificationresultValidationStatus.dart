const verificationresultValidationStatus = {"resourceType":"CodeSystem","id":"verificationresult-validation-status","meta":{"lastUpdated":"2022-05-28T12:47:40.239+10:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>This code system http://hl7.org/fhir/verificationresult-validation-status defines the following codes:</p><table class=\"codes\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td><td><b>Definition</b></td></tr><tr><td style=\"white-space:nowrap\">successful<a name=\"verificationresult-validation-status-successful\"> </a></td><td>Successful</td><td/></tr><tr><td style=\"white-space:nowrap\">failed<a name=\"verificationresult-validation-status-failed\"> </a></td><td>Failed</td><td/></tr><tr><td style=\"white-space:nowrap\">unknown<a name=\"verificationresult-validation-status-unknown\"> </a></td><td>Unknown</td><td>The validations status has not been determined yet</td></tr></table></div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"pa"}],"url":"http://hl7.org/fhir/verificationresult-validation-status","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.1.895"}],"version":"4.3.0","name":"validation-status","status":"draft","experimental":false,"date":"2018-06-05T14:06:02+00:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"Status of the validation of the target against the primary source","caseSensitive":true,"valueSet":"http://hl7.org/fhir/ValueSet/validation-status","content":"complete","concept":[{"code":"successful","display":"Successful"},{"code":"failed","display":"Failed"},{"code":"unknown","display":"Unknown","definition":"The validations status has not been determined yet"}]};