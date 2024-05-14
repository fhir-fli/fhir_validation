const immunizationOrigin = {"resourceType":"CodeSystem","id":"immunization-origin","meta":{"lastUpdated":"2022-05-28T12:47:40.239+10:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>This code system http://terminology.hl7.org/CodeSystem/immunization-origin defines the following codes:</p><table class=\"codes\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td><td><b>Definition</b></td></tr><tr><td style=\"white-space:nowrap\">provider<a name=\"immunization-origin-provider\"> </a></td><td>Other Provider</td><td>The data for the immunization event originated with another provider.</td></tr><tr><td style=\"white-space:nowrap\">record<a name=\"immunization-origin-record\"> </a></td><td>Written Record</td><td>The data for the immunization event originated with a written record for the patient.</td></tr><tr><td style=\"white-space:nowrap\">recall<a name=\"immunization-origin-recall\"> </a></td><td>Parent/Guardian/Patient Recall</td><td>The data for the immunization event originated from the recollection of the patient or parent/guardian of the patient.</td></tr><tr><td style=\"white-space:nowrap\">school<a name=\"immunization-origin-school\"> </a></td><td>School Record</td><td>The data for the immunization event originated with a school record for the patient.</td></tr><tr><td style=\"white-space:nowrap\">jurisdiction<a name=\"immunization-origin-jurisdiction\"> </a></td><td>Jurisdictional IIS</td><td>The data for the immunization event originated with an immunization information system (IIS) or registry operating within the jurisdiction.</td></tr></table></div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"pher"}],"url":"http://terminology.hl7.org/CodeSystem/immunization-origin","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.1.1101"}],"version":"4.3.0","name":"ImmunizationEventOrigin","title":"Immunization Event Origin","status":"draft","experimental":false,"description":"This code system supports describing the source of the data when the report of the immunization event is not based on information from the person, entity or organization who administered the vaccine.","caseSensitive":true,"content":"complete","concept":[{"code":"provider","display":"Other Provider","definition":"The data for the immunization event originated with another provider."},{"code":"record","display":"Written Record","definition":"The data for the immunization event originated with a written record for the patient."},{"code":"recall","display":"Parent/Guardian/Patient Recall","definition":"The data for the immunization event originated from the recollection of the patient or parent/guardian of the patient."},{"code":"school","display":"School Record","definition":"The data for the immunization event originated with a school record for the patient."},{"code":"jurisdiction","display":"Jurisdictional IIS","definition":"The data for the immunization event originated with an immunization information system (IIS) or registry operating within the jurisdiction."}]};