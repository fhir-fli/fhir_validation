import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

/// Function to check the paths of a FHIR resource against its structure definition.
/// It validates the type of each element and checks if it adheres to any value set bindings or constraints.
Future<Map<String, dynamic>> checkPaths(
  Map<String, FhirValidationObject>
      fhirPathMatches, // Map of FHIR paths to validation objects
  String startPath, // Starting path for validation
  Map<String, dynamic>
      fhirPaths, // Map of FHIR paths to their corresponding values
  StructureDefinition
      structureDefinition, // Structure definition of the resource
) async {
  var returnMap = <String, dynamic>{}; // Map to store validation results
  final downloads =
      <String, dynamic>{}; // Cache for downloaded value sets and code systems
  final codes = <String,
      List<String>>{}; // Cache for codes from value sets and code systems

  // Iterate through each FHIR path match
  for (final key in fhirPathMatches.keys) {
    final FhirValidationObject value = fhirPathMatches[key]!;

    // Check if there is a full match for the element path
    if (value.fullMatch != null && value.fullMatch != '') {
      if (value.type != null && value.type!.isNotEmpty) {
        // Validate if the value is a valid primitive type
        if (!isValueAValidPrimitive(value.type!, fhirPaths[key])) {
          returnMap = addToMap(
            returnMap,
            startPath,
            key,
            "This property should be a type '${value.type}' (${fhirPrimitiveToDartPrimitive(value.type!)}) but it is invalid",
            Severity.error,
          );
        }

        // Check if there is a ValueSet binding for this element
        if (value.binding?.valueSet != null) {
          if (value.binding?.strength != null &&
              value.binding!.strength !=
                  ElementDefinitionBindingStrength.example) {
            Map<String, dynamic>? valueSetMap;
            var canonical = value.binding!.valueSet.toString();

            // Check if the value set is already downloaded
            if (downloads.containsKey(canonical)) {
              valueSetMap = downloads[canonical];
            } else {
              // Download the value set
              valueSetMap = await getValueSet(canonical);
              downloads[canonical] = valueSetMap;
            }

            // Fallback to download if value set map is null
            if (valueSetMap == null) {
              valueSetMap = await getValueSet(canonical);
            }

            ValueSet? valueSet;

            if (valueSetMap != null) {
              valueSet = ValueSet.fromJson(valueSetMap);

              // Cache the codes from the value set
              if (!codes.containsKey(canonical)) {
                codes[canonical] = [];

                for (var include
                    in valueSet.compose?.include ?? <ValueSetInclude>[]) {
                  if (include.concept?.isNotEmpty ?? false) {
                    for (var concept in include.concept!) {
                      if (concept.code != null) {
                        codes[canonical]!.add(concept.code.toString());
                      }
                    }
                  } else if (include.system != null) {
                    Map<String, dynamic>? codeSystemMap;
                    canonical = include.system.toString();

                    // Check if the code system is already downloaded
                    if (downloads.containsKey(include.system.toString())) {
                      codeSystemMap = downloads[include.system];
                    } else {
                      // Download the code system
                      codeSystemMap = await getCodeSystem(canonical);
                      downloads[canonical] = codeSystemMap;
                    }

                    // Fallback to download if code system map is null
                    if (codeSystemMap == null) {
                      codeSystemMap = await getCodeSystem(canonical);
                    }
                    if (codeSystemMap != null) {
                      final codeSystem = CodeSystem.fromJson(codeSystemMap);
                      for (var concept
                          in codeSystem.concept ?? <CodeSystemConcept>[]) {
                        if (concept.code != null) {
                          codes[canonical] ??= [];
                          codes[canonical]!.add(concept.code.toString());
                        }
                      }
                    }
                  }
                }
              }
            }

            // Validate if the code is in the value set
            if (codes[canonical] != null && codes[canonical]!.isNotEmpty) {
              if (!(codes[canonical]?.contains(fhirPaths[key]) ?? false)) {
                if (value.binding!.strength ==
                    ElementDefinitionBindingStrength.required_) {
                  returnMap = addToMap(
                    returnMap,
                    startPath,
                    key,
                    await notInValueSetMessage(
                      fhirPaths[key],
                      value.binding?.valueSet,
                      'but is required to be',
                    ),
                    Severity.error,
                  );
                } else if (value.binding!.strength ==
                    ElementDefinitionBindingStrength.extensible) {
                  returnMap = addToMap(
                    returnMap,
                    startPath,
                    key,
                    await notInValueSetMessage(
                      fhirPaths[key],
                      value.binding?.valueSet,
                      ', and it is extensible, so it probably should be',
                    ),
                    Severity.warning,
                  );
                } else if (value.binding!.strength ==
                    ElementDefinitionBindingStrength.preferred) {
                  returnMap = addToMap(
                    returnMap,
                    startPath,
                    key,
                    await notInValueSetMessage(
                      fhirPaths[key],
                      value.binding?.valueSet,
                      ', it is not required, but it is encouraged',
                    ),
                    Severity.information,
                  );
                }
              }
            }
          }
        }
      }
    }

    // Validate constraints
    final constraints = value.constraint;
    for (final constraint in constraints ?? <ElementDefinitionConstraint>[]) {
      if (!await evaluateConstraint(
          constraint.expression!, fhirPaths[key], startPath)) {
        returnMap = addToMap(
          returnMap,
          startPath,
          key,
          "Constraint violated: ${constraint.human}",
          Severity.error,
        );
      }
    }
  }

  return returnMap;
}

/// Utility function to evaluate FHIRPath expressions
Future<bool> evaluateConstraint(
  String expression, // FHIRPath expression to evaluate
  dynamic context, // Context in which to evaluate the expression
  String startPath, // Starting path for evaluation
) async {
  // Placeholder for actual FHIRPath evaluation logic
  try {
    final result = walkFhirPath(pathExpression: expression, context: context);
    if (result.isNotEmpty) {
      return result[0] == true;
    }
    return false;
  } catch (e) {
    // Handle exception or logging
    return false;
  }
}
