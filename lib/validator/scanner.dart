import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:fhir_r5/fhir_r5.dart';

import 'validation.dart';

class Scanner {
  final InstanceValidator validator;
  final FHIRPathEngine fhirPathEngine;

  Scanner(this.validator, this.fhirPathEngine);

  Future<void> validateScan(String output, List<String> sources) async {
    if (output.isEmpty)
      throw Exception("Output parameter required when scanning");
    var outputDir = Directory(output);
    if (!outputDir.existsSync() ||
        outputDir.statSync().type != FileSystemEntityType.directory) {
      throw Exception("Output '$output' must be a directory when scanning");
    }
    print("  .. scan $sources against loaded IGs");

    Set<String> urls = Set<String>();

    var igs = await fetchImplementationGuides();
    for (var ig in igs) {
      if ((ig.url?.toString().contains("/ImplementationGuide") ?? false) &&
          ig.url != "http://hl7.org/fhir/ImplementationGuide/fhir") {
        urls.add(ig.url!.toString());
      }
    }
    List<ScanOutputItem> res = await validateScan(sources, urls);
    await genScanOutput(output, res);
    print("Done. output in ${path.join(output, "scan.html")}");
  }

  Future<List<ScanOutputItem>> fromSourcesValidateScan(
      List<String> sources, Set<String> urls) async {
    final List<ScanOutputItem> res = [];

    // Assuming you have similar utilities in Dart for parsing sources and fetching IG content
    final List<SourceFile> refs =
        await ValidatorUtils.parseSources(sources, client);

    for (final SourceFile ref in refs) {
      final Content cnt =
          await igLoader.loadContent(ref.ref, "validate", false, true);
      final List<ValidationMessage> messages = [];
      Element? e;
      try {
        print("Validate ${ref.ref}");
        messages.clear();
        e = await validator.validate(null, messages, cnt.focus, cnt.cntType);
        res.add(ScanOutputItem(ref.ref, null, null,
            ValidatorUtils.messagesToOutcome(messages, client)));
      } catch (ex) {
        res.add(ScanOutputItem(ref.ref, null, null, exceptionToOutcome(ex)));
      }

      if (e != null) {
        final String rt = e.fhirType;
        for (final String u in guides) {
          final ImplementationGuide? ig =
              await client.fetchResource<ImplementationGuide>(u);
          print("Check Guide ${ig?.url}");
          final String? canonical = ig?.url?.contains("/Impl")
              ? ig?.url?.substring(0, ig?.url?.indexOf("/Impl"))
              : ig?.url;
          final String? url = ValidatorUtils.getGlobal(ig, rt);
          if (url != null) {
            try {
              print("Validate ${ref.ref} against ${ig?.url}");
              messages.clear();
              await validator.validate(
                  null, messages, cnt.focus, cnt.cntType, url);
              res.add(ScanOutputItem(ref.ref, ig, null,
                  ValidatorUtils.messagesToOutcome(messages, client)));
            } catch (ex) {
              res.add(
                  ScanOutputItem(ref.ref, ig, null, exceptionToOutcome(ex)));
            }
          }
          final Set<String> done = {};
          final List<StructureDefinition> allStructures =
              await ContextUtilities(client).allStructures();
          for (final StructureDefinition sd in allStructures) {
            if (!done.contains(sd.url)) {
              done.add(sd.url);
              if (sd.url.startsWith(canonical ?? '') && rt == sd.type) {
                try {
                  print("Validate ${ref.ref} against ${sd.url}");
                  messages.clear();
                  await validator
                      .validate(null, messages, cnt.focus, cnt.cntType, [sd]);
                  res.add(ScanOutputItem(ref.ref, ig, sd,
                      ValidatorUtils.messagesToOutcome(messages, client)));
                } catch (ex) {
                  res.add(
                      ScanOutputItem(ref.ref, ig, sd, exceptionToOutcome(ex)));
                }
              }
            }
          }
        }
      }
    }
    return res;
  }

