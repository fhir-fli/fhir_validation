import 'dart:io';

class VersionUtil {
  static late final String _ourVersion;
  static late final String _ourBuildNumber;
  static late final String _ourBuildTime;

  static String getBuildNumber() => _ourBuildNumber;
  static String getBuildTime() => _ourBuildTime;
  static String getVersion() => _ourVersion;

  static String getPoweredBy() {
    return 'powered by matchbox $_ourVersion, hapi-fhir ${VersionUtil.getVersion()} and org.hl7.fhir.core ${org.hl7.fhir.validation.cli.utils.VersionUtil.getVersion()}';
  }

  static String getMemory() {
    final ProcessResult result = Process.runSync(
        'java', ['com.sun.management.OperatingSystemMXBean.getProcessCpuLoad']);
    if (result.exitCode == 0) {
      final stdout = result.stdout.toString().trim();
      return 'Memory used $stdout'; // You might need to adjust this based on the actual output format.
    }
    return 'Memory unavailable'; // Handle error case gracefully.
  }

  static void initialize() {
    try {
      final File propertiesFile = File('matchbox-build.properties');
      if (!propertiesFile.existsSync()) {
        throw FileSystemException('Properties file not found');
      }

      final Map<String, String> properties =
          propertiesFile.readAsLinesSync().fold({}, (acc, line) {
        final keyValue = line.split('=');
        if (keyValue.length == 2) {
          acc[keyValue[0].trim()] = keyValue[1].trim();
        }
        return acc;
      });

      _ourVersion = properties['matchbox.version'] ?? '(unknown)';
      _ourBuildNumber = properties['matchbox.buildnumber'] ?? '';
      _ourBuildTime = properties['matchbox.timestamp'] ?? '';
    } catch (e) {
      print('Unable to determine version information: $e');
    }
  }

  static String getVersionString() {
    return 'Version $_ourVersion (Git# ${_ourBuildNumber.substring(0, 12)}). Built $_ourBuildTime';
  }
}
