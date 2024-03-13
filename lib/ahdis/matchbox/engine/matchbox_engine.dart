import '../../validation_engine.dart';

class MatchboxEngine extends ValidationEngine {
  MatchboxEngine(ValidationEngine other) : super() {
    // Create a new IgLoader, ensuring synchronization between it and the engine's context
    this.setIgLoader(IgLoader(this.getPcm(), this.getContext(), this.getVersion(), this.isDebug()));
  }

  // Builder class to instantiate a MappingEngine
  class MatchboxEngineBuilder extends ValidationEngineBuilder {
    String? txServer;
    FilesystemPackageCacheManager.FilesystemPackageCacheMode packageCacheMode =
        FilesystemPackageCacheManager.FilesystemPackageCacheMode.USER;
    String? packageCachePath;
    final fhirVersion = FhirPublication.R4;

    MatchboxEngineBuilder();

    void setTxServer(String? txServer) {
      this.txServer = txServer;
    }

    void setPackageCacheMode(
        FilesystemPackageCacheManager.FilesystemPackageCacheMode packageCacheMode) {
      this.packageCacheMode = packageCacheMode;
    }

    void setPackageCachePath(String? packageCachePath) {
      this.packageCacheMode =
          FilesystemPackageCacheManager.FilesystemPackageCacheMode.CUSTOM;
      this.packageCachePath = packageCachePath;
    }

    Future<MatchboxEngine> getEngineR4() async {
      log.info('Initializing Matchbox Engine (FHIR R4 with terminology provided in classpath)');
      log.info(VersionUtil.getPoweredBy());

      final engine = MatchboxEngine(await super.fromNothing());
      engine.setVersion(this.fhirVersion.toCode());
      engine.loadPackage('/hl7.fhir.r4.core.tgz'); // Replace with Dart specific way to load resources
      engine.loadPackage('/hl7.terminology#5.3.0.tgz'); // Replace with Dart specific way to load resources
      engine.loadPackage('/hl7.fhir.uv.extensions.r4#1.0.0.tgz'); // Replace with Dart specific way to load resources

      if (this.txServer == null) {
        engine.context.canRunWithoutTerminology = true;
        engine.context.noTerminologyServer = true;
      } else {
        engine.context.canRunWithoutTerminology = false;
        engine.context.noTerminologyServer = false;
        engine.setTerminologyServer(this.txServer, null, FhirPublication.R4);
      }
      engine.context.packageTracker = engine;
      engine.setPcm(this.getFilesystemPackageCacheManager()); // Handle this according to Dart implementation

      return engine;
    }
  }


// class MatchboxEngine extends ValidationEngine {
//   MatchboxEngine(ValidationEngine other) : super(other);

//   Future<MatchboxEngine> getEngine() async {
//     log.info('Initializing Matchbox Engine');
//     log.info(VersionUtil.getPoweredBy());

//     final engine = MatchboxEngine(await super.fromNothing());
//     engine.setVersion(this.fhirVersion.toCode());

//     if (this.txServer == null) {
//       engine.context.canRunWithoutTerminology = true;
//       engine.context.noTerminologyServer = true;
//     } else {
//       engine.context.canRunWithoutTerminology = false;
//       engine.context.noTerminologyServer = false;
//       engine.setTerminologyServer(this.txServer, null, FhirPublication.R4);
//     }

//     engine.context.packageTracker = engine;
//     engine.setPcm(await this.getFilesystemPackageCacheManager());
//     return engine;
//   }

//   Future<FilesystemPackageCacheManager> getFilesystemPackageCacheManager() async {
//     if (this.packageCacheMode == FilesystemPackageCacheManager.FilesystemPackageCacheMode.CUSTOM) {
//       return FilesystemPackageCacheManager(this.packageCachePath);
//     } else {
//       return FilesystemPackageCacheManager(this.packageCacheMode);
//     }
//   }

//   r4.Resource transformToFhir(String input, bool inputJson, String mapUri) {
//     final transformedXml = transform(input, inputJson, mapUri, false);
//     return r4.XmlParser().parse(transformedXml);
//   }

//   String transform(String input, bool inputJson, String mapUri, bool outputJson) {
//     log.info('Start transform: $mapUri');
//     final transformed = transform(utf8.encode(input), (inputJson ? FhirFormat.JSON : FhirFormat.XML), mapUri);

//     final boas = ByteArrayOutputStream();
//     if (outputJson) {
//       r4.JsonParser(getContext()).compose(transformed, boas, OutputStyle.PRETTY, null);
//     } else {
//       r4.XmlParser(getContext()).compose(transformed, boas, OutputStyle.PRETTY, null);
//     }

//     final result = utf8.decode(boas.toByteArray());
//     boas.close();

//     log.info('Transform finished: $mapUri');
//     return result;
//   }

//   @override
//   r4.Element transformBytes(List<int> source, FhirFormat cntType, String mapUri) {
//     final context = this.getContext();
//     final src = Manager.parseSingle(context, Stream.fromIterable([source]), cntType);
//     return transform(src, mapUri);
//   }
// }



}
