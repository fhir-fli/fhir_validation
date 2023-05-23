const procedureNotPerformedReason = {"resourceType":"ValueSet","id":"procedure-not-performed-reason","meta":{"lastUpdated":"2022-05-28T12:47:40.239+10:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\"><p>This value set includes codes based on the following rules:</p><ul><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  183932001 (Procedure contraindicated)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  416406003 (Procedure discontinued)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  416237000 (Procedure not done)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  428119001 (Procedure not indicated)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  416064006 (Procedure not offered)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  416432009 (Procedure not wanted)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  183944003 (Procedure refused)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  394908001 (Procedure stopped)</li></ul></div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"pc"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"draft"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":1}],"url":"http://hl7.org/fhir/ValueSet/procedure-not-performed-reason","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.3.431"}],"version":"4.3.0","name":"ProcedureNotPerformedReason(SNOMED-CT)","title":"Procedure Not Performed Reason (SNOMED-CT)","status":"active","experimental":true,"publisher":"Health Level Seven, Inc. - CQI WG","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/special/committees/CQI"}]}],"description":"Situation codes describing the reason that a procedure, which might otherwise be expected, was not performed, or a procedure that was started and was not completed. Consists of SNOMED CT codes, children of procedure contraindicated (183932001), procedure discontinued (416406003), procedure not done (416237000), procedure not indicated (428119001), procedure not offered (416064006), procedure not wanted (416432009), procedure refused (183944003), and procedure stopped (394908001).","copyright":"This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org","compose":{"include":[{"system":"http://snomed.info/sct","filter":[{"property":"concept","op":"is-a","value":"183932001"}]},{"system":"http://snomed.info/sct","filter":[{"property":"concept","op":"is-a","value":"416406003"}]},{"system":"http://snomed.info/sct","filter":[{"property":"concept","op":"is-a","value":"416237000"}]},{"system":"http://snomed.info/sct","filter":[{"property":"concept","op":"is-a","value":"428119001"}]},{"system":"http://snomed.info/sct","filter":[{"property":"concept","op":"is-a","value":"416064006"}]},{"system":"http://snomed.info/sct","filter":[{"property":"concept","op":"is-a","value":"416432009"}]},{"system":"http://snomed.info/sct","filter":[{"property":"concept","op":"is-a","value":"183944003"}]},{"system":"http://snomed.info/sct","filter":[{"property":"concept","op":"is-a","value":"394908001"}]}]}};