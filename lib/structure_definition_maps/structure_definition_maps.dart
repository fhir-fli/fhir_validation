import 'structure_definitions/structureDefinitions.dart';

const structureDefinitionMaps = <String, Map<String, dynamic>>{
  "http://hl7.org/fhir/StructureDefinition/Resource": resource,
  "Resource": resource,
  "http://hl7.org/fhir/StructureDefinition/Account": account,
  "Account": account,
  "http://hl7.org/fhir/StructureDefinition/ActivityDefinition":
      activityDefinition,
  "ActivityDefinition": activityDefinition,
  "http://hl7.org/fhir/StructureDefinition/AdministrableProductDefinition":
      administrableProductDefinition,
  "AdministrableProductDefinition": administrableProductDefinition,
  "http://hl7.org/fhir/StructureDefinition/AdverseEvent": adverseEvent,
  "AdverseEvent": adverseEvent,
  "http://hl7.org/fhir/StructureDefinition/AllergyIntolerance":
      allergyIntolerance,
  "AllergyIntolerance": allergyIntolerance,
  "http://hl7.org/fhir/StructureDefinition/Appointment": appointment,
  "Appointment": appointment,
  "http://hl7.org/fhir/StructureDefinition/AppointmentResponse":
      appointmentResponse,
  "AppointmentResponse": appointmentResponse,
  "http://hl7.org/fhir/StructureDefinition/AuditEvent": auditEvent,
  "AuditEvent": auditEvent,
  "http://hl7.org/fhir/StructureDefinition/Basic": basic,
  "Basic": basic,
  "http://hl7.org/fhir/StructureDefinition/Binary": binary,
  "Binary": binary,
  "http://hl7.org/fhir/StructureDefinition/BiologicallyDerivedProduct":
      biologicallyDerivedProduct,
  "BiologicallyDerivedProduct": biologicallyDerivedProduct,
  "http://hl7.org/fhir/StructureDefinition/BodyStructure": bodyStructure,
  "BodyStructure": bodyStructure,
  "http://hl7.org/fhir/StructureDefinition/Bundle": bundle,
  "Bundle": bundle,
  "http://hl7.org/fhir/StructureDefinition/CapabilityStatement":
      capabilityStatement,
  "CapabilityStatement": capabilityStatement,
  "http://hl7.org/fhir/StructureDefinition/CarePlan": carePlan,
  "CarePlan": carePlan,
  "http://hl7.org/fhir/StructureDefinition/CareTeam": careTeam,
  "CareTeam": careTeam,
  "http://hl7.org/fhir/StructureDefinition/CatalogEntry": catalogEntry,
  "CatalogEntry": catalogEntry,
  "http://hl7.org/fhir/StructureDefinition/ChargeItem": chargeItem,
  "ChargeItem": chargeItem,
  "http://hl7.org/fhir/StructureDefinition/ChargeItemDefinition":
      chargeItemDefinition,
  "ChargeItemDefinition": chargeItemDefinition,
  "http://hl7.org/fhir/StructureDefinition/Citation": citation,
  "Citation": citation,
  "http://hl7.org/fhir/StructureDefinition/Claim": claim,
  "Claim": claim,
  "http://hl7.org/fhir/StructureDefinition/ClaimResponse": claimResponse,
  "ClaimResponse": claimResponse,
  "http://hl7.org/fhir/StructureDefinition/ClinicalImpression":
      clinicalImpression,
  "ClinicalImpression": clinicalImpression,
  "http://hl7.org/fhir/StructureDefinition/ClinicalUseDefinition":
      clinicalUseDefinition,
  "ClinicalUseDefinition": clinicalUseDefinition,
  "http://hl7.org/fhir/StructureDefinition/CodeSystem": codeSystem,
  "CodeSystem": codeSystem,
  "http://hl7.org/fhir/StructureDefinition/Communication": communication,
  "Communication": communication,
  "http://hl7.org/fhir/StructureDefinition/CommunicationRequest":
      communicationRequest,
  "CommunicationRequest": communicationRequest,
  "http://hl7.org/fhir/StructureDefinition/CompartmentDefinition":
      compartmentDefinition,
  "CompartmentDefinition": compartmentDefinition,
  "http://hl7.org/fhir/StructureDefinition/Composition": composition,
  "Composition": composition,
  "http://hl7.org/fhir/StructureDefinition/ConceptMap": conceptMap,
  "ConceptMap": conceptMap,
  "http://hl7.org/fhir/StructureDefinition/Condition": condition,
  "Condition": condition,
  "http://hl7.org/fhir/StructureDefinition/Consent": consent,
  "Consent": consent,
  "http://hl7.org/fhir/StructureDefinition/Contract": contract,
  "Contract": contract,
  "http://hl7.org/fhir/StructureDefinition/Coverage": coverage,
  "Coverage": coverage,
  "http://hl7.org/fhir/StructureDefinition/CoverageEligibilityRequest":
      coverageEligibilityRequest,
  "CoverageEligibilityRequest": coverageEligibilityRequest,
  "http://hl7.org/fhir/StructureDefinition/CoverageEligibilityResponse":
      coverageEligibilityResponse,
  "CoverageEligibilityResponse": coverageEligibilityResponse,
  "http://hl7.org/fhir/StructureDefinition/DetectedIssue": detectedIssue,
  "DetectedIssue": detectedIssue,
  "http://hl7.org/fhir/StructureDefinition/Device": device,
  "Device": device,
  "http://hl7.org/fhir/StructureDefinition/DeviceDefinition": deviceDefinition,
  "DeviceDefinition": deviceDefinition,
  "http://hl7.org/fhir/StructureDefinition/DeviceMetric": deviceMetric,
  "DeviceMetric": deviceMetric,
  "http://hl7.org/fhir/StructureDefinition/DeviceRequest": deviceRequest,
  "DeviceRequest": deviceRequest,
  "http://hl7.org/fhir/StructureDefinition/DeviceUseStatement":
      deviceUseStatement,
  "DeviceUseStatement": deviceUseStatement,
  "http://hl7.org/fhir/StructureDefinition/DiagnosticReport": diagnosticReport,
  "DiagnosticReport": diagnosticReport,
  "http://hl7.org/fhir/StructureDefinition/DocumentManifest": documentManifest,
  "DocumentManifest": documentManifest,
  "http://hl7.org/fhir/StructureDefinition/DocumentReference":
      documentReference,
  "DocumentReference": documentReference,
  "http://hl7.org/fhir/StructureDefinition/DomainResource": domainResource,
  "DomainResource": domainResource,
  "http://hl7.org/fhir/StructureDefinition/Encounter": encounter,
  "Encounter": encounter,
  "http://hl7.org/fhir/StructureDefinition/Endpoint": endpoint,
  "Endpoint": endpoint,
  "http://hl7.org/fhir/StructureDefinition/EnrollmentRequest":
      enrollmentRequest,
  "EnrollmentRequest": enrollmentRequest,
  "http://hl7.org/fhir/StructureDefinition/EnrollmentResponse":
      enrollmentResponse,
  "EnrollmentResponse": enrollmentResponse,
  "http://hl7.org/fhir/StructureDefinition/EpisodeOfCare": episodeOfCare,
  "EpisodeOfCare": episodeOfCare,
  "http://hl7.org/fhir/StructureDefinition/EventDefinition": eventDefinition,
  "EventDefinition": eventDefinition,
  "http://hl7.org/fhir/StructureDefinition/Evidence": evidence,
  "Evidence": evidence,
  "http://hl7.org/fhir/StructureDefinition/EvidenceReport": evidenceReport,
  "EvidenceReport": evidenceReport,
  "http://hl7.org/fhir/StructureDefinition/EvidenceVariable": evidenceVariable,
  "EvidenceVariable": evidenceVariable,
  "http://hl7.org/fhir/StructureDefinition/ExampleScenario": exampleScenario,
  "ExampleScenario": exampleScenario,
  "http://hl7.org/fhir/StructureDefinition/ExplanationOfBenefit":
      explanationOfBenefit,
  "ExplanationOfBenefit": explanationOfBenefit,
  "http://hl7.org/fhir/StructureDefinition/FamilyMemberHistory":
      familyMemberHistory,
  "FamilyMemberHistory": familyMemberHistory,
  "http://hl7.org/fhir/StructureDefinition/Flag": flag,
  "Flag": flag,
  "http://hl7.org/fhir/StructureDefinition/Goal": goal,
  "Goal": goal,
  "http://hl7.org/fhir/StructureDefinition/GraphDefinition": graphDefinition,
  "GraphDefinition": graphDefinition,
  "http://hl7.org/fhir/StructureDefinition/Group": group,
  "Group": group,
  "http://hl7.org/fhir/StructureDefinition/GuidanceResponse": guidanceResponse,
  "GuidanceResponse": guidanceResponse,
  "http://hl7.org/fhir/StructureDefinition/HealthcareService":
      healthcareService,
  "HealthcareService": healthcareService,
  "http://hl7.org/fhir/StructureDefinition/ImagingStudy": imagingStudy,
  "ImagingStudy": imagingStudy,
  "http://hl7.org/fhir/StructureDefinition/Immunization": immunization,
  "Immunization": immunization,
  "http://hl7.org/fhir/StructureDefinition/ImmunizationEvaluation":
      immunizationEvaluation,
  "ImmunizationEvaluation": immunizationEvaluation,
  "http://hl7.org/fhir/StructureDefinition/ImmunizationRecommendation":
      immunizationRecommendation,
  "ImmunizationRecommendation": immunizationRecommendation,
  "http://hl7.org/fhir/StructureDefinition/ImplementationGuide":
      implementationGuide,
  "ImplementationGuide": implementationGuide,
  "http://hl7.org/fhir/StructureDefinition/Ingredient": ingredient,
  "Ingredient": ingredient,
  "http://hl7.org/fhir/StructureDefinition/InsurancePlan": insurancePlan,
  "InsurancePlan": insurancePlan,
  "http://hl7.org/fhir/StructureDefinition/Invoice": invoice,
  "Invoice": invoice,
  "http://hl7.org/fhir/StructureDefinition/Library": library,
  "Library": library,
  "http://hl7.org/fhir/StructureDefinition/Linkage": linkage,
  "Linkage": linkage,
  "http://hl7.org/fhir/StructureDefinition/List": list,
  "List": list,
  "http://hl7.org/fhir/StructureDefinition/Location": location,
  "Location": location,
  "http://hl7.org/fhir/StructureDefinition/ManufacturedItemDefinition":
      manufacturedItemDefinition,
  "ManufacturedItemDefinition": manufacturedItemDefinition,
  "http://hl7.org/fhir/StructureDefinition/Measure": measure,
  "Measure": measure,
  "http://hl7.org/fhir/StructureDefinition/MeasureReport": measureReport,
  "MeasureReport": measureReport,
  "http://hl7.org/fhir/StructureDefinition/Media": media,
  "Media": media,
  "http://hl7.org/fhir/StructureDefinition/Medication": medication,
  "Medication": medication,
  "http://hl7.org/fhir/StructureDefinition/MedicationAdministration":
      medicationAdministration,
  "MedicationAdministration": medicationAdministration,
  "http://hl7.org/fhir/StructureDefinition/MedicationDispense":
      medicationDispense,
  "MedicationDispense": medicationDispense,
  "http://hl7.org/fhir/StructureDefinition/MedicationKnowledge":
      medicationKnowledge,
  "MedicationKnowledge": medicationKnowledge,
  "http://hl7.org/fhir/StructureDefinition/MedicationRequest":
      medicationRequest,
  "MedicationRequest": medicationRequest,
  "http://hl7.org/fhir/StructureDefinition/MedicationStatement":
      medicationStatement,
  "MedicationStatement": medicationStatement,
  "http://hl7.org/fhir/StructureDefinition/MedicinalProductDefinition":
      medicinalProductDefinition,
  "MedicinalProductDefinition": medicinalProductDefinition,
  "http://hl7.org/fhir/StructureDefinition/MessageDefinition":
      messageDefinition,
  "MessageDefinition": messageDefinition,
  "http://hl7.org/fhir/StructureDefinition/MessageHeader": messageHeader,
  "MessageHeader": messageHeader,
  "http://hl7.org/fhir/StructureDefinition/MolecularSequence":
      molecularSequence,
  "MolecularSequence": molecularSequence,
  "http://hl7.org/fhir/StructureDefinition/NamingSystem": namingSystem,
  "NamingSystem": namingSystem,
  "http://hl7.org/fhir/StructureDefinition/NutritionOrder": nutritionOrder,
  "NutritionOrder": nutritionOrder,
  "http://hl7.org/fhir/StructureDefinition/NutritionProduct": nutritionProduct,
  "NutritionProduct": nutritionProduct,
  "http://hl7.org/fhir/StructureDefinition/Observation": observation,
  "Observation": observation,
  "http://hl7.org/fhir/StructureDefinition/ObservationDefinition":
      observationDefinition,
  "ObservationDefinition": observationDefinition,
  "http://hl7.org/fhir/StructureDefinition/OperationDefinition":
      operationDefinition,
  "OperationDefinition": operationDefinition,
  "http://hl7.org/fhir/StructureDefinition/OperationOutcome": operationOutcome,
  "OperationOutcome": operationOutcome,
  "http://hl7.org/fhir/StructureDefinition/Organization": organization,
  "Organization": organization,
  "http://hl7.org/fhir/StructureDefinition/OrganizationAffiliation":
      organizationAffiliation,
  "OrganizationAffiliation": organizationAffiliation,
  "http://hl7.org/fhir/StructureDefinition/PackagedProductDefinition":
      packagedProductDefinition,
  "PackagedProductDefinition": packagedProductDefinition,
  "http://hl7.org/fhir/StructureDefinition/Parameters": parameters,
  "Parameters": parameters,
  "http://hl7.org/fhir/StructureDefinition/Patient": patient,
  "Patient": patient,
  "http://hl7.org/fhir/StructureDefinition/PaymentNotice": paymentNotice,
  "PaymentNotice": paymentNotice,
  "http://hl7.org/fhir/StructureDefinition/PaymentReconciliation":
      paymentReconciliation,
  "PaymentReconciliation": paymentReconciliation,
  "http://hl7.org/fhir/StructureDefinition/Person": person,
  "Person": person,
  "http://hl7.org/fhir/StructureDefinition/PlanDefinition": planDefinition,
  "PlanDefinition": planDefinition,
  "http://hl7.org/fhir/StructureDefinition/Practitioner": practitioner,
  "Practitioner": practitioner,
  "http://hl7.org/fhir/StructureDefinition/PractitionerRole": practitionerRole,
  "PractitionerRole": practitionerRole,
  "http://hl7.org/fhir/StructureDefinition/Procedure": procedure,
  "Procedure": procedure,
  "http://hl7.org/fhir/StructureDefinition/Provenance": provenance,
  "Provenance": provenance,
  "http://hl7.org/fhir/StructureDefinition/Questionnaire": questionnaire,
  "Questionnaire": questionnaire,
  "http://hl7.org/fhir/StructureDefinition/QuestionnaireResponse":
      questionnaireResponse,
  "QuestionnaireResponse": questionnaireResponse,
  "http://hl7.org/fhir/StructureDefinition/RegulatedAuthorization":
      regulatedAuthorization,
  "RegulatedAuthorization": regulatedAuthorization,
  "http://hl7.org/fhir/StructureDefinition/RelatedPerson": relatedPerson,
  "RelatedPerson": relatedPerson,
  "http://hl7.org/fhir/StructureDefinition/RequestGroup": requestGroup,
  "RequestGroup": requestGroup,
  "http://hl7.org/fhir/StructureDefinition/ResearchDefinition":
      researchDefinition,
  "ResearchDefinition": researchDefinition,
  "http://hl7.org/fhir/StructureDefinition/ResearchElementDefinition":
      researchElementDefinition,
  "ResearchElementDefinition": researchElementDefinition,
  "http://hl7.org/fhir/StructureDefinition/ResearchStudy": researchStudy,
  "ResearchStudy": researchStudy,
  "http://hl7.org/fhir/StructureDefinition/ResearchSubject": researchSubject,
  "ResearchSubject": researchSubject,
  "http://hl7.org/fhir/StructureDefinition/RiskAssessment": riskAssessment,
  "RiskAssessment": riskAssessment,
  "http://hl7.org/fhir/StructureDefinition/Schedule": schedule,
  "Schedule": schedule,
  "http://hl7.org/fhir/StructureDefinition/SearchParameter": searchParameter,
  "SearchParameter": searchParameter,
  "http://hl7.org/fhir/StructureDefinition/ServiceRequest": serviceRequest,
  "ServiceRequest": serviceRequest,
  "http://hl7.org/fhir/StructureDefinition/Slot": slot,
  "Slot": slot,
  "http://hl7.org/fhir/StructureDefinition/Specimen": specimen,
  "Specimen": specimen,
  "http://hl7.org/fhir/StructureDefinition/SpecimenDefinition":
      specimenDefinition,
  "SpecimenDefinition": specimenDefinition,
  "http://hl7.org/fhir/StructureDefinition/StructureDefinition":
      structureDefinition,
  "StructureDefinition": structureDefinition,
  "http://hl7.org/fhir/StructureDefinition/StructureMap": structureMap,
  "StructureMap": structureMap,
  "http://hl7.org/fhir/StructureDefinition/Subscription": subscription,
  "Subscription": subscription,
  "http://hl7.org/fhir/StructureDefinition/SubscriptionStatus":
      subscriptionStatus,
  "SubscriptionStatus": subscriptionStatus,
  "http://hl7.org/fhir/StructureDefinition/SubscriptionTopic":
      subscriptionTopic,
  "SubscriptionTopic": subscriptionTopic,
  "http://hl7.org/fhir/StructureDefinition/Substance": substance,
  "Substance": substance,
  "http://hl7.org/fhir/StructureDefinition/SubstanceDefinition":
      substanceDefinition,
  "SubstanceDefinition": substanceDefinition,
  "http://hl7.org/fhir/StructureDefinition/SupplyDelivery": supplyDelivery,
  "SupplyDelivery": supplyDelivery,
  "http://hl7.org/fhir/StructureDefinition/SupplyRequest": supplyRequest,
  "SupplyRequest": supplyRequest,
  "http://hl7.org/fhir/StructureDefinition/Task": task,
  "Task": task,
  "http://hl7.org/fhir/StructureDefinition/TerminologyCapabilities":
      terminologyCapabilities,
  "TerminologyCapabilities": terminologyCapabilities,
  "http://hl7.org/fhir/StructureDefinition/TestReport": testReport,
  "TestReport": testReport,
  "http://hl7.org/fhir/StructureDefinition/TestScript": testScript,
  "TestScript": testScript,
  "http://hl7.org/fhir/StructureDefinition/ValueSet": valueSet,
  "ValueSet": valueSet,
  "http://hl7.org/fhir/StructureDefinition/VerificationResult":
      verificationResult,
  "VerificationResult": verificationResult,
  "http://hl7.org/fhir/StructureDefinition/VisionPrescription":
      visionPrescription,
  "VisionPrescription": visionPrescription,
  "http://hl7.org/fhir/StructureDefinition/shareablemeasure": shareablemeasure,
  "http://hl7.org/fhir/StructureDefinition/servicerequest-genetics":
      servicerequestGenetics,
  "http://hl7.org/fhir/StructureDefinition/groupdefinition": groupdefinition,
  "http://hl7.org/fhir/StructureDefinition/actualgroup": actualgroup,
  "http://hl7.org/fhir/StructureDefinition/familymemberhistory-genetic":
      familymemberhistoryGenetic,
  "http://hl7.org/fhir/StructureDefinition/shareableactivitydefinition":
      shareableactivitydefinition,
  "http://hl7.org/fhir/StructureDefinition/cdshooksrequestgroup":
      cdshooksrequestgroup,
  "http://hl7.org/fhir/StructureDefinition/provenance-relevant-history":
      provenanceRelevantHistory,
  "http://hl7.org/fhir/StructureDefinition/cqf-questionnaire": cqfQuestionnaire,
  "http://hl7.org/fhir/StructureDefinition/shareablevalueset":
      shareablevalueset,
  "http://hl7.org/fhir/StructureDefinition/shareablecodesystem":
      shareablecodesystem,
  "http://hl7.org/fhir/StructureDefinition/cdshooksguidanceresponse":
      cdshooksguidanceresponse,
  "http://hl7.org/fhir/StructureDefinition/devicemetricobservation":
      devicemetricobservation,
  "http://hl7.org/fhir/StructureDefinition/observation-genetics":
      observationGenetics,
  "http://hl7.org/fhir/StructureDefinition/vitalsigns": vitalsigns,
  "http://hl7.org/fhir/StructureDefinition/bodyweight": bodyweight,
  "http://hl7.org/fhir/StructureDefinition/vitalspanel": vitalspanel,
  "http://hl7.org/fhir/StructureDefinition/bodyheight": bodyheight,
  "http://hl7.org/fhir/StructureDefinition/resprate": resprate,
  "http://hl7.org/fhir/StructureDefinition/heartrate": heartrate,
  "http://hl7.org/fhir/StructureDefinition/bodytemp": bodytemp,
  "http://hl7.org/fhir/StructureDefinition/headcircum": headcircum,
  "http://hl7.org/fhir/StructureDefinition/oxygensat": oxygensat,
  "http://hl7.org/fhir/StructureDefinition/bmi": bmi,
  "http://hl7.org/fhir/StructureDefinition/bp": bp,
  "http://hl7.org/fhir/StructureDefinition/shareablelibrary": shareablelibrary,
  "http://hl7.org/fhir/StructureDefinition/cqllibrary": cqllibrary,
  "http://hl7.org/fhir/StructureDefinition/diagnosticreport-genetics":
      diagnosticreportGenetics,
  "http://hl7.org/fhir/StructureDefinition/hlaresult": hlaresult,
  "http://hl7.org/fhir/StructureDefinition/lipidprofile": lipidprofile,
  "http://hl7.org/fhir/StructureDefinition/cholesterol": cholesterol,
  "http://hl7.org/fhir/StructureDefinition/triglyceride": triglyceride,
  "http://hl7.org/fhir/StructureDefinition/hdlcholesterol": hdlcholesterol,
  "http://hl7.org/fhir/StructureDefinition/ldlcholesterol": ldlcholesterol,
  "http://hl7.org/fhir/StructureDefinition/clinicaldocument": clinicaldocument,
  "http://hl7.org/fhir/StructureDefinition/catalog": catalog,
  "http://hl7.org/fhir/StructureDefinition/cdshooksserviceplandefinition":
      cdshooksserviceplandefinition,
  "http://hl7.org/fhir/StructureDefinition/computableplandefinition":
      computableplandefinition,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-de":
      elementdefinitionDe,
  "http://hl7.org/fhir/StructureDefinition/de-date.id": deDateId,
  "http://hl7.org/fhir/StructureDefinition/de-date.value": deDateValue,
  "http://hl7.org/fhir/StructureDefinition/de-dateTime.id": deDateTimeId,
  "http://hl7.org/fhir/StructureDefinition/de-dateTime.value": deDateTimeValue,
  "http://hl7.org/fhir/StructureDefinition/de-string.id": deStringId,
  "http://hl7.org/fhir/StructureDefinition/de-string.value": deStringValue,
  "http://hl7.org/fhir/StructureDefinition/de-integer.id": deIntegerId,
  "http://hl7.org/fhir/StructureDefinition/de-integer.value": deIntegerValue,
  "http://hl7.org/fhir/StructureDefinition/de-uri.id": deUriId,
  "http://hl7.org/fhir/StructureDefinition/de-uri.value": deUriValue,
  "http://hl7.org/fhir/StructureDefinition/de-instant.id": deInstantId,
  "http://hl7.org/fhir/StructureDefinition/de-instant.value": deInstantValue,
  "http://hl7.org/fhir/StructureDefinition/de-boolean.id": deBooleanId,
  "http://hl7.org/fhir/StructureDefinition/de-boolean.value": deBooleanValue,
  "http://hl7.org/fhir/StructureDefinition/de-base64Binary.id":
      deBase64BinaryId,
  "http://hl7.org/fhir/StructureDefinition/de-base64Binary.value":
      deBase64BinaryValue,
  "http://hl7.org/fhir/StructureDefinition/de-time.id": deTimeId,
  "http://hl7.org/fhir/StructureDefinition/de-time.value": deTimeValue,
  "http://hl7.org/fhir/StructureDefinition/de-decimal.id": deDecimalId,
  "http://hl7.org/fhir/StructureDefinition/de-decimal.value": deDecimalValue,
  "http://hl7.org/fhir/StructureDefinition/de-xhtml.id": deXhtmlId,
  "http://hl7.org/fhir/StructureDefinition/de-xhtml.value": deXhtmlValue,
  "http://hl7.org/fhir/StructureDefinition/de-Meta.versionId": deMetaVersionId,
  "http://hl7.org/fhir/StructureDefinition/de-Meta.lastUpdated":
      deMetaLastUpdated,
  "http://hl7.org/fhir/StructureDefinition/de-Meta.source": deMetaSource,
  "http://hl7.org/fhir/StructureDefinition/de-Meta.profile": deMetaProfile,
  "http://hl7.org/fhir/StructureDefinition/de-Meta.security": deMetaSecurity,
  "http://hl7.org/fhir/StructureDefinition/de-Meta.tag": deMetaTag,
  "http://hl7.org/fhir/StructureDefinition/de-Address.use": deAddressUse,
  "http://hl7.org/fhir/StructureDefinition/de-Address.type": deAddressType,
  "http://hl7.org/fhir/StructureDefinition/de-Address.text": deAddressText,
  "http://hl7.org/fhir/StructureDefinition/de-Address.line": deAddressLine,
  "http://hl7.org/fhir/StructureDefinition/de-Address.city": deAddressCity,
  "http://hl7.org/fhir/StructureDefinition/de-Address.district":
      deAddressDistrict,
  "http://hl7.org/fhir/StructureDefinition/de-Address.state": deAddressState,
  "http://hl7.org/fhir/StructureDefinition/de-Address.postalCode":
      deAddressPostalCode,
  "http://hl7.org/fhir/StructureDefinition/de-Address.country":
      deAddressCountry,
  "http://hl7.org/fhir/StructureDefinition/de-Address.period": deAddressPeriod,
  "http://hl7.org/fhir/StructureDefinition/de-Contributor.type":
      deContributorType,
  "http://hl7.org/fhir/StructureDefinition/de-Contributor.name":
      deContributorName,
  "http://hl7.org/fhir/StructureDefinition/de-Contributor.contact":
      deContributorContact,
  "http://hl7.org/fhir/StructureDefinition/de-Attachment.contentType":
      deAttachmentContentType,
  "http://hl7.org/fhir/StructureDefinition/de-Attachment.language":
      deAttachmentLanguage,
  "http://hl7.org/fhir/StructureDefinition/de-Attachment.data":
      deAttachmentData,
  "http://hl7.org/fhir/StructureDefinition/de-Attachment.url": deAttachmentUrl,
  "http://hl7.org/fhir/StructureDefinition/de-Attachment.size":
      deAttachmentSize,
  "http://hl7.org/fhir/StructureDefinition/de-Attachment.hash":
      deAttachmentHash,
  "http://hl7.org/fhir/StructureDefinition/de-Attachment.title":
      deAttachmentTitle,
  "http://hl7.org/fhir/StructureDefinition/de-Attachment.creation":
      deAttachmentCreation,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.type":
      deDataRequirementType,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.profile":
      deDataRequirementProfile,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.subjectX":
      deDataRequirementSubjectX,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.mustSupport":
      deDataRequirementMustSupport,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.codeFilter.path":
      deDataRequirementCodeFilterPath,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.codeFilter.searchParam":
      deDataRequirementCodeFilterSearchParam,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.codeFilter.valueSet":
      deDataRequirementCodeFilterValueSet,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.codeFilter.code":
      deDataRequirementCodeFilterCode,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.dateFilter.path":
      deDataRequirementDateFilterPath,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.dateFilter.searchParam":
      deDataRequirementDateFilterSearchParam,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.dateFilter.valueX":
      deDataRequirementDateFilterValueX,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.limit":
      deDataRequirementLimit,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.sort.path":
      deDataRequirementSortPath,
  "http://hl7.org/fhir/StructureDefinition/de-DataRequirement.sort.direction":
      deDataRequirementSortDirection,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.sequence":
      deDosageSequence,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.text": deDosageText,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.additionalInstruction":
      deDosageAdditionalInstruction,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.patientInstruction":
      deDosagePatientInstruction,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.timing": deDosageTiming,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.asNeededX":
      deDosageAsNeededX,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.site": deDosageSite,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.route": deDosageRoute,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.method": deDosageMethod,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.doseAndRate.type":
      deDosageDoseAndRateType,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.doseAndRate.doseX":
      deDosageDoseAndRateDoseX,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.doseAndRate.rateX":
      deDosageDoseAndRateRateX,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.maxDosePerPeriod":
      deDosageMaxDosePerPeriod,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.maxDosePerAdministration":
      deDosageMaxDosePerAdministration,
  "http://hl7.org/fhir/StructureDefinition/de-Dosage.maxDosePerLifetime":
      deDosageMaxDosePerLifetime,
  "http://hl7.org/fhir/StructureDefinition/de-Money.value": deMoneyValue,
  "http://hl7.org/fhir/StructureDefinition/de-Money.currency": deMoneyCurrency,
  "http://hl7.org/fhir/StructureDefinition/de-HumanName.use": deHumanNameUse,
  "http://hl7.org/fhir/StructureDefinition/de-HumanName.text": deHumanNameText,
  "http://hl7.org/fhir/StructureDefinition/de-HumanName.family":
      deHumanNameFamily,
  "http://hl7.org/fhir/StructureDefinition/de-HumanName.given":
      deHumanNameGiven,
  "http://hl7.org/fhir/StructureDefinition/de-HumanName.prefix":
      deHumanNamePrefix,
  "http://hl7.org/fhir/StructureDefinition/de-HumanName.suffix":
      deHumanNameSuffix,
  "http://hl7.org/fhir/StructureDefinition/de-HumanName.period":
      deHumanNamePeriod,
  "http://hl7.org/fhir/StructureDefinition/de-ContactPoint.system":
      deContactPointSystem,
  "http://hl7.org/fhir/StructureDefinition/de-ContactPoint.value":
      deContactPointValue,
  "http://hl7.org/fhir/StructureDefinition/de-ContactPoint.use":
      deContactPointUse,
  "http://hl7.org/fhir/StructureDefinition/de-ContactPoint.rank":
      deContactPointRank,
  "http://hl7.org/fhir/StructureDefinition/de-ContactPoint.period":
      deContactPointPeriod,
  "http://hl7.org/fhir/StructureDefinition/de-MarketingStatus.country":
      deMarketingStatusCountry,
  "http://hl7.org/fhir/StructureDefinition/de-MarketingStatus.jurisdiction":
      deMarketingStatusJurisdiction,
  "http://hl7.org/fhir/StructureDefinition/de-MarketingStatus.status":
      deMarketingStatusStatus,
  "http://hl7.org/fhir/StructureDefinition/de-MarketingStatus.dateRange":
      deMarketingStatusDateRange,
  "http://hl7.org/fhir/StructureDefinition/de-MarketingStatus.restoreDate":
      deMarketingStatusRestoreDate,
  "http://hl7.org/fhir/StructureDefinition/de-Identifier.use": deIdentifierUse,
  "http://hl7.org/fhir/StructureDefinition/de-Identifier.type":
      deIdentifierType,
  "http://hl7.org/fhir/StructureDefinition/de-Identifier.system":
      deIdentifierSystem,
  "http://hl7.org/fhir/StructureDefinition/de-Identifier.value":
      deIdentifierValue,
  "http://hl7.org/fhir/StructureDefinition/de-Identifier.period":
      deIdentifierPeriod,
  "http://hl7.org/fhir/StructureDefinition/de-Identifier.assigner":
      deIdentifierAssigner,
  "http://hl7.org/fhir/StructureDefinition/de-RatioRange.lowNumerator":
      deRatioRangeLowNumerator,
  "http://hl7.org/fhir/StructureDefinition/de-RatioRange.highNumerator":
      deRatioRangeHighNumerator,
  "http://hl7.org/fhir/StructureDefinition/de-RatioRange.denominator":
      deRatioRangeDenominator,
  "http://hl7.org/fhir/StructureDefinition/de-Coding.system": deCodingSystem,
  "http://hl7.org/fhir/StructureDefinition/de-Coding.version": deCodingVersion,
  "http://hl7.org/fhir/StructureDefinition/de-Coding.code": deCodingCode,
  "http://hl7.org/fhir/StructureDefinition/de-Coding.display": deCodingDisplay,
  "http://hl7.org/fhir/StructureDefinition/de-Coding.userSelected":
      deCodingUserSelected,
  "http://hl7.org/fhir/StructureDefinition/de-SampledData.origin":
      deSampledDataOrigin,
  "http://hl7.org/fhir/StructureDefinition/de-SampledData.period":
      deSampledDataPeriod,
  "http://hl7.org/fhir/StructureDefinition/de-SampledData.factor":
      deSampledDataFactor,
  "http://hl7.org/fhir/StructureDefinition/de-SampledData.lowerLimit":
      deSampledDataLowerLimit,
  "http://hl7.org/fhir/StructureDefinition/de-SampledData.upperLimit":
      deSampledDataUpperLimit,
  "http://hl7.org/fhir/StructureDefinition/de-SampledData.dimensions":
      deSampledDataDimensions,
  "http://hl7.org/fhir/StructureDefinition/de-SampledData.data":
      deSampledDataData,
  "http://hl7.org/fhir/StructureDefinition/de-Population.ageX":
      dePopulationAgeX,
  "http://hl7.org/fhir/StructureDefinition/de-Population.gender":
      dePopulationGender,
  "http://hl7.org/fhir/StructureDefinition/de-Population.race":
      dePopulationRace,
  "http://hl7.org/fhir/StructureDefinition/de-Population.physiologicalCondition":
      dePopulationPhysiologicalCondition,
  "http://hl7.org/fhir/StructureDefinition/de-Ratio.numerator":
      deRatioNumerator,
  "http://hl7.org/fhir/StructureDefinition/de-Ratio.denominator":
      deRatioDenominator,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.path":
      deElementDefinitionPath,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.representation":
      deElementDefinitionRepresentation,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.sliceName":
      deElementDefinitionSliceName,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.sliceIsConstraining":
      deElementDefinitionSliceIsConstraining,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.label":
      deElementDefinitionLabel,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.code":
      deElementDefinitionCode,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.slicing.discriminator.type":
      deElementDefinitionSlicingDiscriminatorType,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.slicing.discriminator.path":
      deElementDefinitionSlicingDiscriminatorPath,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.slicing.description":
      deElementDefinitionSlicingDescription,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.slicing.ordered":
      deElementDefinitionSlicingOrdered,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.slicing.rules":
      deElementDefinitionSlicingRules,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.short":
      deElementDefinitionShort,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.definition":
      deElementDefinitionDefinition,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.comment":
      deElementDefinitionComment,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.requirements":
      deElementDefinitionRequirements,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.alias":
      deElementDefinitionAlias,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.min":
      deElementDefinitionMin,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.max":
      deElementDefinitionMax,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.base.path":
      deElementDefinitionBasePath,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.base.min":
      deElementDefinitionBaseMin,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.base.max":
      deElementDefinitionBaseMax,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.contentReference":
      deElementDefinitionContentReference,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.type.code":
      deElementDefinitionTypeCode,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.type.profile":
      deElementDefinitionTypeProfile,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.type.targetProfile":
      deElementDefinitionTypeTargetProfile,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.type.aggregation":
      deElementDefinitionTypeAggregation,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.type.versioning":
      deElementDefinitionTypeVersioning,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.defaultValueX":
      deElementDefinitionDefaultValueX,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.meaningWhenMissing":
      deElementDefinitionMeaningWhenMissing,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.orderMeaning":
      deElementDefinitionOrderMeaning,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.fixedX":
      deElementDefinitionFixedX,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.patternX":
      deElementDefinitionPatternX,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.example.label":
      deElementDefinitionExampleLabel,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.example.valueX":
      deElementDefinitionExampleValueX,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.minValueX":
      deElementDefinitionMinValueX,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.maxValueX":
      deElementDefinitionMaxValueX,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.maxLength":
      deElementDefinitionMaxLength,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.condition":
      deElementDefinitionCondition,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.constraint.key":
      deElementDefinitionConstraintKey,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.constraint.requirements":
      deElementDefinitionConstraintRequirements,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.constraint.severity":
      deElementDefinitionConstraintSeverity,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.constraint.human":
      deElementDefinitionConstraintHuman,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.constraint.expression":
      deElementDefinitionConstraintExpression,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.constraint.xpath":
      deElementDefinitionConstraintXpath,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.constraint.source":
      deElementDefinitionConstraintSource,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.mustSupport":
      deElementDefinitionMustSupport,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.isModifier":
      deElementDefinitionIsModifier,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.isModifierReason":
      deElementDefinitionIsModifierReason,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.isSummary":
      deElementDefinitionIsSummary,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.binding.strength":
      deElementDefinitionBindingStrength,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.binding.description":
      deElementDefinitionBindingDescription,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.binding.valueSet":
      deElementDefinitionBindingValueSet,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.mapping.identity":
      deElementDefinitionMappingIdentity,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.mapping.language":
      deElementDefinitionMappingLanguage,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.mapping.map":
      deElementDefinitionMappingMap,
  "http://hl7.org/fhir/StructureDefinition/de-ElementDefinition.mapping.comment":
      deElementDefinitionMappingComment,
  "http://hl7.org/fhir/StructureDefinition/de-Reference.reference":
      deReferenceReference,
  "http://hl7.org/fhir/StructureDefinition/de-Reference.type": deReferenceType,
  "http://hl7.org/fhir/StructureDefinition/de-Reference.identifier":
      deReferenceIdentifier,
  "http://hl7.org/fhir/StructureDefinition/de-Reference.display":
      deReferenceDisplay,
  "http://hl7.org/fhir/StructureDefinition/de-TriggerDefinition.type":
      deTriggerDefinitionType,
  "http://hl7.org/fhir/StructureDefinition/de-TriggerDefinition.name":
      deTriggerDefinitionName,
  "http://hl7.org/fhir/StructureDefinition/de-TriggerDefinition.timingX":
      deTriggerDefinitionTimingX,
  "http://hl7.org/fhir/StructureDefinition/de-TriggerDefinition.data":
      deTriggerDefinitionData,
  "http://hl7.org/fhir/StructureDefinition/de-TriggerDefinition.condition":
      deTriggerDefinitionCondition,
  "http://hl7.org/fhir/StructureDefinition/de-Quantity.value": deQuantityValue,
  "http://hl7.org/fhir/StructureDefinition/de-Quantity.comparator":
      deQuantityComparator,
  "http://hl7.org/fhir/StructureDefinition/de-Quantity.unit": deQuantityUnit,
  "http://hl7.org/fhir/StructureDefinition/de-Quantity.system":
      deQuantitySystem,
  "http://hl7.org/fhir/StructureDefinition/de-Quantity.code": deQuantityCode,
  "http://hl7.org/fhir/StructureDefinition/de-Period.start": dePeriodStart,
  "http://hl7.org/fhir/StructureDefinition/de-Period.end": dePeriodEnd,
  "http://hl7.org/fhir/StructureDefinition/de-Range.low": deRangeLow,
  "http://hl7.org/fhir/StructureDefinition/de-Range.high": deRangeHigh,
  "http://hl7.org/fhir/StructureDefinition/de-RelatedArtifact.type":
      deRelatedArtifactType,
  "http://hl7.org/fhir/StructureDefinition/de-RelatedArtifact.label":
      deRelatedArtifactLabel,
  "http://hl7.org/fhir/StructureDefinition/de-RelatedArtifact.display":
      deRelatedArtifactDisplay,
  "http://hl7.org/fhir/StructureDefinition/de-RelatedArtifact.citation":
      deRelatedArtifactCitation,
  "http://hl7.org/fhir/StructureDefinition/de-RelatedArtifact.url":
      deRelatedArtifactUrl,
  "http://hl7.org/fhir/StructureDefinition/de-RelatedArtifact.document":
      deRelatedArtifactDocument,
  "http://hl7.org/fhir/StructureDefinition/de-RelatedArtifact.resource":
      deRelatedArtifactResource,
  "http://hl7.org/fhir/StructureDefinition/de-Annotation.authorX":
      deAnnotationAuthorX,
  "http://hl7.org/fhir/StructureDefinition/de-Annotation.time":
      deAnnotationTime,
  "http://hl7.org/fhir/StructureDefinition/de-Annotation.text":
      deAnnotationText,
  "http://hl7.org/fhir/StructureDefinition/de-ProductShelfLife.identifier":
      deProductShelfLifeIdentifier,
  "http://hl7.org/fhir/StructureDefinition/de-ProductShelfLife.type":
      deProductShelfLifeType,
  "http://hl7.org/fhir/StructureDefinition/de-ProductShelfLife.period":
      deProductShelfLifePeriod,
  "http://hl7.org/fhir/StructureDefinition/de-ProductShelfLife.specialPrecautionsForStorage":
      deProductShelfLifeSpecialPrecautionsForStorage,
  "http://hl7.org/fhir/StructureDefinition/de-ContactDetail.name":
      deContactDetailName,
  "http://hl7.org/fhir/StructureDefinition/de-ContactDetail.telecom":
      deContactDetailTelecom,
  "http://hl7.org/fhir/StructureDefinition/de-UsageContext.code":
      deUsageContextCode,
  "http://hl7.org/fhir/StructureDefinition/de-UsageContext.valueX":
      deUsageContextValueX,
  "http://hl7.org/fhir/StructureDefinition/de-Expression.description":
      deExpressionDescription,
  "http://hl7.org/fhir/StructureDefinition/de-Expression.name":
      deExpressionName,
  "http://hl7.org/fhir/StructureDefinition/de-Expression.language":
      deExpressionLanguage,
  "http://hl7.org/fhir/StructureDefinition/de-Expression.expression":
      deExpressionExpression,
  "http://hl7.org/fhir/StructureDefinition/de-Expression.reference":
      deExpressionReference,
  "http://hl7.org/fhir/StructureDefinition/de-CodeableReference.concept":
      deCodeableReferenceConcept,
  "http://hl7.org/fhir/StructureDefinition/de-CodeableReference.reference":
      deCodeableReferenceReference,
  "http://hl7.org/fhir/StructureDefinition/de-Signature.type": deSignatureType,
  "http://hl7.org/fhir/StructureDefinition/de-Signature.when": deSignatureWhen,
  "http://hl7.org/fhir/StructureDefinition/de-Signature.who": deSignatureWho,
  "http://hl7.org/fhir/StructureDefinition/de-Signature.onBehalfOf":
      deSignatureOnBehalfOf,
  "http://hl7.org/fhir/StructureDefinition/de-Signature.targetFormat":
      deSignatureTargetFormat,
  "http://hl7.org/fhir/StructureDefinition/de-Signature.sigFormat":
      deSignatureSigFormat,
  "http://hl7.org/fhir/StructureDefinition/de-Signature.data": deSignatureData,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.event": deTimingEvent,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.boundsX":
      deTimingRepeatBoundsX,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.count":
      deTimingRepeatCount,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.countMax":
      deTimingRepeatCountMax,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.duration":
      deTimingRepeatDuration,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.durationMax":
      deTimingRepeatDurationMax,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.durationUnit":
      deTimingRepeatDurationUnit,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.frequency":
      deTimingRepeatFrequency,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.frequencyMax":
      deTimingRepeatFrequencyMax,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.period":
      deTimingRepeatPeriod,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.periodMax":
      deTimingRepeatPeriodMax,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.periodUnit":
      deTimingRepeatPeriodUnit,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.dayOfWeek":
      deTimingRepeatDayOfWeek,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.timeOfDay":
      deTimingRepeatTimeOfDay,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.when":
      deTimingRepeatWhen,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.repeat.offset":
      deTimingRepeatOffset,
  "http://hl7.org/fhir/StructureDefinition/de-Timing.code": deTimingCode,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.height":
      deProdCharacteristicHeight,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.width":
      deProdCharacteristicWidth,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.depth":
      deProdCharacteristicDepth,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.weight":
      deProdCharacteristicWeight,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.nominalVolume":
      deProdCharacteristicNominalVolume,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.externalDiameter":
      deProdCharacteristicExternalDiameter,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.shape":
      deProdCharacteristicShape,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.color":
      deProdCharacteristicColor,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.imprint":
      deProdCharacteristicImprint,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.image":
      deProdCharacteristicImage,
  "http://hl7.org/fhir/StructureDefinition/de-ProdCharacteristic.scoring":
      deProdCharacteristicScoring,
  "http://hl7.org/fhir/StructureDefinition/de-CodeableConcept.coding":
      deCodeableConceptCoding,
  "http://hl7.org/fhir/StructureDefinition/de-CodeableConcept.text":
      deCodeableConceptText,
  "http://hl7.org/fhir/StructureDefinition/de-ParameterDefinition.name":
      deParameterDefinitionName,
  "http://hl7.org/fhir/StructureDefinition/de-ParameterDefinition.use":
      deParameterDefinitionUse,
  "http://hl7.org/fhir/StructureDefinition/de-ParameterDefinition.min":
      deParameterDefinitionMin,
  "http://hl7.org/fhir/StructureDefinition/de-ParameterDefinition.max":
      deParameterDefinitionMax,
  "http://hl7.org/fhir/StructureDefinition/de-ParameterDefinition.documentation":
      deParameterDefinitionDocumentation,
  "http://hl7.org/fhir/StructureDefinition/de-ParameterDefinition.type":
      deParameterDefinitionType,
  "http://hl7.org/fhir/StructureDefinition/de-ParameterDefinition.profile":
      deParameterDefinitionProfile,
  "http://hl7.org/fhir/StructureDefinition/de-Extension.url": deExtensionUrl,
  "http://hl7.org/fhir/StructureDefinition/de-Extension.valueX":
      deExtensionValueX,
  "http://hl7.org/fhir/StructureDefinition/de-BackboneElement.modifierExtension":
      deBackboneElementModifierExtension,
  "http://hl7.org/fhir/StructureDefinition/de-Narrative.status":
      deNarrativeStatus,
  "http://hl7.org/fhir/StructureDefinition/de-Narrative.div": deNarrativeDiv,
  "http://hl7.org/fhir/StructureDefinition/de-Element.id": deElementId,
  "http://hl7.org/fhir/StructureDefinition/de-Element.extension":
      deElementExtension,
  "http://hl7.org/fhir/StructureDefinition/resource-approvalDate":
      resourceApprovalDate,
  "http://hl7.org/fhir/StructureDefinition/resource-lastReviewDate":
      resourceLastReviewDate,
  "http://hl7.org/fhir/StructureDefinition/resource-effectivePeriod":
      resourceEffectivePeriod,
  "http://hl7.org/fhir/StructureDefinition/resource-pertainsToGoal":
      resourcePertainsToGoal,
  "http://hl7.org/fhir/StructureDefinition/parameters-fullUrl":
      parametersFullUrl,
  "http://hl7.org/fhir/StructureDefinition/flag-detail": flagDetail,
  "http://hl7.org/fhir/StructureDefinition/flag-priority": flagPriority,
  "http://hl7.org/fhir/StructureDefinition/openEHR-test": openEHRTest,
  "http://hl7.org/fhir/StructureDefinition/openEHR-location": openEHRLocation,
  "http://hl7.org/fhir/StructureDefinition/openEHR-exposureDate":
      openEHRExposureDate,
  "http://hl7.org/fhir/StructureDefinition/openEHR-exposureDuration":
      openEHRExposureDuration,
  "http://hl7.org/fhir/StructureDefinition/openEHR-exposureDescription":
      openEHRExposureDescription,
  "http://hl7.org/fhir/StructureDefinition/openEHR-administration":
      openEHRAdministration,
  "http://hl7.org/fhir/StructureDefinition/openEHR-management":
      openEHRManagement,
  "http://hl7.org/fhir/StructureDefinition/openEHR-careplan": openEHRCareplan,
  "http://hl7.org/fhir/StructureDefinition/allergyintolerance-resolutionAge":
      allergyintoleranceResolutionAge,
  "http://hl7.org/fhir/StructureDefinition/allergyintolerance-reasonRefuted":
      allergyintoleranceReasonRefuted,
  "http://hl7.org/fhir/StructureDefinition/allergyintolerance-duration":
      allergyintoleranceDuration,
  "http://hl7.org/fhir/StructureDefinition/allergyintolerance-substanceExposureRisk":
      allergyintoleranceSubstanceExposureRisk,
  "http://hl7.org/fhir/StructureDefinition/allergyintolerance-certainty":
      allergyintoleranceCertainty,
  "http://hl7.org/fhir/StructureDefinition/allergyintolerance-assertedDate":
      allergyintoleranceAssertedDate,
  "http://hl7.org/fhir/StructureDefinition/careplan-activity-title":
      careplanActivityTitle,
  "http://hl7.org/fhir/StructureDefinition/condition-dueTo": conditionDueTo,
  "http://hl7.org/fhir/StructureDefinition/condition-occurredFollowing":
      conditionOccurredFollowing,
  "http://hl7.org/fhir/StructureDefinition/condition-outcome": conditionOutcome,
  "http://hl7.org/fhir/StructureDefinition/condition-ruledOut":
      conditionRuledOut,
  "http://hl7.org/fhir/StructureDefinition/condition-related": conditionRelated,
  "http://hl7.org/fhir/StructureDefinition/condition-assertedDate":
      conditionAssertedDate,
  "http://hl7.org/fhir/StructureDefinition/communication-media":
      communicationMedia,
  "http://hl7.org/fhir/StructureDefinition/communicationrequest-initiatingLocation":
      communicationrequestInitiatingLocation,
  "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation":
      capabilitystatementExpectation,
  "http://hl7.org/fhir/StructureDefinition/capabilitystatement-prohibited":
      capabilitystatementProhibited,
  "http://hl7.org/fhir/StructureDefinition/capabilitystatement-supported-system":
      capabilitystatementSupportedSystem,
  "http://hl7.org/fhir/StructureDefinition/capabilitystatement-search-parameter-combination":
      capabilitystatementSearchParameterCombination,
  "http://hl7.org/fhir/StructureDefinition/capabilitystatement-websocket":
      capabilitystatementWebsocket,
  "http://hl7.org/fhir/StructureDefinition/device-implantStatus":
      deviceImplantStatus,
  "http://hl7.org/fhir/StructureDefinition/devicerequest-patientInstruction":
      devicerequestPatientInstruction,
  "http://hl7.org/fhir/StructureDefinition/diagnosticReport-locationPerformed":
      diagnosticReportLocationPerformed,
  "http://hl7.org/fhir/StructureDefinition/diagnosticReport-summaryOf":
      diagnosticReportSummaryOf,
  "http://hl7.org/fhir/StructureDefinition/diagnosticReport-replaces":
      diagnosticReportReplaces,
  "http://hl7.org/fhir/StructureDefinition/diagnosticReport-extends":
      diagnosticReportExtends,
  "http://hl7.org/fhir/StructureDefinition/diagnosticReport-addendumOf":
      diagnosticReportAddendumOf,
  "http://hl7.org/fhir/StructureDefinition/diagnosticReport-risk":
      diagnosticReportRisk,
  "http://hl7.org/fhir/StructureDefinition/DiagnosticReport-geneticsAssessedCondition":
      diagnosticReportGeneticsAssessedCondition,
  "http://hl7.org/fhir/StructureDefinition/DiagnosticReport-geneticsFamilyMemberHistory":
      diagnosticReportGeneticsFamilyMemberHistory,
  "http://hl7.org/fhir/StructureDefinition/DiagnosticReport-geneticsAnalysis":
      diagnosticReportGeneticsAnalysis,
  "http://hl7.org/fhir/StructureDefinition/DiagnosticReport-geneticsReferences":
      diagnosticReportGeneticsReferences,
  "http://hl7.org/fhir/StructureDefinition/hla-genotyping-results-allele-database":
      hlaGenotypingResultsAlleleDatabase,
  "http://hl7.org/fhir/StructureDefinition/hla-genotyping-results-glstring":
      hlaGenotypingResultsGlstring,
  "http://hl7.org/fhir/StructureDefinition/hla-genotyping-results-haploid":
      hlaGenotypingResultsHaploid,
  "http://hl7.org/fhir/StructureDefinition/hla-genotyping-results-method":
      hlaGenotypingResultsMethod,
  "http://hl7.org/fhir/StructureDefinition/composition-clinicaldocument-otherConfidentiality":
      compositionClinicaldocumentOtherConfidentiality,
  "http://hl7.org/fhir/StructureDefinition/composition-clinicaldocument-versionNumber":
      compositionClinicaldocumentVersionNumber,
  "http://hl7.org/fhir/StructureDefinition/cqm-ValidityPeriod":
      cqmValidityPeriod,
  "http://hl7.org/fhir/StructureDefinition/composition-section-subject":
      compositionSectionSubject,
  "http://hl7.org/fhir/StructureDefinition/encounter-reasonCancelled":
      encounterReasonCancelled,
  "http://hl7.org/fhir/StructureDefinition/encounter-associatedEncounter":
      encounterAssociatedEncounter,
  "http://hl7.org/fhir/StructureDefinition/encounter-modeOfArrival":
      encounterModeOfArrival,
  "http://hl7.org/fhir/StructureDefinition/family-member-history-genetics-parent":
      familyMemberHistoryGeneticsParent,
  "http://hl7.org/fhir/StructureDefinition/family-member-history-genetics-sibling":
      familyMemberHistoryGeneticsSibling,
  "http://hl7.org/fhir/StructureDefinition/family-member-history-genetics-observation":
      familyMemberHistoryGeneticsObservation,
  "http://hl7.org/fhir/StructureDefinition/familymemberhistory-abatement":
      familymemberhistoryAbatement,
  "http://hl7.org/fhir/StructureDefinition/familymemberhistory-severity":
      familymemberhistorySeverity,
  "http://hl7.org/fhir/StructureDefinition/familymemberhistory-patient-record":
      familymemberhistoryPatientRecord,
  "http://hl7.org/fhir/StructureDefinition/familymemberhistory-type":
      familymemberhistoryType,
  "http://hl7.org/fhir/StructureDefinition/goal-reasonRejected":
      goalReasonRejected,
  "http://hl7.org/fhir/StructureDefinition/goal-relationship": goalRelationship,
  "http://hl7.org/fhir/StructureDefinition/goal-acceptance": goalAcceptance,
  "http://hl7.org/fhir/StructureDefinition/list-changeBase": listChangeBase,
  "http://hl7.org/fhir/StructureDefinition/location-boundary-geojson":
      locationBoundaryGeojson,
  "http://hl7.org/fhir/StructureDefinition/messageheader-response-request":
      messageheaderResponseRequest,
  "http://hl7.org/fhir/StructureDefinition/nutritionorder-adaptiveFeedingDevice":
      nutritionorderAdaptiveFeedingDevice,
  "http://hl7.org/fhir/StructureDefinition/observation-bodyPosition":
      observationBodyPosition,
  "http://hl7.org/fhir/StructureDefinition/observation-delta": observationDelta,
  "http://hl7.org/fhir/StructureDefinition/observation-focusCode":
      observationFocusCode,
  "http://hl7.org/fhir/StructureDefinition/observation-timeOffset":
      observationTimeOffset,
  "http://hl7.org/fhir/StructureDefinition/observation-sequelTo":
      observationSequelTo,
  "http://hl7.org/fhir/StructureDefinition/observation-replaces":
      observationReplaces,
  "http://hl7.org/fhir/StructureDefinition/observation-gatewayDevice":
      observationGatewayDevice,
  "http://hl7.org/fhir/StructureDefinition/observation-specimenCode":
      observationSpecimenCode,
  "http://hl7.org/fhir/StructureDefinition/observation-deviceCode":
      observationDeviceCode,
  "http://hl7.org/fhir/StructureDefinition/observation-precondition":
      observationPrecondition,
  "http://hl7.org/fhir/StructureDefinition/observation-reagent":
      observationReagent,
  "http://hl7.org/fhir/StructureDefinition/observation-secondaryFinding":
      observationSecondaryFinding,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsGene":
      observationGeneticsGene,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsDNARegionName":
      observationGeneticsDNARegionName,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsCopyNumberEvent":
      observationGeneticsCopyNumberEvent,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsGenomicSourceClass":
      observationGeneticsGenomicSourceClass,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsInterpretation":
      observationGeneticsInterpretation,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsVariant":
      observationGeneticsVariant,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsAminoAcidChange":
      observationGeneticsAminoAcidChange,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsAllele":
      observationGeneticsAllele,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsAncestry":
      observationGeneticsAncestry,
  "http://hl7.org/fhir/StructureDefinition/observation-geneticsPhaseSet":
      observationGeneticsPhaseSet,
  "http://hl7.org/fhir/StructureDefinition/operationoutcome-issue-source":
      operationoutcomeIssueSource,
  "http://hl7.org/fhir/StructureDefinition/operationoutcome-authority":
      operationoutcomeAuthority,
  "http://hl7.org/fhir/StructureDefinition/operationoutcome-detectedIssue":
      operationoutcomeDetectedIssue,
  "http://hl7.org/fhir/StructureDefinition/organization-period":
      organizationPeriod,
  "http://hl7.org/fhir/StructureDefinition/organization-preferredContact":
      organizationPreferredContact,
  "http://hl7.org/fhir/StructureDefinition/patient-mothersMaidenName":
      patientMothersMaidenName,
  "http://hl7.org/fhir/StructureDefinition/patient-birthPlace":
      patientBirthPlace,
  "http://hl7.org/fhir/StructureDefinition/patient-birthTime": patientBirthTime,
  "http://hl7.org/fhir/StructureDefinition/patient-nationality":
      patientNationality,
  "http://hl7.org/fhir/StructureDefinition/patient-citizenship":
      patientCitizenship,
  "http://hl7.org/fhir/StructureDefinition/patient-cadavericDonor":
      patientCadavericDonor,
  "http://hl7.org/fhir/StructureDefinition/patient-congregation":
      patientCongregation,
  "http://hl7.org/fhir/StructureDefinition/patient-adoptionInfo":
      patientAdoptionInfo,
  "http://hl7.org/fhir/StructureDefinition/patient-disability":
      patientDisability,
  "http://hl7.org/fhir/StructureDefinition/patient-importance":
      patientImportance,
  "http://hl7.org/fhir/StructureDefinition/patient-interpreterRequired":
      patientInterpreterRequired,
  "http://hl7.org/fhir/StructureDefinition/patient-religion": patientReligion,
  "http://hl7.org/fhir/StructureDefinition/patient-relatedPerson":
      patientRelatedPerson,
  "http://hl7.org/fhir/StructureDefinition/patient-genderIdentity":
      patientGenderIdentity,
  "http://hl7.org/fhir/StructureDefinition/patient-preferenceType":
      patientPreferenceType,
  "http://hl7.org/fhir/StructureDefinition/patient-animal": patientAnimal,
  "http://hl7.org/fhir/StructureDefinition/patient-proficiency":
      patientProficiency,
  "http://hl7.org/fhir/StructureDefinition/procedure-targetBodyStructure":
      procedureTargetBodyStructure,
  "http://hl7.org/fhir/StructureDefinition/procedure-approachBodyStructure":
      procedureApproachBodyStructure,
  "http://hl7.org/fhir/StructureDefinition/procedure-method": procedureMethod,
  "http://hl7.org/fhir/StructureDefinition/procedure-progressStatus":
      procedureProgressStatus,
  "http://hl7.org/fhir/StructureDefinition/procedure-incisionDateTime":
      procedureIncisionDateTime,
  "http://hl7.org/fhir/StructureDefinition/procedure-causedBy":
      procedureCausedBy,
  "http://hl7.org/fhir/StructureDefinition/procedure-schedule":
      procedureSchedule,
  "http://hl7.org/fhir/StructureDefinition/procedure-directedBy":
      procedureDirectedBy,
  "http://hl7.org/fhir/StructureDefinition/servicerequest-geneticsItem":
      servicerequestGeneticsItem,
  "http://hl7.org/fhir/StructureDefinition/servicerequest-precondition":
      servicerequestPrecondition,
  "http://hl7.org/fhir/StructureDefinition/servicerequest-questionnaireRequest":
      servicerequestQuestionnaireRequest,
  "http://hl7.org/fhir/StructureDefinition/practitioner-animalSpecies":
      practitionerAnimalSpecies,
  "http://hl7.org/fhir/StructureDefinition/practitionerrole-primaryInd":
      practitionerrolePrimaryInd,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-minOccurs":
      questionnaireMinOccurs,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-maxOccurs":
      questionnaireMaxOccurs,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-hidden":
      questionnaireHidden,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-itemControl":
      questionnaireItemControl,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-choiceOrientation":
      questionnaireChoiceOrientation,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-referenceResource":
      questionnaireReferenceResource,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-referenceProfile":
      questionnaireReferenceProfile,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-referenceFilter":
      questionnaireReferenceFilter,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-displayCategory":
      questionnaireDisplayCategory,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-fhirType":
      questionnaireFhirType,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-unit":
      questionnaireUnit,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-unitOption":
      questionnaireUnitOption,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-unitValueSet":
      questionnaireUnitValueSet,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-optionPrefix":
      questionnaireOptionPrefix,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-optionExclusive":
      questionnaireOptionExclusive,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-usageMode":
      questionnaireUsageMode,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-supportLink":
      questionnaireSupportLink,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-baseType":
      questionnaireBaseType,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-signatureRequired":
      questionnaireSignatureRequired,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-constraint":
      questionnaireConstraint,
  "http://hl7.org/fhir/StructureDefinition/questionnaire-sliderStepValue":
      questionnaireSliderStepValue,
  "http://hl7.org/fhir/StructureDefinition/questionnaireresponse-author":
      questionnaireresponseAuthor,
  "http://hl7.org/fhir/StructureDefinition/questionnaireresponse-reviewer":
      questionnaireresponseReviewer,
  "http://hl7.org/fhir/StructureDefinition/questionnaireresponse-reason":
      questionnaireresponseReason,
  "http://hl7.org/fhir/StructureDefinition/questionnaireresponse-signature":
      questionnaireresponseSignature,
  "http://hl7.org/fhir/StructureDefinition/questionnaireresponse-completionMode":
      questionnaireresponseCompletionMode,
  "http://hl7.org/fhir/StructureDefinition/auditevent-SOPClass":
      auditeventSOPClass,
  "http://hl7.org/fhir/StructureDefinition/auditevent-Accession":
      auditeventAccession,
  "http://hl7.org/fhir/StructureDefinition/auditevent-MPPS": auditeventMPPS,
  "http://hl7.org/fhir/StructureDefinition/auditevent-NumberOfInstances":
      auditeventNumberOfInstances,
  "http://hl7.org/fhir/StructureDefinition/auditevent-Instance":
      auditeventInstance,
  "http://hl7.org/fhir/StructureDefinition/auditevent-Encrypted":
      auditeventEncrypted,
  "http://hl7.org/fhir/StructureDefinition/auditevent-Anonymized":
      auditeventAnonymized,
  "http://hl7.org/fhir/StructureDefinition/auditevent-ParticipantObjectContainsStudy":
      auditeventParticipantObjectContainsStudy,
  "http://hl7.org/fhir/StructureDefinition/specimen-sequenceNumber":
      specimenSequenceNumber,
  "http://hl7.org/fhir/StructureDefinition/specimen-collectionPriority":
      specimenCollectionPriority,
  "http://hl7.org/fhir/StructureDefinition/specimen-specialHandling":
      specimenSpecialHandling,
  "http://hl7.org/fhir/StructureDefinition/specimen-isDryWeight":
      specimenIsDryWeight,
  "http://hl7.org/fhir/StructureDefinition/specimen-processingTime":
      specimenProcessingTime,
  "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition":
      valuesetConceptDefinition,
  "http://hl7.org/fhir/StructureDefinition/valueset-concept-comments":
      valuesetConceptComments,
  "http://hl7.org/fhir/StructureDefinition/valueset-otherName":
      valuesetOtherName,
  "http://hl7.org/fhir/StructureDefinition/valueset-sourceReference":
      valuesetSourceReference,
  "http://hl7.org/fhir/StructureDefinition/valueset-keyWord": valuesetKeyWord,
  "http://hl7.org/fhir/StructureDefinition/valueset-usage": valuesetUsage,
  "http://hl7.org/fhir/StructureDefinition/valueset-workflowStatus":
      valuesetWorkflowStatus,
  "http://hl7.org/fhir/StructureDefinition/valueset-activityStatusDate":
      valuesetActivityStatusDate,
  "http://hl7.org/fhir/StructureDefinition/valueset-effectiveDate":
      valuesetEffectiveDate,
  "http://hl7.org/fhir/StructureDefinition/valueset-expirationDate":
      valuesetExpirationDate,
  "http://hl7.org/fhir/StructureDefinition/valueset-author": valuesetAuthor,
  "http://hl7.org/fhir/StructureDefinition/valueset-steward": valuesetSteward,
  "http://hl7.org/fhir/StructureDefinition/valueset-trusted-expansion":
      valuesetTrustedExpansion,
  "http://hl7.org/fhir/StructureDefinition/valueset-label": valuesetLabel,
  "http://hl7.org/fhir/StructureDefinition/valueset-conceptOrder":
      valuesetConceptOrder,
  "http://hl7.org/fhir/StructureDefinition/valueset-systemName":
      valuesetSystemName,
  "http://hl7.org/fhir/StructureDefinition/valueset-systemRef":
      valuesetSystemRef,
  "http://hl7.org/fhir/StructureDefinition/valueset-caseSensitive":
      valuesetCaseSensitive,
  "http://hl7.org/fhir/StructureDefinition/valueset-reference":
      valuesetReference,
  "http://hl7.org/fhir/StructureDefinition/valueset-expansionSource":
      valuesetExpansionSource,
  "http://hl7.org/fhir/StructureDefinition/valueset-unclosed": valuesetUnclosed,
  "http://hl7.org/fhir/StructureDefinition/valueset-toocostly":
      valuesetToocostly,
  "http://hl7.org/fhir/StructureDefinition/valueset-map": valuesetMap,
  "http://hl7.org/fhir/StructureDefinition/valueset-warning": valuesetWarning,
  "http://hl7.org/fhir/StructureDefinition/valueset-system": valuesetSystem,
  "http://hl7.org/fhir/StructureDefinition/valueset-supplement":
      valuesetSupplement,
  "http://hl7.org/fhir/StructureDefinition/valueset-parameterSource":
      valuesetParameterSource,
  "http://hl7.org/fhir/StructureDefinition/valueset-expand-rules":
      valuesetExpandRules,
  "http://hl7.org/fhir/StructureDefinition/valueset-expand-group":
      valuesetExpandGroup,
  "http://hl7.org/fhir/StructureDefinition/valueset-deprecated":
      valuesetDeprecated,
  "http://hl7.org/fhir/StructureDefinition/valueset-special-status":
      valuesetSpecialStatus,
  "http://hl7.org/fhir/StructureDefinition/valueset-extensible":
      valuesetExtensible,
  "http://hl7.org/fhir/StructureDefinition/valueset-authoritativeSource":
      valuesetAuthoritativeSource,
  "http://hl7.org/fhir/StructureDefinition/valueset-expression":
      valuesetExpression,
  "http://hl7.org/fhir/StructureDefinition/valueset-rules-text":
      valuesetRulesText,
  "http://hl7.org/fhir/StructureDefinition/concept-bidirectional":
      conceptBidirectional,
  "http://hl7.org/fhir/StructureDefinition/operationdefinition-profile":
      operationdefinitionProfile,
  "http://hl7.org/fhir/StructureDefinition/operationdefinition-allowed-type":
      operationdefinitionAllowedType,
  "http://hl7.org/fhir/StructureDefinition/http-response-header":
      httpResponseHeader,
  "http://hl7.org/fhir/StructureDefinition/match-grade": matchGrade,
  "http://hl7.org/fhir/StructureDefinition/location-distance": locationDistance,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-display-hint":
      structuredefinitionDisplayHint,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-template-status":
      structuredefinitionTemplateStatus,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm":
      structuredefinitionFmm,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm-no-warnings":
      structuredefinitionFmmNoWarnings,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg":
      structuredefinitionWg,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-explicit-type-name":
      structuredefinitionExplicitTypeName,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-fhir-type":
      structuredefinitionFhirType,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-summary":
      structuredefinitionSummary,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-ancestor":
      structuredefinitionAncestor,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-category":
      structuredefinitionCategory,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-table-name":
      structuredefinitionTableName,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status":
      structuredefinitionStandardsStatus,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-hierarchy":
      structuredefinitionHierarchy,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-xml-no-order":
      structuredefinitionXmlNoOrder,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-codegen-super":
      structuredefinitionCodegenSuper,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-dependencies":
      structuredefinitionDependencies,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-applicable-version":
      structuredefinitionApplicableVersion,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-normative-version":
      structuredefinitionNormativeVersion,
  "http://hl7.org/fhir/StructureDefinition/structuredefinition-security-category":
      structuredefinitionSecurityCategory,
  "http://hl7.org/fhir/StructureDefinition/consent-NotificationEndpoint":
      consentNotificationEndpoint,
  "http://hl7.org/fhir/StructureDefinition/consent-Witness": consentWitness,
  "http://hl7.org/fhir/StructureDefinition/consent-location": consentLocation,
  "http://hl7.org/fhir/StructureDefinition/consent-Transcriber":
      consentTranscriber,
  "http://hl7.org/fhir/StructureDefinition/codesystem-concept-comments":
      codesystemConceptComments,
  "http://hl7.org/fhir/StructureDefinition/codesystem-otherName":
      codesystemOtherName,
  "http://hl7.org/fhir/StructureDefinition/codesystem-sourceReference":
      codesystemSourceReference,
  "http://hl7.org/fhir/StructureDefinition/codesystem-keyWord":
      codesystemKeyWord,
  "http://hl7.org/fhir/StructureDefinition/codesystem-usage": codesystemUsage,
  "http://hl7.org/fhir/StructureDefinition/codesystem-workflowStatus":
      codesystemWorkflowStatus,
  "http://hl7.org/fhir/StructureDefinition/codesystem-effectiveDate":
      codesystemEffectiveDate,
  "http://hl7.org/fhir/StructureDefinition/codesystem-expirationDate":
      codesystemExpirationDate,
  "http://hl7.org/fhir/StructureDefinition/codesystem-author": codesystemAuthor,
  "http://hl7.org/fhir/StructureDefinition/codesystem-trusted-expansion":
      codesystemTrustedExpansion,
  "http://hl7.org/fhir/StructureDefinition/codesystem-history":
      codesystemHistory,
  "http://hl7.org/fhir/StructureDefinition/codesystem-label": codesystemLabel,
  "http://hl7.org/fhir/StructureDefinition/codesystem-conceptOrder":
      codesystemConceptOrder,
  "http://hl7.org/fhir/StructureDefinition/codesystem-map": codesystemMap,
  "http://hl7.org/fhir/StructureDefinition/codesystem-replacedby":
      codesystemReplacedby,
  "http://hl7.org/fhir/StructureDefinition/codesystem-warning":
      codesystemWarning,
  "http://hl7.org/fhir/StructureDefinition/codesystem-alternate":
      codesystemAlternate,
  "http://hl7.org/fhir/StructureDefinition/task-candidateList":
      taskCandidateList,
  "http://hl7.org/fhir/StructureDefinition/task-replaces": taskReplaces,
  "http://hl7.org/fhir/StructureDefinition/organizationaffiliation-primaryInd":
      organizationaffiliationPrimaryInd,
  "http://hl7.org/fhir/StructureDefinition/data-absent-reason":
      dataAbsentReason,
  "http://hl7.org/fhir/StructureDefinition/bodySite": bodySite,
  "http://hl7.org/fhir/StructureDefinition/rendered-value": renderedValue,
  "http://hl7.org/fhir/StructureDefinition/geolocation": geolocation,
  "http://hl7.org/fhir/StructureDefinition/translation": translation,
  "http://hl7.org/fhir/StructureDefinition/tz-code": tzCode,
  "http://hl7.org/fhir/StructureDefinition/tz-offset": tzOffset,
  "http://hl7.org/fhir/StructureDefinition/relative-date": relativeDate,
  "http://hl7.org/fhir/StructureDefinition/language": language,
  "http://hl7.org/fhir/StructureDefinition/originalText": originalText,
  "http://hl7.org/fhir/StructureDefinition/narrativeLink": narrativeLink,
  "http://hl7.org/fhir/StructureDefinition/replaces": replaces,
  "http://hl7.org/fhir/StructureDefinition/display": display,
  "http://hl7.org/fhir/StructureDefinition/variable": variable,
  "http://hl7.org/fhir/StructureDefinition/ordinalValue": ordinalValue,
  "http://hl7.org/fhir/StructureDefinition/designNote": designNote,
  "http://hl7.org/fhir/StructureDefinition/iso21090-nullFlavor":
      iso21090NullFlavor,
  "http://hl7.org/fhir/StructureDefinition/iso21090-EN-qualifier":
      iso21090ENQualifier,
  "http://hl7.org/fhir/StructureDefinition/iso21090-EN-use": iso21090ENUse,
  "http://hl7.org/fhir/StructureDefinition/iso21090-EN-representation":
      iso21090ENRepresentation,
  "http://hl7.org/fhir/StructureDefinition/iso21090-uncertainty":
      iso21090Uncertainty,
  "http://hl7.org/fhir/StructureDefinition/iso21090-uncertaintyType":
      iso21090UncertaintyType,
  "http://hl7.org/fhir/StructureDefinition/iso21090-AD-use": iso21090ADUse,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-additionalLocator":
      iso21090ADXPAdditionalLocator,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-unitID":
      iso21090ADXPUnitID,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-unitType":
      iso21090ADXPUnitType,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-deliveryAddressLine":
      iso21090ADXPDeliveryAddressLine,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-deliveryInstallationType":
      iso21090ADXPDeliveryInstallationType,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-deliveryInstallationArea":
      iso21090ADXPDeliveryInstallationArea,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-deliveryInstallationQualifier":
      iso21090ADXPDeliveryInstallationQualifier,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-deliveryMode":
      iso21090ADXPDeliveryMode,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-deliveryModeIdentifier":
      iso21090ADXPDeliveryModeIdentifier,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetAddressLine":
      iso21090ADXPStreetAddressLine,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumber":
      iso21090ADXPHouseNumber,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-buildingNumberSuffix":
      iso21090ADXPBuildingNumberSuffix,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-postBox":
      iso21090ADXPPostBox,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-houseNumberNumeric":
      iso21090ADXPHouseNumberNumeric,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetName":
      iso21090ADXPStreetName,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetNameBase":
      iso21090ADXPStreetNameBase,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-streetNameType":
      iso21090ADXPStreetNameType,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-direction":
      iso21090ADXPDirection,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-careOf":
      iso21090ADXPCareOf,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-censusTract":
      iso21090ADXPCensusTract,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-delimiter":
      iso21090ADXPDelimiter,
  "http://hl7.org/fhir/StructureDefinition/iso21090-ADXP-precinct":
      iso21090ADXPPrecinct,
  "http://hl7.org/fhir/StructureDefinition/iso21090-SC-coding":
      iso21090SCCoding,
  "http://hl7.org/fhir/StructureDefinition/iso21090-preferred":
      iso21090Preferred,
  "http://hl7.org/fhir/StructureDefinition/iso21090-TEL-address":
      iso21090TELAddress,
  "http://hl7.org/fhir/StructureDefinition/iso21090-PQ-translation":
      iso21090PQTranslation,
  "http://fhir-registry.smarthealthit.org/StructureDefinition/capabilities":
      capabilities,
  "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris":
      oauthUris,
  "http://hl7.org/fhir/StructureDefinition/minLength": minLength,
  "http://hl7.org/fhir/StructureDefinition/regex": regex,
  "http://hl7.org/fhir/StructureDefinition/entryFormat": entryFormat,
  "http://hl7.org/fhir/StructureDefinition/minValue": minValue,
  "http://hl7.org/fhir/StructureDefinition/maxValue": maxValue,
  "http://hl7.org/fhir/StructureDefinition/maxDecimalPlaces": maxDecimalPlaces,
  "http://hl7.org/fhir/StructureDefinition/mimeType": mimeType,
  "http://hl7.org/fhir/StructureDefinition/maxSize": maxSize,
  "http://hl7.org/fhir/StructureDefinition/rendering-style": renderingStyle,
  "http://hl7.org/fhir/StructureDefinition/rendering-xhtml": renderingXhtml,
  "http://hl7.org/fhir/StructureDefinition/rendering-markdown":
      renderingMarkdown,
  "http://hl7.org/fhir/StructureDefinition/rendering-styleSensitive":
      renderingStyleSensitive,
  "http://hl7.org/fhir/StructureDefinition/11179-objectClass": objectClass11179,
  "http://hl7.org/fhir/StructureDefinition/11179-objectClassProperty":
      objectClassProperty11179,
  "http://hl7.org/fhir/StructureDefinition/11179-permitted-value-valueset":
      permittedValueValueset11179,
  "http://hl7.org/fhir/StructureDefinition/11179-permitted-value-conceptmap":
      permittedValueConceptmap11179,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-identifier":
      elementdefinitionIdentifier,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-question":
      elementdefinitionQuestion,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-allowedUnits":
      elementdefinitionAllowedUnits,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-maxValueSet":
      elementdefinitionMaxValueSet,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-minValueSet":
      elementdefinitionMinValueSet,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-inheritedExtensibleValueSet":
      elementdefinitionInheritedExtensibleValueSet,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-bindingName":
      elementdefinitionBindingName,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-isCommonBinding":
      elementdefinitionIsCommonBinding,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-equivalence":
      elementdefinitionEquivalence,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-namespace":
      elementdefinitionNamespace,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-bestpractice":
      elementdefinitionBestpractice,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-bestpractice-explanation":
      elementdefinitionBestpracticeExplanation,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-selector":
      elementdefinitionSelector,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-translatable":
      elementdefinitionTranslatable,
  "http://hl7.org/fhir/StructureDefinition/elementdefinition-profile-element":
      elementdefinitionProfileElement,
  "http://hl7.org/fhir/StructureDefinition/no-binding": noBinding,
  "http://hl7.org/fhir/StructureDefinition/timing-exact": timingExact,
  "http://hl7.org/fhir/StructureDefinition/timing-daysOfCycle":
      timingDaysOfCycle,
  "http://hl7.org/fhir/StructureDefinition/timing-dayOfMonth": timingDayOfMonth,
  "http://hl7.org/fhir/StructureDefinition/usagecontext-group":
      usagecontextGroup,
  "http://hl7.org/fhir/StructureDefinition/humanname-own-name":
      humannameOwnName,
  "http://hl7.org/fhir/StructureDefinition/humanname-own-prefix":
      humannameOwnPrefix,
  "http://hl7.org/fhir/StructureDefinition/humanname-partner-name":
      humannamePartnerName,
  "http://hl7.org/fhir/StructureDefinition/humanname-partner-prefix":
      humannamePartnerPrefix,
  "http://hl7.org/fhir/StructureDefinition/humanname-mothers-family":
      humannameMothersFamily,
  "http://hl7.org/fhir/StructureDefinition/humanname-fathers-family":
      humannameFathersFamily,
  "http://hl7.org/fhir/StructureDefinition/humanname-assembly-order":
      humannameAssemblyOrder,
  "http://hl7.org/fhir/StructureDefinition/coding-sctdescid": codingSctdescid,
  "http://hl7.org/fhir/StructureDefinition/quantity-precision":
      quantityPrecision,
  "http://hl7.org/fhir/StructureDefinition/contactpoint-country":
      contactpointCountry,
  "http://hl7.org/fhir/StructureDefinition/contactpoint-area": contactpointArea,
  "http://hl7.org/fhir/StructureDefinition/contactpoint-local":
      contactpointLocal,
  "http://hl7.org/fhir/StructureDefinition/contactpoint-extension":
      contactpointExtension,
  "http://hl7.org/fhir/StructureDefinition/identifier-validDate":
      identifierValidDate,
  "http://hl7.org/fhir/StructureDefinition/event-partOf": eventPartOf,
  "http://hl7.org/fhir/StructureDefinition/event-statusReason":
      eventStatusReason,
  "http://hl7.org/fhir/StructureDefinition/event-eventHistory":
      eventEventHistory,
  "http://hl7.org/fhir/StructureDefinition/event-performerFunction":
      eventPerformerFunction,
  "http://hl7.org/fhir/StructureDefinition/event-basedOn": eventBasedOn,
  "http://hl7.org/fhir/StructureDefinition/event-location": eventLocation,
  "http://hl7.org/fhir/StructureDefinition/request-statusReason":
      requestStatusReason,
  "http://hl7.org/fhir/StructureDefinition/request-doNotPerform":
      requestDoNotPerform,
  "http://hl7.org/fhir/StructureDefinition/request-insurance": requestInsurance,
  "http://hl7.org/fhir/StructureDefinition/request-relevantHistory":
      requestRelevantHistory,
  "http://hl7.org/fhir/StructureDefinition/request-replaces": requestReplaces,
  "http://hl7.org/fhir/StructureDefinition/request-performerOrder":
      requestPerformerOrder,
  "http://hl7.org/fhir/StructureDefinition/workflow-instantiatesCanonical":
      workflowInstantiatesCanonical,
  "http://hl7.org/fhir/StructureDefinition/workflow-instantiatesUri":
      workflowInstantiatesUri,
  "http://hl7.org/fhir/StructureDefinition/workflow-reasonCode":
      workflowReasonCode,
  "http://hl7.org/fhir/StructureDefinition/workflow-reasonReference":
      workflowReasonReference,
  "http://hl7.org/fhir/StructureDefinition/workflow-supportingInfo":
      workflowSupportingInfo,
  "http://hl7.org/fhir/StructureDefinition/workflow-relatedArtifact":
      workflowRelatedArtifact,
  "http://hl7.org/fhir/StructureDefinition/workflow-researchStudy":
      workflowResearchStudy,
  "http://hl7.org/fhir/StructureDefinition/workflow-episodeOfCare":
      workflowEpisodeOfCare,
  "http://hl7.org/fhir/StructureDefinition/cqf-qualityOfEvidence":
      cqfQualityOfEvidence,
  "http://hl7.org/fhir/StructureDefinition/cqf-strengthOfRecommendation":
      cqfStrengthOfRecommendation,
  "http://hl7.org/fhir/StructureDefinition/cqf-citation": cqfCitation,
  "http://hl7.org/fhir/StructureDefinition/cqf-library": cqfLibrary,
  "http://hl7.org/fhir/StructureDefinition/cqf-expression": cqfExpression,
  "http://hl7.org/fhir/StructureDefinition/cqf-initialValue": cqfInitialValue,
  "http://hl7.org/fhir/StructureDefinition/cqf-calculatedValue":
      cqfCalculatedValue,
  "http://hl7.org/fhir/StructureDefinition/cqf-measureInfo": cqfMeasureInfo,
  "http://hl7.org/fhir/StructureDefinition/cqf-initiatingOrganization":
      cqfInitiatingOrganization,
  "http://hl7.org/fhir/StructureDefinition/cqf-initiatingPerson":
      cqfInitiatingPerson,
  "http://hl7.org/fhir/StructureDefinition/cqf-systemUserType":
      cqfSystemUserType,
  "http://hl7.org/fhir/StructureDefinition/cqf-systemUserLanguage":
      cqfSystemUserLanguage,
  "http://hl7.org/fhir/StructureDefinition/cqf-systemUserTaskContext":
      cqfSystemUserTaskContext,
  "http://hl7.org/fhir/StructureDefinition/cqf-receivingOrganization":
      cqfReceivingOrganization,
  "http://hl7.org/fhir/StructureDefinition/cqf-receivingPerson":
      cqfReceivingPerson,
  "http://hl7.org/fhir/StructureDefinition/cqf-recipientType": cqfRecipientType,
  "http://hl7.org/fhir/StructureDefinition/cqf-recipientLanguage":
      cqfRecipientLanguage,
  "http://hl7.org/fhir/StructureDefinition/cqf-encounterClass":
      cqfEncounterClass,
  "http://hl7.org/fhir/StructureDefinition/cqf-encounterType": cqfEncounterType,
  "http://hl7.org/fhir/StructureDefinition/cqf-relativeDateTime":
      cqfRelativeDateTime,
  "http://hl7.org/fhir/StructureDefinition/cqf-cdsHooksEndpoint":
      cqfCdsHooksEndpoint,
  "http://hl7.org/fhir/StructureDefinition/cqf-contactReference":
      cqfContactReference,
  "http://hl7.org/fhir/StructureDefinition/cqf-contributionTime":
      cqfContributionTime,
  "http://hl7.org/fhir/StructureDefinition/cqf-contactAddress":
      cqfContactAddress,
  "http://hl7.org/fhir/StructureDefinition/cqf-certainty": cqfCertainty,
  "http://hl7.org/fhir/StructureDefinition/Element": element,
  "Element": element,
  "http://hl7.org/fhir/StructureDefinition/BackboneElement": backboneElement,
  "BackboneElement": backboneElement,
  "http://hl7.org/fhir/StructureDefinition/base64Binary": base64Binary,
  "base64Binary": base64Binary,
  "http://hl7.org/fhir/StructureDefinition/boolean": boolean,
  "Boolean": boolean,
  "boolean": boolean,
  "http://hl7.org/fhir/StructureDefinition/canonical": canonical,
  "canonical": canonical,
  "http://hl7.org/fhir/StructureDefinition/code": code,
  "code": code,
  "http://hl7.org/fhir/StructureDefinition/date": date,
  "Date": date,
  "date": date,
  "http://hl7.org/fhir/StructureDefinition/dateTime": dateTime,
  "DateTime": dateTime,
  "dateTime": dateTime,
  "http://hl7.org/fhir/StructureDefinition/decimal": decimal,
  "Decimal": decimal,
  "decimal": decimal,
  "http://hl7.org/fhir/StructureDefinition/id": id,
  "id": id,
  "http://hl7.org/fhir/StructureDefinition/instant": instant,
  "instant": instant,
  "http://hl7.org/fhir/StructureDefinition/integer": integer,
  "Integer": integer,
  "integer": integer,
  "http://hl7.org/fhir/StructureDefinition/markdown": markdown,
  "markdown": markdown,
  "http://hl7.org/fhir/StructureDefinition/oid": oid,
  "oid": oid,
  "http://hl7.org/fhir/StructureDefinition/positiveInt": positiveInt,
  "positiveInt": positiveInt,
  "http://hl7.org/fhir/StructureDefinition/string": string,
  "String": string,
  "string": string,
  "http://hl7.org/fhir/StructureDefinition/time": time,
  "Time": time,
  "time": time,
  "http://hl7.org/fhir/StructureDefinition/unsignedInt": unsignedInt,
  "unsignedInt": unsignedInt,
  "http://hl7.org/fhir/StructureDefinition/uri": uri,
  "uri": uri,
  "http://hl7.org/fhir/StructureDefinition/url": url,
  "url": url,
  "http://hl7.org/fhir/StructureDefinition/uuid": uuid,
  "uuid": uuid,
  "http://hl7.org/fhir/StructureDefinition/xhtml": xhtml,
  "xhtml": xhtml,
  "http://hl7.org/fhir/StructureDefinition/Address": address,
  "Address": address,
  "http://hl7.org/fhir/StructureDefinition/Age": age,
  "Age": age,
  "http://hl7.org/fhir/StructureDefinition/Annotation": annotation,
  "Annotation": annotation,
  "http://hl7.org/fhir/StructureDefinition/Attachment": attachment,
  "Attachment": attachment,
  "http://hl7.org/fhir/StructureDefinition/CodeableConcept": codeableConcept,
  "CodeableConcept": codeableConcept,
  "http://hl7.org/fhir/StructureDefinition/CodeableReference":
      codeableReference,
  "CodeableReference": codeableReference,
  "http://hl7.org/fhir/StructureDefinition/Coding": coding,
  "Coding": coding,
  "http://hl7.org/fhir/StructureDefinition/ContactDetail": contactDetail,
  "ContactDetail": contactDetail,
  "http://hl7.org/fhir/StructureDefinition/ContactPoint": contactPoint,
  "ContactPoint": contactPoint,
  "http://hl7.org/fhir/StructureDefinition/Contributor": contributor,
  "Contributor": contributor,
  "http://hl7.org/fhir/StructureDefinition/Count": count,
  "Count": count,
  "http://hl7.org/fhir/StructureDefinition/DataRequirement": dataRequirement,
  "DataRequirement": dataRequirement,
  "http://hl7.org/fhir/StructureDefinition/Distance": distance,
  "Distance": distance,
  "http://hl7.org/fhir/StructureDefinition/Dosage": dosage,
  "Dosage": dosage,
  "http://hl7.org/fhir/StructureDefinition/Duration": duration,
  "Duration": duration,
  "http://hl7.org/fhir/StructureDefinition/ElementDefinition":
      elementDefinition,
  "ElementDefinition": elementDefinition,
  "http://hl7.org/fhir/StructureDefinition/Expression": expression,
  "Expression": expression,
  "http://hl7.org/fhir/StructureDefinition/Extension": extension,
  "Extension": extension,
  "http://hl7.org/fhir/StructureDefinition/HumanName": humanName,
  "HumanName": humanName,
  "http://hl7.org/fhir/StructureDefinition/Identifier": identifier,
  "Identifier": identifier,
  "http://hl7.org/fhir/StructureDefinition/MarketingStatus": marketingStatus,
  "MarketingStatus": marketingStatus,
  "http://hl7.org/fhir/StructureDefinition/Meta": meta,
  "Meta": meta,
  "http://hl7.org/fhir/StructureDefinition/Money": money,
  "Money": money,
  "http://hl7.org/fhir/StructureDefinition/Narrative": narrative,
  "Narrative": narrative,
  "http://hl7.org/fhir/StructureDefinition/ParameterDefinition":
      parameterDefinition,
  "ParameterDefinition": parameterDefinition,
  "http://hl7.org/fhir/StructureDefinition/Period": period,
  "Period": period,
  "http://hl7.org/fhir/StructureDefinition/Population": population,
  "Population": population,
  "http://hl7.org/fhir/StructureDefinition/ProdCharacteristic":
      prodCharacteristic,
  "http://hl7.org/fhir/StructureDefinition/ProductShelfLife": productShelfLife,
  "ProductShelfLife": productShelfLife,
  "http://hl7.org/fhir/StructureDefinition/Quantity": quantity,
  "Quantity": quantity,
  "http://hl7.org/fhir/StructureDefinition/Range": range,
  "Range": range,
  "http://hl7.org/fhir/StructureDefinition/Ratio": ratio,
  "Ratio": ratio,
  "http://hl7.org/fhir/StructureDefinition/RatioRange": ratioRange,
  "RatioRange": ratioRange,
  "http://hl7.org/fhir/StructureDefinition/Reference": reference,
  "Reference": reference,
  "http://hl7.org/fhir/StructureDefinition/RelatedArtifact": relatedArtifact,
  "RelatedArtifact": relatedArtifact,
  "http://hl7.org/fhir/StructureDefinition/SampledData": sampledData,
  "SampledData": sampledData,
  "http://hl7.org/fhir/StructureDefinition/Signature": signature,
  "Signature": signature,
  "http://hl7.org/fhir/StructureDefinition/Timing": timing,
  "Timing": timing,
  "http://hl7.org/fhir/StructureDefinition/TriggerDefinition":
      triggerDefinition,
  "TriggerDefinition": triggerDefinition,
  "http://hl7.org/fhir/StructureDefinition/UsageContext": usageContext,
  "UsageContext": usageContext,
  "http://hl7.org/fhir/StructureDefinition/MoneyQuantity": moneyQuantity,
  "http://hl7.org/fhir/StructureDefinition/SimpleQuantity": simpleQuantity,
  "http://hl7.org/fhirpath/System.String": string,
  "http://hl7.org/fhirpath/System.Boolean": boolean,
  "http://hl7.org/fhirpath/System.Date": date,
  "http://hl7.org/fhirpath/System.DateTime": dateTime,
  "http://hl7.org/fhirpath/System.Decimal": decimal,
  "http://hl7.org/fhirpath/System.Integer": integer,
  "http://hl7.org/fhirpath/System.Time": time,
};
