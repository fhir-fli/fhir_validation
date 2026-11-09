# fhir_validation

## [0.13.2]

Checked against HL7's Java validator (hapifhir/org.hl7.fhir.core master
f6d3c306, InstanceValidator.java) and measured on all 3,022 R4B examples,
before and after: 24,907 constraint "violations" at information level and
their "Context is null" errors are gone (none had evaluated the
constraint); 165 examples that stopped on a missing value set now
validate; no example that validated before now stops; the one new finding
is cmd-1 on 7 ConceptMap targets that are narrower with no comment, which
the examples really do lack.

- A failed constraint is reported at its own severity: `error` as an
  error, `warning` as a warning, a best-practice constraint as a warning
  (HL7's default). It was information for every constraint. The message
  names the key. Needs fhir_path 0.15.3 (`ElementConstraint.severity`).
- A binding's value set is looked up only for an element the resource
  has. Not in the cache is a warning, "ValueSet '<url>' not found"; a
  CodeSystem's url in its place is an error. It threw for every binding in
  the profile, present or not (`resolveBoundValueSet`, new).
- A repeating element's constraints are evaluated item by item, and
  reported at the item. They were never evaluated.
- An element typed Element or BackboneElement (`DataRequirement.codeFilter`,
  `Questionnaire.item`) is evaluated over its JSON. Built as the base type
  it kept only id and extensions, so drq-1 failed on every codeFilter with
  a path. A contained resource is read as the resource it names.
- A primitive the model will not build (a narrative it refuses) is still
  checked by its constraints, over its JSON value: a `javascript:` link
  fails txt-1 as an error.
- `%resource` and `%rootResource` are set for constraints: the resource
  being validated, or the contained resource an element sits inside.
  que-1a (`%resource.status`) stopped the validation without them.
- A constraint the engine cannot evaluate is reported as an error naming
  it, not thrown.

## [0.13.1]

- A complex element's type is found from its type code. The nested lookups
  (validate_structure, validate_cardinality) asked the cache for the bare
  code, `HumanName`; a cache keyed by canonical URL holds it at
  `http://hl7.org/fhir/StructureDefinition/HumanName`, so every complex
  element was reported "No StructureDefinition or Profile found". All three
  type lookups now use fhir_path's `typeCodeCanonical` (needs fhir_path
  0.15.1). On HL7's 138 R4B examples of seven types this message went from
  128 of 192 errors (first 13 examples) to none.

## [0.13.0]

- One validation package for every FHIR version, revived from the 2024
  `fhir_validation` (which carried a copy per version over the old `fhir`
  package). The code is fhir_r4_validation 0.12.0's, which was identical in
  fhir_r5_validation and fhir_r6_validation but for names and one unguarded
  read; those three become bindings over this package.
- A binding supplies one `ValidationModel<R>` (fhir_node's `ResourceModel`
  plus the version's primitive-value rules, a typed FHIRPath context from a
  JSON value, and its fhir_path binding). Definitions are read by element
  name: `ElementNode` views an ElementDefinition (path, types, min/max,
  binding, pattern, min/max value, constraints, extension urls),
  `extractElements` takes any StructureDefinition node, `getValueSetCodes`
  any ValueSet or CodeSystem node, `validateQuestionnaireResponse` any
  QuestionnaireResponse node. `validateStructure`, `validateExtensions`
  and `validateInvariants` take the model; `ValidationResults` gives its
  OperationOutcome as JSON (`toOperationOutcomeJson`), a binding parses it.
- Three findings, each with a test that failed on the typed code:
  - `validateBindings` never checked a binding. It looked an element path's
    first segment (the resource type) up as a property of the root, found
    nothing, and stopped; and the value it would have found is a
    LiteralNode, which it did not handle. The type segment is skipped, a
    found literal is checked, and a repeating coded element is checked
    item by item. A required binding violation on a literal is now reported
    twice, once by the structure pass and once here, in different words.
  - A required element present as an empty object (`"name": {}`) counted
    as populated. R4B json.html: "objects are never empty".
  - `isValidPrimitive`, `fromType` and the resource type names come from
    the model, so the R5 copy's unguarded `questionnaire` read is gone.
- The 2,300-line copy of `grapheme_splitter` (Unicode 10.0.0 rules, one
  caller) is replaced by the Dart team's `characters` (Unicode 16.0.0).
- Known limit, as before: `validateBindings` reaches an element path only
  through objects and indexed segments; a binding under a repeating element
  (`Observation.category.coding.code`) is not walked.
- No dependency on any fhir_r* package. `ElementNode` is fhir_path
  0.15.0's, re-exported here.
