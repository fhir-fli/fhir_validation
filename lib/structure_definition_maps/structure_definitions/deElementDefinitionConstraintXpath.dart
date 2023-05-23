const deElementDefinitionConstraintXpath = {"resourceType":"StructureDefinition","id":"de-ElementDefinition.constraint.xpath","meta":{"lastUpdated":"2022-05-28T12:47:40.239+10:00"},"url":"http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.constraint.xpath","version":"4.3.0","name":"ElementDefinition.constraint.xpath","title":"ElementDefinition.constraint.xpath","status":"draft","experimental":true,"date":"2022-05-28T12:47:40+10:00","publisher":"HL7 FHIR Standard","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"}]}],"description":"Data Element for ElementDefinition.constraint.xpath","purpose":"Data Elements are defined for each element to assist in questionnaire construction etc","fhirVersion":"4.3.0","mapping":[{"identity":"v2","uri":"http://hl7.org/v2","name":"HL7 v2 Mapping"},{"identity":"rim","uri":"http://hl7.org/v3","name":"RIM Mapping"},{"identity":"iso11179","uri":"http://metadata-standards.org/11179/","name":"ISO 11179"},{"identity":"dex","uri":"http://ihe.net/data-element-exchange","name":"IHE Data Element Exchange (DEX)"},{"identity":"loinc","uri":"http://loinc.org","name":"LOINC code for the element"}],"kind":"logical","abstract":false,"type":"ElementDefinition.constraint.xpath","baseDefinition":"http://hl7.org/fhir/StructureDefinition/Element","derivation":"specialization","snapshot":{"element":[{"id":"ElementDefinition.constraint.xpath","extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"trial-use"}],"path":"ElementDefinition.constraint.xpath","short":"XPath expression of constraint","definition":"An XPath expression of constraint that can be executed to see if this constraint is met.","comment":"Elements SHALL use \"f\" as the namespace prefix for the FHIR namespace, and \"x\" for the xhtml namespace, and SHALL NOT use any other prefixes.     Note: XPath is generally considered not useful because it does not apply to JSON and other formats and because of XSLT implementation issues, and may be removed in the future.","requirements":"Used in Schematron tests of the validity of the resource.","min":0,"max":"1","base":{"path":"ElementDefinition.constraint.xpath","min":0,"max":"1"},"type":[{"code":"string"}],"isModifier":false,"isSummary":true,"mapping":[{"identity":"rim","map":"N/A (MIF territory)"}]}]}};