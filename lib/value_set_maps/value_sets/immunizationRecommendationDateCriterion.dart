const immunizationRecommendationDateCriterion = {"resourceType":"ValueSet","id":"immunization-recommendation-date-criterion","meta":{"lastUpdated":"2022-05-28T12:47:40.239+10:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\"><ul><li>Include these codes as defined in <a href=\"http://loinc.org\"><code>http://loinc.org</code></a><table class=\"none\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td></tr><tr><td><a href=\"http://details.loinc.org/LOINC/30981-5.html\">30981-5</a></td><td>Earliest date to give</td></tr><tr><td><a href=\"http://details.loinc.org/LOINC/30980-7.html\">30980-7</a></td><td>Date vaccine due</td></tr><tr><td><a href=\"http://details.loinc.org/LOINC/59777-3.html\">59777-3</a></td><td>Latest date to give immunization</td></tr><tr><td><a href=\"http://details.loinc.org/LOINC/59778-1.html\">59778-1</a></td><td>Date when overdue for immunization</td></tr></table></li></ul></div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"pher"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"draft"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":1}],"url":"http://hl7.org/fhir/ValueSet/immunization-recommendation-date-criterion","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.3.308"}],"version":"4.3.0","name":"ImmunizationRecommendationDateCriterionCodes","title":"Immunization Recommendation Date Criterion Codes","status":"draft","experimental":true,"publisher":"FHIR Project team","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"}]}],"description":"The value set to instantiate this attribute should be drawn from a terminologically robust code system that consists of or contains concepts to support the definition of dates relevant to recommendations for future doses of vaccines. This value set is provided as a suggestive example.","copyright":"This content from LOINC® is copyright © 1995 Regenstrief Institute, Inc. and the LOINC Committee, and available at no cost under the license at http://loinc.org/terms-of-use.","compose":{"include":[{"system":"http://loinc.org","concept":[{"code":"30981-5"},{"code":"30980-7"},{"code":"59777-3"},{"code":"59778-1"}]}]}};