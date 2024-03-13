import 'package:fhir/r4.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

import '../matchbox.dart';
import '../../validation_engine.dart';
import 'cli/version_util.dart';

class CdaMappingEngine extends MatchboxEngine {
  CdaMappingEngine(ValidationEngine other) : super(other);

  static Future<CdaMappingEngine> getEngine() async {
    log.log(Level.info, 'Initializing CDA Mapping Engine');
    log.log(Level.info, VersionUtil.getPoweredBy());

    final engine =
        CdaMappingEngine(await ValidationEngineBuilder.fromNothing());
    engine.setVersion('4.0.1');

    // Load packages from resources
    await engine.loadPackage('hl7.fhir.r4.core.tgz');
    await engine.loadPackage('hl7.terminology#5.3.0.tgz');
    await engine.loadPackage('hl7.fhir.uv.extensions.r4#1.0.0.tgz');
    await engine.loadPackage('hl7.cda.uv.core#2.1.0-draft2-mb.tgz');

    // Set engine context configurations
    engine.context.canRunWithoutTerminology = true;
    engine.context.noTerminologyServer = true;
    engine.context.packageTracker = engine;

    return engine;
  }

  Future<Bundle> transformCdaToFhir(String cda, String mapUri) async {
    try {
      final result = await transformToFhir(cda, false, mapUri);
      return Bundle.fromJson(json.decode(result.toJson()));
    } catch (e) {
      // Handle exceptions
      rethrow;
    }
  }
}
