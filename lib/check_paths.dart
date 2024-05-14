import 'package:fhir_r4/fhir_r4.dart';
import 'fhir_validation.dart';

Future<Map<String, dynamic>> checkPaths(
  Map<String, FhirValidationObject> fhirPathMatches,
  String startPath,
  Map<String, dynamic> fhirPaths,
  StructureDefinition structureDefinition,
) async {
  var returnMap = <String, dynamic>{};
  final downloads = <String, dynamic>{};
  final codes = <String, List<String>>{};

  for (final key in fhirPathMatches.keys) {
    final FhirValidationObject value = fhirPathMatches[key]!;
    print('Checking path: $key -> ${value.fullMatch}');

    if (value.fullMatch != null && value.fullMatch != '') {
      if (value.type != null && value.type!.isNotEmpty) {
        print('Validating type for: $key');
        if (!isValueAValidPrimitive(value.type!, fhirPaths[key])) {
          returnMap = addToMap(
              returnMap,
              startPath,
              key,
              "This property should be a type '${value.type}' (${fhirPrimitiveToDartPrimitive(value.type!)}) but it is invalid",
              Severity.error);
        }
        if (value.binding?.valueSet != null) {
          if (value.binding?.strength != null &&
              value.binding!.strength !=
                  ElementDefinitionBindingStrength.example) {
            Map<String, dynamic>? valueSetMap;
            var canonical = value.binding!.valueSet.toString();

            if (downloads.containsKey(canonical)) {
              valueSetMap = downloads[canonical];
            } else {
              valueSetMap = await getValueSet(canonical);
              downloads[canonical] = valueSetMap;
            }

            if (valueSetMap == null) {
              valueSetMap = await getValueSet(canonical);
            }

            ValueSet? valueSet;

            if (valueSetMap != null) {
              valueSet = ValueSet.fromJson(valueSetMap);

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

                    if (downloads.containsKey(include.system.toString())) {
                      codeSystemMap = downloads[include.system];
                    } else {
                      codeSystemMap = await getCodeSystem(canonical);
                      downloads[canonical] = codeSystemMap;
                    }

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
                      Severity.error);
                } else if (value.binding!.strength ==
                    ElementDefinitionBindingStrength.extensible) {
                  returnMap = addToMap(
                      returnMap,
                      startPath,
                      key,
                      await notInValueSetMessage(
                          fhirPaths[key],
                          value.binding?.valueSet,
                          ', and it is extensible, so it probably should be'),
                      Severity.warning);
                } else if (value.binding!.strength ==
                    ElementDefinitionBindingStrength.preferred) {
                  returnMap = addToMap(
                      returnMap,
                      startPath,
                      key,
                      await notInValueSetMessage(
                          fhirPaths[key],
                          value.binding?.valueSet,
                          ', it is not required, but it is encouraged'),
                      Severity.information);
                }
              }
            }
          }
        }
      }
    }

    final constraints = value.constraint;
    for (final constraint in constraints ?? <ElementDefinitionConstraint>[]) {
      if (!await evaluateConstraint(
          constraint.expression!, fhirPaths[key], startPath)) {
        returnMap = addToMap(returnMap, startPath, key,
            "Constraint violated: ${constraint.human}", Severity.error);
      }
    }
  }

  return returnMap;
}

// Utility function to evaluate FHIRPath expressions
Future<bool> evaluateConstraint(
    String expression, dynamic context, String startPath) async {
  // Implement your FHIRPath evaluation logic here
  // This is a placeholder example and should be replaced with actual FHIRPath evaluation logic
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
