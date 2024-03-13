class TimeTracker {
  List<Session> sessions = [];
  List<Counter> records = [];
  int globalStart = DateTime.now().microsecondsSinceEpoch;
  int _milestone = 0;

  TimeTracker();

  Session start(String name) {
    Counter? c;
    for (var t in records) {
      if (t.name == name) {
        c = t;
        break;
      }
    }

    if (c == null) {
      c = Counter(this, name);
      records.add(c);
    }

    final session = Session(this, name);
    sessions.add(session);
    return session;
  }

  void endSession(Session session) {
    sessions.remove(session);
    Counter? c;
    for (var t in records) {
      if (t.name == session.name) {
        c = t;
        break;
      }
    }

    c!.count++;
    c.length += DateTime.now().microsecondsSinceEpoch - session.start;
  }

  String report() {
    final b = StringBuffer();
    for (var c in records) {
      if (c.count == 1) {
        b.write('${c.name}: ${DurationUtil.presentDuration(c.length)} ');
      }
    }

    for (var c in records) {
      if (c.count > 1) {
        b.write(
            '${c.name}: ${DurationUtil.presentDuration(c.length)} (#${c.count}) ');
      }
    }

    return 'Times: ${b.toString()}';
  }

  String clock() {
    return DurationUtil.presentDuration(
        DateTime.now().microsecondsSinceEpoch - globalStart);
  }

  String instant() {
    return DurationUtil.presentDuration(
        DateTime.now().microsecondsSinceEpoch - globalStart);
  }

  String milestone() {
    final start = _milestone == 0 ? globalStart : _milestone;
    _milestone = DateTime.now().microsecondsSinceEpoch;
    return DurationUtil.presentDuration(_milestone - start);
  }
}

class Session {
  final TimeTracker tracker;
  final String name;
  final int start;

  Session(this.tracker, this.name)
      : start = DateTime.now().microsecondsSinceEpoch;

  void end() {
    tracker.endSession(this);
  }
}

class Counter {
  final TimeTracker tracker;
  final String name;
  int count = 0;
  int length = 0;

  Counter(this.tracker, this.name);
}

class DurationUtil {
  static String presentDuration(int microseconds) {
    // Implement your duration formatting logic here
    return '';
  }
}
