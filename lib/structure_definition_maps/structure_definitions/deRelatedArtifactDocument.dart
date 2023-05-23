const deRelatedArtifactDocument = {"resourceType":"StructureDefinition","id":"de-RelatedArtifact.document","meta":{"lastUpdated":"2022-05-28T12:47:40.239+10:00"},"url":"http://hl7.org/fhir/StructureDefinition/de-RelatedArtifact.document","version":"4.3.0","name":"RelatedArtifact.document","title":"RelatedArtifact.document","status":"draft","experimental":true,"date":"2022-05-28T12:47:40+10:00","publisher":"HL7 FHIR Standard","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"}]}],"description":"Data Element for RelatedArtifact.document","purpose":"Data Elements are defined for each element to assist in questionnaire construction etc","fhirVersion":"4.3.0","mapping":[{"identity":"rim","uri":"http://hl7.org/v3","name":"RIM Mapping"}],"kind":"logical","abstract":false,"type":"RelatedArtifact.document","baseDefinition":"http://hl7.org/fhir/StructureDefinition/Element","derivation":"specialization","snapshot":{"element":[{"id":"RelatedArtifact.document","path":"RelatedArtifact.document","short":"What document is being referenced","definition":"The document being referenced, represented as an attachment. This is exclusive with the resource element.","min":0,"max":"1","base":{"path":"RelatedArtifact.document","min":0,"max":"1"},"type":[{"code":"Attachment"}],"isModifier":false,"isSummary":true}]}};