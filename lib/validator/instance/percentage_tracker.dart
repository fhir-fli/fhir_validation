import 'dart:io';

class PercentageTracker {
  int total;
  int last = 0;
  int current = 0;
  bool log;
  String url;

  static int instance = 0;

  PercentageTracker(this.total, String fhirType, this.url, this.log) {
    instance++;
    if (log) {
      print("Validate $fhirType against $url");
    }
  }

  void done() {
    if (log) {
      print("|");
    }
  }

  String getUrl() {
    return url;
  }

  void seeElement(Element e) {
    if (e.instanceId != instance) {
      e.instanceId = instance;
      current++;
      int pct = total == 0 ? 0 : (current * 100) ~/ total;
      if (pct > last + 2) {
        while (last + 2 < pct) {
          if (log) {
            stdout.write(
                "."); // Using stdout.write to avoid automatic newline of print
          }
          last = last + 2;
          if (last % 20 == 0) {
            if (log) {
              stdout.write("$last"); // Similarly, using stdout.write
            }
          }
        }
      }
    }
  }
}
