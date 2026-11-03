# How other FHIR validators work (survey, 2026-11-03)

Why: fhir_validation runs each FHIRPath constraint on a copy of one element,
rebuilt by guessing its type. The root has no type, so most constraints never
run, and failures are reported as `information`. Before rebuilding, we read
how the other validators do it. Everything below is from reading their
source at the commit named; none of them was run.

## Sources read

| Implementation | Repo @ commit (date) | Files read |
|---|---|---|
| HL7 Java validator | hapifhir/org.hl7.fhir.core @ 428bcd5 (2026-11-03), latest release 7.0.4 | `InstanceValidator.java` (9,740 lines): `checkInvariants`, `checkInvariant`; `utils/FHIRPathExpressionFixer.java` |
| HAPI FHIR | hapifhir/hapi-fhir @ 8eafcdb (2026-11-02) | root `pom.xml`; `hapi-fhir-validation/.../validator/ValidatorWrapper.java`, `FhirInstanceValidator.java`, `WorkerContextValidationSupportAdapter.java` |
| Android FHIR SDK | google/android-fhir @ 28a5034 (2026-02-24) | `gradle/libs.versions.toml`, `*/build.gradle.kts`, `engine`, `datacapture`, `workflow`, `knowledge` sources |
| Medplum (TypeScript) | medplum/medplum @ d837eed (2026-11-03) | `packages/core/src/typeschema/validation.ts` |
| Firely validator (.NET) | FirelyTeam/firely-validator-api @ 0d79b6d (2026-10-29), BSD-3 | `src/Firely.Fhir.Validation/Impl/*`, `Compilation.Shared/SchemaBuilders/FhirPathBuilder.cs` |
| Microsoft FHIR server | microsoft/fhir-server (contents API, 2026-11-03) | `Features/Validation/ProfileValidator.cs` |
| IBM / LinuxForHealth | LinuxForHealth/FHIR @ 8429bf7, last push 2024-04-18 | `fhir-validation/.../FHIRValidator.java` |
| HL7 shared test suite | FHIR/fhir-test-cases @ cb4eac4 (2026-11-03) | `validator/manifest.json` |

Not read: Blaze (samply/blaze), Aidbox (closed source), Python and Rust
libraries. Unknown whether any of them validates against profiles.

## Findings

**Where a constraint runs.** Java, Firely and Medplum all evaluate the
expression on the element where it sits inside the whole parsed resource,
never on a copy.
- Java: `fpe.evaluateToBoolean(valContext, resource, valContext.getRootResource(), element, n)`, so `%resource` and `%rootResource` are set.
- Medplum: `isExpressionTrue` sets `%context`, `%resource` (current resource on its stack) and `%rootResource`.
- Firely: evaluates on a `PocoNode`, the node inside the full tree.
- IBM: evaluates from an `EvaluationContext` rooted at the resource.

**Severity.**
- Java: `ConstraintSeverity.ERROR` becomes an error and `WARNING` a warning. Best-practice constraints follow a setting (hint, warning or error).
- Firely: the declared severity, or a best-practice setting.
- Medplum: runs only `error` constraints and skips warnings entirely.
- An expression that throws: Java reports it as a failed constraint, Firely as `PROFILE_ELEMENTDEF_INVALID_FHIRPATH_EXPRESSION`, and Medplum as a processing issue.

**Constraints not run as written.** All of them have a short list, each entry
with a reason or code that replaces it.
- Java: skips `dom-3`, which it enforces in code. Skips `eld-24` for some paths. Rewrites `dom-6`, `eld-19`, `eld-20`, `opd-3`, `que-7`, `ras-2` and `txt-2` (`FHIRPathExpressionFixer`).
- Firely: replaces `ele-1`, `ext-1`, `txt-1` and `txt-2` with hand-written validators.
- Medplum: skips `ele-1`, `dom-3`, `org-1` and `sdf-19`.

**Structure.**
- Java walks the snapshot directly, on every validation.
- Firely compiles each StructureDefinition once into a tree of small checks: `CardinalityValidator`, `FixedValidator`, `PatternValidator`, `SliceValidator`, `MaxLengthValidator`, `MinMaxValueValidator`, `BindingValidator`, `FhirPathValidator` and others.
- Medplum also precompiles, into its own `InternalTypeSchema`.
- All three do slicing, and fixed and pattern as values.

**HAPI is the Java validator, but runs a different version and a different lookup layer.**
- `ValidatorWrapper` builds `org.hl7.fhir.validation.instance.InstanceValidator`.
- It pins `fhir_core_version` 6.10.3 (released 2026-08-26), 893 commits behind 7.0.4.
- It replaces HL7's worker context with its own `WorkerContextValidationSupportAdapter` and `ValidationSupportChain`, for profiles and terminology.
- This is from the code. We did not run HAPI and the HL7 command-line validator side by side.

**The Android FHIR SDK has no resource validator.**
- `engine` and `datacapture` depend on `hapi-fhir-validation` 6.8.0, but no main source imports a validator. The search was checked first: it does find `FHIRPathEngine` in `ResourceIndexer.kt`.
- `datacapture/.../validation/` validates QuestionnaireResponse answers only (required, min and max, regex, constraint extensions).

**Microsoft's server** calls Firely's older `Hl7.Fhir.Validation.Validator` from `ProfileValidator.cs`.

**HL7's shared validator test suite.**
- `validator/manifest.json` holds 1,145 cases. 699 are R4 or R4B, 53 of them in the terminology module.
- 1,141 cases have recorded Java outcomes, about 170 have Firely outcomes, and 71 have outcomes for "brianpos" (a .NET validator).
- The largest modules are profile (249), general (191), questionnaire (118) and tx (95). invariants has 10.

## What this means for fhir_validation

- Run each constraint in place inside the parsed resource, with `%resource` and `%rootResource` set, as all three do.
- Report by the constraint's own severity, as Java and Firely do.
- Any constraint we don't run as written gets a named reason and a code replacement, as in Java's and Firely's lists.
- Compile each StructureDefinition once and cache it (Firely, Medplum). Java's behaviour is the reference for expected results.
- Prove it on the shared suite's R4/R4B cases against the recorded Java outcomes, then on the 138 HL7 examples.
