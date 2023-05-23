const searchXpathUsage = {"resourceType":"CodeSystem","id":"search-xpath-usage","meta":{"lastUpdated":"2022-05-28T13:47:40.239+11:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      \n      <h2>XPathUsageType</h2>\n      \n      <div>\n        \n        <p>How a search parameter relates to the set of elements returned by evaluating its xpath query.</p>\n\n      \n      </div>\n      \n      <p>This code system http://hl7.org/fhir/search-xpath-usage defines the following codes:</p>\n      \n      <table class=\"codes\">\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">\n            \n            <b>Code</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Display</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Definition</b>\n          \n          </td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">normal\n            \n            <a name=\"search-xpath-usage-normal\"> </a>\n          \n          </td>\n          \n          <td>Normal</td>\n          \n          <td>The search parameter is derived directly from the selected nodes based on the type definitions.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">phonetic\n            \n            <a name=\"search-xpath-usage-phonetic\"> </a>\n          \n          </td>\n          \n          <td>Phonetic</td>\n          \n          <td>The search parameter is derived by a phonetic transform from the selected nodes.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">nearby\n            \n            <a name=\"search-xpath-usage-nearby\"> </a>\n          \n          </td>\n          \n          <td>Nearby</td>\n          \n          <td>The search parameter is based on a spatial transform of the selected nodes.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">distance\n            \n            <a name=\"search-xpath-usage-distance\"> </a>\n          \n          </td>\n          \n          <td>Distance</td>\n          \n          <td>The search parameter is based on a spatial transform of the selected nodes, using physical distance from the middle.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">other\n            \n            <a name=\"search-xpath-usage-other\"> </a>\n          \n          </td>\n          \n          <td>Other</td>\n          \n          <td>The interpretation of the xpath statement is unknown (and can't be automated).</td>\n        \n        </tr>\n      \n      </table>\n    \n    </div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"fhir"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"trial-use"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":3}],"url":"http://hl7.org/fhir/search-xpath-usage","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.4.636"}],"version":"4.3.0","name":"XPathUsageType","title":"XPathUsageType","status":"draft","experimental":false,"date":"2021-01-17T07:06:13+11:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"How a search parameter relates to the set of elements returned by evaluating its xpath query.","caseSensitive":true,"valueSet":"http://hl7.org/fhir/ValueSet/search-xpath-usage","content":"complete","concept":[{"code":"normal","display":"Normal","definition":"The search parameter is derived directly from the selected nodes based on the type definitions."},{"code":"phonetic","display":"Phonetic","definition":"The search parameter is derived by a phonetic transform from the selected nodes."},{"code":"nearby","display":"Nearby","definition":"The search parameter is based on a spatial transform of the selected nodes."},{"code":"distance","display":"Distance","definition":"The search parameter is based on a spatial transform of the selected nodes, using physical distance from the middle."},{"code":"other","display":"Other","definition":"The interpretation of the xpath statement is unknown (and can't be automated)."}]};