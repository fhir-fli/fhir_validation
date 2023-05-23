const verificationresultCommunicationMethod = {"resourceType":"CodeSystem","id":"verificationresult-communication-method","meta":{"lastUpdated":"2022-05-28T12:47:40.239+10:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>This code system http://hl7.org/fhir/verificationresult-communication-method defines the following codes:</p><table class=\"codes\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td><td><b>Definition</b></td></tr><tr><td style=\"white-space:nowrap\">manual<a name=\"verificationresult-communication-method-manual\"> </a></td><td>Manual</td><td>The information is submitted/retrieved manually (e.g. by phone, fax, paper-based)</td></tr><tr><td style=\"white-space:nowrap\">portal<a name=\"verificationresult-communication-method-portal\"> </a></td><td>Portal</td><td>The information is submitted/retrieved via a portal</td></tr><tr><td style=\"white-space:nowrap\">pull<a name=\"verificationresult-communication-method-pull\"> </a></td><td>Pull</td><td>The information is retrieved (i.e. pulled) from a source (e.g. over an API)</td></tr><tr><td style=\"white-space:nowrap\">push<a name=\"verificationresult-communication-method-push\"> </a></td><td>Push</td><td>The information is sent (i.e. pushed) from a source (e.g. over an API, asynchronously, secure messaging)</td></tr></table></div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"pa"}],"url":"http://hl7.org/fhir/verificationresult-communication-method","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.1.0"}],"version":"4.3.0","name":"verificationresult-communication-method","title":"VerificationResult Communication Method Code System","status":"active","experimental":false,"date":"2018-10-31","publisher":"HL7 International","contact":[{"telecom":[{"system":"other","value":"http://hl7.org/fhir"}]}],"description":"This code system defines the methods by which entities participating in a validation process share information (e.g. submission/retrieval of attested information, or exchange of validated information).","caseSensitive":true,"content":"complete","concept":[{"code":"manual","display":"Manual","definition":"The information is submitted/retrieved manually (e.g. by phone, fax, paper-based)"},{"code":"portal","display":"Portal","definition":"The information is submitted/retrieved via a portal"},{"code":"pull","display":"Pull","definition":"The information is retrieved (i.e. pulled) from a source (e.g. over an API)"},{"code":"push","display":"Push","definition":"The information is sent (i.e. pushed) from a source (e.g. over an API, asynchronously, secure messaging)"}]};