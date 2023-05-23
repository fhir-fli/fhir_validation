const templateStatusCode = {"resourceType":"ValueSet","id":"template-status-code","meta":{"lastUpdated":"2022-05-28T13:47:40.239+11:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]},"text":{"status":"extensions","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\"><ul><li>Include these codes as defined in <a href=\"codesystem-template-status-code.html\"><code>urn:oid:2.16.840.1.113883.3.1937.98.5.8</code></a><table class=\"none\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td><td><b>Definition</b></td></tr><tr><td><a href=\"codesystem-template-status-code.html#template-status-code-draft\">draft</a></td><td>Draft</td><td>Design is under development (nascent)</td></tr><tr><td><a href=\"codesystem-template-status-code.html#template-status-code-pending\">pending</a></td><td>Under pre-publication review</td><td>Design is completed and is being reviewed</td></tr><tr><td><a href=\"codesystem-template-status-code.html#template-status-code-active\">active</a></td><td>Active</td><td>Design has been deemed fit for the intended purpose and is published by the governance            group</td></tr><tr><td><a href=\"codesystem-template-status-code.html#template-status-code-review\">review</a></td><td>In Review</td><td>Design is active, but is under review. The review may result in a change to the design.            The change may necessitate a new version to be created. This in turn may result in the            prior version of the template to be retired. Alternatively, the review may result in a            change to the design that does not require a new version to be created, or it may result            in no change to the design at all</td></tr><tr><td><a href=\"codesystem-template-status-code.html#template-status-code-cancelled\">cancelled</a></td><td>Cancelled</td><td>A drafted design is determined to be erroneous or not fit for intended purpose and is            discontinued before ever being published in an active state</td></tr><tr><td><a href=\"codesystem-template-status-code.html#template-status-code-rejected\">rejected</a></td><td>Rejected</td><td>A previously drafted design is determined to be erroneous or not fit for intended purpose            and is discontinued before ever being published for consideration in a pending state</td></tr><tr><td><a href=\"codesystem-template-status-code.html#template-status-code-retired\">retired</a></td><td>Retired</td><td>A previously active design is discontinued from use. It should no longer be used for future            designs, but for historical purposes may be used to process data previously recorded using            this design. A newer design might or might not exist. The design is published in the retired            state</td></tr><tr><td><a href=\"codesystem-template-status-code.html#template-status-code-terminated\">terminated</a></td><td>Terminated</td><td>A design is determined to be erroneous or not fit for the intended purpose and should            no longer be used, even for historical purposes. No new designs can be developed for this            template. The associated template no longer needs to be published, but if published, is            shown in the terminated state</td></tr></table></li></ul></div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"fhir"}],"url":"http://hl7.org/fhir/ValueSet/template-status-code","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.3.1937.98.11.8"}],"version":"4.3.0","name":"TemplateStatusCode","title":"TemplateStatusCode","status":"draft","experimental":false,"date":"2019-11-01T09:29:23+11:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"The status indicates the level of maturity of the design and may be used to manage the    use of the design.","compose":{"include":[{"system":"urn:oid:2.16.840.1.113883.3.1937.98.5.8","concept":[{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-concept-definition","valueString":"Design is under development (nascent)"}],"code":"draft","display":"Draft"},{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-concept-definition","valueString":"Design is completed and is being reviewed"}],"code":"pending","display":"Under pre-publication review"},{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-concept-definition","valueString":"Design has been deemed fit for the intended purpose and is published by the governance            group"}],"code":"active","display":"Active"},{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-concept-definition","valueString":"Design is active, but is under review. The review may result in a change to the design.            The change may necessitate a new version to be created. This in turn may result in the            prior version of the template to be retired. Alternatively, the review may result in a            change to the design that does not require a new version to be created, or it may result            in no change to the design at all"}],"code":"review","display":"In Review"},{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-concept-definition","valueString":"A drafted design is determined to be erroneous or not fit for intended purpose and is            discontinued before ever being published in an active state"}],"code":"cancelled","display":"Cancelled"},{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-concept-definition","valueString":"A previously drafted design is determined to be erroneous or not fit for intended purpose            and is discontinued before ever being published for consideration in a pending state"}],"code":"rejected","display":"Rejected"},{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-concept-definition","valueString":"A previously active design is discontinued from use. It should no longer be used for future            designs, but for historical purposes may be used to process data previously recorded using            this design. A newer design might or might not exist. The design is published in the retired            state"}],"code":"retired","display":"Retired"},{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/valueset-concept-definition","valueString":"A design is determined to be erroneous or not fit for the intended purpose and should            no longer be used, even for historical purposes. No new designs can be developed for this            template. The associated template no longer needs to be published, but if published, is            shown in the terminated state"}],"code":"terminated","display":"Terminated"}]}]}};