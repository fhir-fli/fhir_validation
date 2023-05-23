const questionnaireReferenceResource = {"resourceType":"StructureDefinition","id":"questionnaire-referenceResource","extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"fhir"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":1}],"url":"http://hl7.org/fhir/StructureDefinition/questionnaire-referenceResource","version":"4.3.0","name":"referenceResource","status":"draft","experimental":false,"date":"2013-07-04","publisher":"HL7","contact":[{"telecom":[{"system":"url","value":"http://www.hl7.org"}]}],"description":"Where the type for a question is \"Reference\", indicates a type of resource that is permitted.","fhirVersion":"4.3.0","mapping":[{"identity":"rim","uri":"http://hl7.org/v3","name":"RIM Mapping"}],"kind":"complex-type","abstract":false,"context":[{"type":"element","expression":"Questionnaire.item"},{"type":"element","expression":"Questionnaire.item.item"}],"contextInvariant":["type='reference'"],"type":"Extension","baseDefinition":"http://hl7.org/fhir/StructureDefinition/Extension","derivation":"constraint","snapshot":{"element":[{"id":"Extension","path":"Extension","short":"Allowed resource for reference","definition":"Where the type for a question is \"Reference\", indicates a type of resource that is permitted.","comment":"This extension only has meaning if the question.type = Reference.  If no allowedResource extensions are present, the presumption is that any type of resource is permitted.  If multiple are present, then any of the specified types are permitted.","min":0,"max":"*","base":{"path":"Extension","min":0,"max":"*"},"condition":["ele-1"],"constraint":[{"key":"ele-1","severity":"error","human":"All FHIR elements must have a @value or children unless an empty Parameters resource","expression":"hasValue() or (children().count() > id.count()) or \$this is Parameters","xpath":"@value|f:*|h:div|self::f:Parameters","source":"http://hl7.org/fhir/StructureDefinition/Element"},{"key":"ext-1","severity":"error","human":"Must have either extensions or value[x], not both","expression":"extension.exists() != value.exists()","xpath":"exists(f:extension)!=exists(f:*[starts-with(local-name(.), 'value')])","source":"http://hl7.org/fhir/StructureDefinition/Extension"}],"isModifier":false,"mapping":[{"identity":"rim","map":"N/A - MIF rather than RIM level"}]},{"id":"Extension.id","path":"Extension.id","representation":["xmlAttr"],"short":"Unique id for inter-element referencing","definition":"Unique id for the element within a resource (for internal references). This may be any string value that does not contain spaces.","min":0,"max":"1","base":{"path":"Element.id","min":0,"max":"1"},"type":[{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type","valueUrl":"id"}],"code":"http://hl7.org/fhirpath/System.String"}],"isModifier":false,"isSummary":false,"mapping":[{"identity":"rim","map":"n/a"}]},{"id":"Extension.extension","path":"Extension.extension","slicing":{"discriminator":[{"type":"value","path":"url"}],"description":"Extensions are always sliced by (at least) url","rules":"open"},"short":"Extension","definition":"An Extension","min":0,"max":"0","base":{"path":"Element.extension","min":0,"max":"*"},"type":[{"code":"Extension"}],"constraint":[{"key":"ele-1","severity":"error","human":"All FHIR elements must have a @value or children","expression":"hasValue() or (children().count() > id.count())","xpath":"@value|f:*|h:div","source":"http://hl7.org/fhir/StructureDefinition/Element"},{"key":"ext-1","severity":"error","human":"Must have either extensions or value[x], not both","expression":"extension.exists() != value.exists()","xpath":"exists(f:extension)!=exists(f:*[starts-with(local-name(.), \"value\")])","source":"http://hl7.org/fhir/StructureDefinition/Extension"}],"isModifier":false,"isSummary":false},{"id":"Extension.url","path":"Extension.url","representation":["xmlAttr"],"short":"identifies the meaning of the extension","definition":"Source of the definition for the extension code - a logical name or a URL.","comment":"The definition may point directly to a computable or human-readable definition of the extensibility codes, or it may be a logical URI as declared in some other specification. The definition SHALL be a URI for the Structure Definition defining the extension.","min":1,"max":"1","base":{"path":"Extension.url","min":1,"max":"1"},"type":[{"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type","valueUrl":"uri"}],"code":"http://hl7.org/fhirpath/System.String"}],"fixedUri":"http://hl7.org/fhir/StructureDefinition/questionnaire-referenceResource","isModifier":false,"isSummary":false,"mapping":[{"identity":"rim","map":"N/A"}]},{"id":"Extension.value[x]","path":"Extension.value[x]","short":"Value of extension","definition":"Value of extension - must be one of a constrained set of the data types (see [Extensibility](extensibility.html) for a list).","min":1,"max":"1","base":{"path":"Extension.value[x]","min":0,"max":"1"},"type":[{"code":"code"}],"constraint":[{"key":"ele-1","severity":"error","human":"All FHIR elements must have a @value or children","expression":"hasValue() or (children().count() > id.count())","xpath":"@value|f:*|h:div","source":"http://hl7.org/fhir/StructureDefinition/Element"}],"isModifier":false,"isSummary":false,"binding":{"extension":[{"url":"http://hl7.org/fhir/build/StructureDefinition/definition","valueString":"One of the resource types defined as part of this version of FHIR."},{"url":"http://hl7.org/fhir/StructureDefinition/elementdefinition-bindingName","valueString":"ResourceType"},{"url":"http://hl7.org/fhir/StructureDefinition/elementdefinition-isCommonBinding","valueBoolean":true}],"strength":"required","description":"One of the resource types defined as part of this version of FHIR.","valueSet":"http://hl7.org/fhir/ValueSet/resource-types"},"mapping":[{"identity":"rim","map":"N/A"}]}]},"differential":{"element":[{"id":"Extension","path":"Extension","short":"Allowed resource for reference","definition":"Where the type for a question is \"Reference\", indicates a type of resource that is permitted.","comment":"This extension only has meaning if the question.type = Reference.  If no allowedResource extensions are present, the presumption is that any type of resource is permitted.  If multiple are present, then any of the specified types are permitted.","min":0,"max":"*","mapping":[{"identity":"rim","map":"N/A - MIF rather than RIM level"}]},{"id":"Extension.extension","path":"Extension.extension","max":"0"},{"id":"Extension.url","path":"Extension.url","fixedUri":"http://hl7.org/fhir/StructureDefinition/questionnaire-referenceResource"},{"id":"Extension.value[x]","path":"Extension.value[x]","min":1,"type":[{"code":"code"}],"binding":{"extension":[{"url":"http://hl7.org/fhir/build/StructureDefinition/definition","valueString":"One of the resource types defined as part of this version of FHIR."},{"url":"http://hl7.org/fhir/StructureDefinition/elementdefinition-bindingName","valueString":"ResourceType"},{"url":"http://hl7.org/fhir/StructureDefinition/elementdefinition-isCommonBinding","valueBoolean":true}],"strength":"required","description":"One of the resource types defined as part of this version of FHIR.","valueSet":"http://hl7.org/fhir/ValueSet/resource-types"}}]}};