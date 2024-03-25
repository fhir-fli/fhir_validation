class ValidationTimeTracker {
  int overall = 0;
  int txTime = 0;
  int sdTime = 0;
  int loadTime = 0;
  int fpeTime = 0;
  int specTime = 0;

  int get overallTime => overall;
  int get transactionTime => txTime;
  int get structureDefinitionTime => sdTime;
  int get loadTimeSpent => loadTime;
  int get fhirPathEngineTime => fpeTime;
  int get specTimeSpent => specTime;

  void load(int start) {
    loadTime += (DateTime.now().microsecondsSinceEpoch * 1000 - start);
  }

  void addToOverall(int start) {
    overall += (DateTime.now().microsecondsSinceEpoch * 1000 - start);
  }

  void tx(int start) {
    int ms = (DateTime.now().microsecondsSinceEpoch * 1000 - start) ~/ 1000000;
    print("tx: $ms");
    txTime += (DateTime.now().microsecondsSinceEpoch * 1000 - start);
  }

  void sd(int start) {
    sdTime += (DateTime.now().microsecondsSinceEpoch * 1000 - start);
  }

  void fpe(int start) {
    fpeTime += (DateTime.now().microsecondsSinceEpoch * 1000 - start);
  }

  void spec(int start) {
    specTime += (DateTime.now().microsecondsSinceEpoch * 1000 - start);
  }

  void reset() {
    overall = 0;
    txTime = 0;
    sdTime = 0;
    loadTime = 0;
    fpeTime = 0;
    specTime = 0;
  }
}
