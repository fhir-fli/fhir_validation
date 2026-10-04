# fhir_validation

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
