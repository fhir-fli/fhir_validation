const evidenceClassifierCode = {"resourceType":"CodeSystem","id":"evidence-classifier-code","meta":{"lastUpdated":"2022-05-28T13:47:40.239+11:00","profile":["http://hl7.org/fhir/StructureDefinition/shareablecodesystem"]},"text":{"status":"generated","div":"<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      \n      <p>This code system http://terminology.hl7.org/CodeSystem/evidence-classifier-code defines the following codes:</p>\n      \n      <table class=\"codes\">\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">\n            \n            <b>Code</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Display</b>\n          \n          </td>\n          \n          <td>\n            \n            <b>Definition</b>\n          \n          </td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">COVID19Specific\n            \n            <a name=\"evidence-classifier-code-COVID19Specific\"> </a>\n          \n          </td>\n          \n          <td>COVID-19 specific article</td>\n          \n          <td>About COVID-19.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">COVID19Relevant\n            \n            <a name=\"evidence-classifier-code-COVID19Relevant\"> </a>\n          \n          </td>\n          \n          <td>COVID-19 relevant (but not specific) article</td>\n          \n          <td>Not about COVID-19 but relevant to COVID-19 management or understanding.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">COVID19HumanResearch\n            \n            <a name=\"evidence-classifier-code-COVID19HumanResearch\"> </a>\n          \n          </td>\n          \n          <td>COVID-19 human data in population, exposure, or outcome</td>\n          \n          <td>contains human COVID-19 disease in the research data as any variable (population, exposure or outcome).</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">OriginalResearch\n            \n            <a name=\"evidence-classifier-code-OriginalResearch\"> </a>\n          \n          </td>\n          \n          <td>Article includes original research</td>\n          \n          <td>such as randomized trial, observational study.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">ResearchSynthesis\n            \n            <a name=\"evidence-classifier-code-ResearchSynthesis\"> </a>\n          \n          </td>\n          \n          <td>Article includes synthesis of research</td>\n          \n          <td>such as systematic review, meta-analysis, rapid review.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">Guideline\n            \n            <a name=\"evidence-classifier-code-Guideline\"> </a>\n          \n          </td>\n          \n          <td>Article includes guideline</td>\n          \n          <td>for clinical practice guidelines.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">ResearchProtocol\n            \n            <a name=\"evidence-classifier-code-ResearchProtocol\"> </a>\n          \n          </td>\n          \n          <td>Article provides protocol without results</td>\n          \n          <td>for research protocols.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">NotResearchNotGuideline\n            \n            <a name=\"evidence-classifier-code-NotResearchNotGuideline\"> </a>\n          \n          </td>\n          \n          <td>Article is neither research nor guideline</td>\n          \n          <td>for things that are not research reports, research protocols or guidelines.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">Treatment\n            \n            <a name=\"evidence-classifier-code-Treatment\"> </a>\n          \n          </td>\n          \n          <td>Article about treatment</td>\n          \n          <td>about therapeutic interventions.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">PreventionAndControl\n            \n            <a name=\"evidence-classifier-code-PreventionAndControl\"> </a>\n          \n          </td>\n          \n          <td>Article about prevention and control</td>\n          \n          <td>about preventive care and interventions.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">Diagnosis\n            \n            <a name=\"evidence-classifier-code-Diagnosis\"> </a>\n          \n          </td>\n          \n          <td>Article about diagnosis</td>\n          \n          <td>about methods to distinguish having or not having a condition.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">PrognosisPrediction\n            \n            <a name=\"evidence-classifier-code-PrognosisPrediction\"> </a>\n          \n          </td>\n          \n          <td>Article about prognosis or prediction</td>\n          \n          <td>about predicting risk for something or risk factors for it.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsYes\n            \n            <a name=\"evidence-classifier-code-RatedAsYes\"> </a>\n          \n          </td>\n          \n          <td>Rated as yes, affirmative, positive, present, or include</td>\n          \n          <td/>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsNo\n            \n            <a name=\"evidence-classifier-code-RatedAsNo\"> </a>\n          \n          </td>\n          \n          <td>Rated as no, negative, absent, or exclude</td>\n          \n          <td>Rated as no, negative, absent, or exclude.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">NotAssessed\n            \n            <a name=\"evidence-classifier-code-NotAssessed\"> </a>\n          \n          </td>\n          \n          <td>Not rated, not assessed</td>\n          \n          <td>Neither rated as yes nor rated as no.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsRCT\n            \n            <a name=\"evidence-classifier-code-RatedAsRCT\"> </a>\n          \n          </td>\n          \n          <td>classified as randomized controlled trial</td>\n          \n          <td>classified as randomized controlled trial.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsControlledTrial\n            \n            <a name=\"evidence-classifier-code-RatedAsControlledTrial\"> </a>\n          \n          </td>\n          \n          <td>classified as nonrandomized controlled trial (experimental)</td>\n          \n          <td>classified as nonrandomized controlled trial (experimental).</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsComparativeCohort\n            \n            <a name=\"evidence-classifier-code-RatedAsComparativeCohort\"> </a>\n          \n          </td>\n          \n          <td>classified as comparative cohort study (observational)</td>\n          \n          <td>classified as comparative cohort study (observational).</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsCaseControl\n            \n            <a name=\"evidence-classifier-code-RatedAsCaseControl\"> </a>\n          \n          </td>\n          \n          <td>classified as case-control study</td>\n          \n          <td>classified as case-control study.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsUncontrolledSeries\n            \n            <a name=\"evidence-classifier-code-RatedAsUncontrolledSeries\"> </a>\n          \n          </td>\n          \n          <td>classified as uncontrolled cohort (case series)</td>\n          \n          <td>classified as uncontrolled cohort (case series).</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsMixedMethods\n            \n            <a name=\"evidence-classifier-code-RatedAsMixedMethods\"> </a>\n          \n          </td>\n          \n          <td>classified as mixed-methods study</td>\n          \n          <td>classified as mixed-methods study.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RatedAsOther\n            \n            <a name=\"evidence-classifier-code-RatedAsOther\"> </a>\n          \n          </td>\n          \n          <td>classified as other concept (not elsewhere classified)</td>\n          \n          <td>classified as other concept (not elsewhere classified).</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">RiskOfBias\n            \n            <a name=\"evidence-classifier-code-RiskOfBias\"> </a>\n          \n          </td>\n          \n          <td>Risk of bias assessment</td>\n          \n          <td>Risk of bias assessment.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">NoBlinding\n            \n            <a name=\"evidence-classifier-code-NoBlinding\"> </a>\n          \n          </td>\n          \n          <td>No blinding</td>\n          \n          <td>No blinding.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">AllocConcealNotStated\n            \n            <a name=\"evidence-classifier-code-AllocConcealNotStated\"> </a>\n          \n          </td>\n          \n          <td>Allocation concealment not stated</td>\n          \n          <td>Allocation concealment not stated.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">EarlyTrialTermination\n            \n            <a name=\"evidence-classifier-code-EarlyTrialTermination\"> </a>\n          \n          </td>\n          \n          <td>Early trial termination</td>\n          \n          <td>Early trial termination.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">NoITT\n            \n            <a name=\"evidence-classifier-code-NoITT\"> </a>\n          \n          </td>\n          \n          <td>No intention-to-treat analysis</td>\n          \n          <td>No intention-to-treat analysis.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">Preprint\n            \n            <a name=\"evidence-classifier-code-Preprint\"> </a>\n          \n          </td>\n          \n          <td>Preprint (not final publication)</td>\n          \n          <td>Results presented in preprint (pre-final publication) form.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">PreliminaryAnalysis\n            \n            <a name=\"evidence-classifier-code-PreliminaryAnalysis\"> </a>\n          \n          </td>\n          \n          <td>Preliminary analysis</td>\n          \n          <td>Preliminary analysis.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">BaselineImbalance\n            \n            <a name=\"evidence-classifier-code-BaselineImbalance\"> </a>\n          \n          </td>\n          \n          <td>Baseline imbalances</td>\n          \n          <td>Differences between groups at start of trial may confound or bias the findings.</td>\n        \n        </tr>\n        \n        <tr>\n          \n          <td style=\"white-space:nowrap\">SubgroupAnalysis\n            \n            <a name=\"evidence-classifier-code-SubgroupAnalysis\"> </a>\n          \n          </td>\n          \n          <td>Subgroup analysis</td>\n          \n          <td>Subgroup analysis.</td>\n        \n        </tr>\n      \n      </table>\n    \n    </div>"},"extension":[{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-wg","valueCode":"cds"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status","valueCode":"trial-use"},{"url":"http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm","valueInteger":0}],"url":"http://terminology.hl7.org/CodeSystem/evidence-classifier-code","identifier":[{"system":"urn:ietf:rfc:3986","value":"urn:oid:2.16.840.1.113883.4.642.1.0"}],"version":"4.3.0","name":"EvidenceClassifier","title":"EvidenceClassifier","status":"draft","experimental":false,"date":"2020-12-28T16:55:11+11:00","publisher":"HL7 (FHIR Project)","contact":[{"telecom":[{"system":"url","value":"http://hl7.org/fhir"},{"system":"email","value":"fhir@lists.hl7.org"}]}],"description":"Commonly used classifiers for evidence sets.","caseSensitive":true,"valueSet":"http://hl7.org/fhir/ValueSet/evidence-classifier-code","content":"complete","concept":[{"code":"COVID19Specific","display":"COVID-19 specific article","definition":"About COVID-19."},{"code":"COVID19Relevant","display":"COVID-19 relevant (but not specific) article","definition":"Not about COVID-19 but relevant to COVID-19 management or understanding."},{"code":"COVID19HumanResearch","display":"COVID-19 human data in population, exposure, or outcome","definition":"contains human COVID-19 disease in the research data as any variable (population, exposure or outcome)."},{"code":"OriginalResearch","display":"Article includes original research","definition":"such as randomized trial, observational study."},{"code":"ResearchSynthesis","display":"Article includes synthesis of research","definition":"such as systematic review, meta-analysis, rapid review."},{"code":"Guideline","display":"Article includes guideline","definition":"for clinical practice guidelines."},{"code":"ResearchProtocol","display":"Article provides protocol without results","definition":"for research protocols."},{"code":"NotResearchNotGuideline","display":"Article is neither research nor guideline","definition":"for things that are not research reports, research protocols or guidelines."},{"code":"Treatment","display":"Article about treatment","definition":"about therapeutic interventions."},{"code":"PreventionAndControl","display":"Article about prevention and control","definition":"about preventive care and interventions."},{"code":"Diagnosis","display":"Article about diagnosis","definition":"about methods to distinguish having or not having a condition."},{"code":"PrognosisPrediction","display":"Article about prognosis or prediction","definition":"about predicting risk for something or risk factors for it."},{"code":"RatedAsYes","display":"Rated as yes, affirmative, positive, present, or include"},{"code":"RatedAsNo","display":"Rated as no, negative, absent, or exclude","definition":"Rated as no, negative, absent, or exclude."},{"code":"NotAssessed","display":"Not rated, not assessed","definition":"Neither rated as yes nor rated as no."},{"code":"RatedAsRCT","display":"classified as randomized controlled trial","definition":"classified as randomized controlled trial."},{"code":"RatedAsControlledTrial","display":"classified as nonrandomized controlled trial (experimental)","definition":"classified as nonrandomized controlled trial (experimental)."},{"code":"RatedAsComparativeCohort","display":"classified as comparative cohort study (observational)","definition":"classified as comparative cohort study (observational)."},{"code":"RatedAsCaseControl","display":"classified as case-control study","definition":"classified as case-control study."},{"code":"RatedAsUncontrolledSeries","display":"classified as uncontrolled cohort (case series)","definition":"classified as uncontrolled cohort (case series)."},{"code":"RatedAsMixedMethods","display":"classified as mixed-methods study","definition":"classified as mixed-methods study."},{"code":"RatedAsOther","display":"classified as other concept (not elsewhere classified)","definition":"classified as other concept (not elsewhere classified)."},{"code":"RiskOfBias","display":"Risk of bias assessment","definition":"Risk of bias assessment."},{"code":"NoBlinding","display":"No blinding","definition":"No blinding."},{"code":"AllocConcealNotStated","display":"Allocation concealment not stated","definition":"Allocation concealment not stated."},{"code":"EarlyTrialTermination","display":"Early trial termination","definition":"Early trial termination."},{"code":"NoITT","display":"No intention-to-treat analysis","definition":"No intention-to-treat analysis."},{"code":"Preprint","display":"Preprint (not final publication)","definition":"Results presented in preprint (pre-final publication) form."},{"code":"PreliminaryAnalysis","display":"Preliminary analysis","definition":"Preliminary analysis."},{"code":"BaselineImbalance","display":"Baseline imbalances","definition":"Differences between groups at start of trial may confound or bias the findings."},{"code":"SubgroupAnalysis","display":"Subgroup analysis","definition":"Subgroup analysis."}]};