  OperationOutcome exceptionToOutcome(Exception ex) {
    // Conversion of an exception to an OperationOutcome should be implemented based on your project needs
    return OperationOutcome(issue: [
      OperationOutcomeIssue(
        severity: OperationOutcomeIssueSeverity.error,
        code: OperationOutcomeIssueCode.exception,
        details: CodeableConcept(text: 'An error occurred: ${ex.toString()}'),
      )
    ]);
  }

  Future<void> download(String address, String filename) async {
    final response = await http.get(Uri.parse(address));
    if (response.statusCode == 200) {
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);
    } else {
      throw HttpException('Failed to download file from $address');
    }
  }

  void unzip(String zipFilePath, String destDirectory) {
    final bytes = File(zipFilePath).readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File('$destDirectory/$filename')
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory('$destDirectory/$filename').create(recursive: true);
      }
    }
  }

  Future<Resource> fetchFhirResource(String resourcePath) async {
    final file = File(resourcePath);
    final contents = await file.readAsString();
    final resource = json.decode(contents);
    return Resource.fromJson(resource);
  }

  Future<ImplementationGuide> fetchImplementationGuide(String guideUrl) async {
    final file = File(guideUrl);
    final contents = await file.readAsString();
    final guide = json.decode(contents);
    return ImplementationGuide.fromJson(guide);
  }

  Future<List<ImplementationGuide>> fetchImplementationGuides() async {
    final igs = <ImplementationGuide>[];
    return igs;
  }

  // Pseudo-implementation to demonstrate concept
  Future<void> validateFhirResource(
      String resourcePath, List<String> implementationGuides) async {
    final resource = await fetchFhirResource(
        resourcePath); // Fetch the resource, implementation depends on your setup
    final validationMessages = <String>[]; // Collect validation messages

    // Example validation logic; real logic will depend on your validation needs and available libraries
    for (final guideUrl in implementationGuides) {
      final guide = await fetchImplementationGuide(guideUrl);
      final isValid = checkResourceAgainstGuide(resource, guide);

      if (!isValid) {
        validationMessages.add('Resource does not conform to $guideUrl');
      }
    }

    // Process validation messages
    if (validationMessages.isNotEmpty) {
      print('Validation issues found:');
      validationMessages.forEach(print);
    } else {
      print('Resource is valid');
    }
  }

  void generateHtmlReport(List<String> validationMessages, String outputPath) {
    final buffer = StringBuffer()
      ..write('<!DOCTYPE html>')
      ..write('<html><head><title>Validation Report</title></head><body>')
      ..write('<h1>Validation Report</h1>');

    if (validationMessages.isEmpty) {
      buffer.write('<p>No issues found.</p>');
    } else {
      buffer.write('<ul>');
      for (final message in validationMessages) {
        buffer.write('<li>$message</li>');
      }
      buffer.write('</ul>');
    }

    buffer.write('</body></html>');

    File(outputPath).writeAsStringSync(buffer.toString());
  }

  // Assume this setup function prepares your environment.
// It could fetch necessary resources, ensure local copies of IGs are available, etc.
  Future<void> setupValidationEnvironment() async {
    // Implementation-specific setup steps...
  }
// Pseudo-implementation of the validation process
  Future<void> performValidationScan(
      List<String> resourcePaths, String outputDirectory) async {
    final implementationGuides = await fetchImplementationGuides();
    final results = <ValidationResult>[];

    for (final path in resourcePaths) {
      final resource = await fetchFhirResource(path);
      final result = await validateResource(resource, implementationGuides);
      results.add(result);
    }

    generateReport(results,
        outputDirectory); // Generate a report based on validation results
  }

  // Generate an HTML report based on the provided validation results
  void generateReport(List<ValidationResult> results, String outputDirectory) {
    // Use previously discussed `generateHtmlReport` function or a more detailed implementation
  }
}
