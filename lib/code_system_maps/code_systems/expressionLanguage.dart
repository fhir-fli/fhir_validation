const expressionLanguage = {"resourceType":"CodeSystem","id":"expression-language","meta":{"lastUpdated":"2022-05-28T12:47:40.239+10:00"},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>This code system http://hl7.org/fhir/expression-language defines the following codes:</p><table class=\"codes\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td><td><b>Definition</b></td></tr><tr><td style=\"white-space:nowrap\">text/cql<a name=\"expression-language-text.47cql\"> </a></td><td>CQL</td><td>Clinical Quality Language.</td></tr><tr><td style=\"white-space:nowrap\">text/fhirpath<a name=\"expression-language-text.47fhirpath\"> </a></td><td>FHIRPath</td><td>FHIRPath.</td></tr><tr><td style=\"white-space:nowrap\">application/x-fhir-query<a name=\"expression-language-application.47x-fhir-query\"> </a></td><td>FHIR Query</td><td>FHIR's RESTful query syntax - typically independent of base URL.</td></tr><tr><td style=\"white-space:nowrap\">text/cql-identifier<a name=\"expression-language-text.47cql-identifier\"> </a></td><td>CQL Identifier</td><td>A valid Clinical Quality Language identifier.</td></tr><tr><td style=\"white-space:nowrap\">text/cql-expression<a name=\"expression-language-text.47cql-expression\"> </a></td><td>CQL Expression</td><td>A Clinical Quality Language expression.</td></tr></table></div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"fhir"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"trial-use"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":5}],"url":"http://hl7.org/fhir/expression-language","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.1.106"}],"version":"4.3.0","name":"ExpressionLanguage","title":"ExpressionLanguage","status":"draft","experimental":false,"date":"2022-05-28T12:47:40+10:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"The media type of the expression language.","caseSensitive":true,"valueSet":"http://hl7.org/fhir/ValueSet/expression-language","content":"complete","concept":[{"code":"text/cql","display":"CQL","definition":"Clinical Quality Language."},{"code":"text/fhirpath","display":"FHIRPath","definition":"FHIRPath."},{"code":"application/x-fhir-query","display":"FHIR Query","definition":"FHIR's RESTful query syntax - typically independent of base URL."},{"code":"text/cql-identifier","display":"CQL Identifier","definition":"A valid Clinical Quality Language identifier."},{"code":"text/cql-expression","display":"CQL Expression","definition":"A Clinical Quality Language expression."}]};