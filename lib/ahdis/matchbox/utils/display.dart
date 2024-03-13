import 'dart:io';

import '../matchbox.dart';

class Display {
  static String toMB(int maxMemory) {
    return (maxMemory ~/ (1024 * 1024)).toString();
  }

  static void printCliParamsAndInfo(List<String> args) {
    final currentDir = Directory.current.path;
    final packageCache =
        'N/A'; // There's no direct equivalent for FilesystemPackageCacheManager in Dart

    stdout.writeln(
        '  Paths:  Current = $currentDir, Package Cache = $packageCache');
    stdout.write('  Params:');
    for (final s in args) {
      stdout.write(s.contains(' ') ? ' "$s"' : ' $s');
    }
    stdout.writeln();
  }

  static final String CURLY_START = r'{{';
  static final String CURLY_END = r'}}';

  static String getMoustacheString(final String string) {
    return '$CURLY_START$string$CURLY_END';
  }

  static String replacePlaceholders(
      final String input, final List<List<String>> placeholders) {
    String output = input;
    for (final placeholder in placeholders) {
      output =
          output.replaceAll(getMoustacheString(placeholder[0]), placeholder[1]);
    }
    return output;
  }

  static void displayHelpDetailsFromFile(String file) {
    displayHelpDetails(file, []);
  }

  static void displayHelpDetails(
      String file, final List<List<String>> placeholders) {
    final classUri = Uri.file(Platform.script.path).resolve('Display.dart');
    final helpPath = Uri.file(classUri.resolve('../$file').toFilePath());
    final helpData = File.fromUri(helpPath).readAsStringSync();

    final helpText = replacePlaceholders(helpData, placeholders);

    stdout.writeln(helpText);
  }

  static void displaySystemInfo() {
    final javaVersion = Platform.version;
    final javaHome = Platform.environment['JAVA_HOME'] ?? '';
    final osArch = Platform.operatingSystem;
    final sunArchDataModel = Platform.version;

    final maxMemory = ProcessInfo.maxRss;

    stdout.writeln(
        '  Java:   $javaVersion from $javaHome on $osArch ($sunArchDataModel). ${toMB(maxMemory)}MB available');
  }

  static void displayVersion() {
    final versionString = VersionUtil.getVersionString();
    stdout.writeln('FHIR Validation tool $versionString');
  }
}
