import 'validation.dart';

class ValidationRecord {
  String location;
  List<ValidationMessage> messages;
  int err = 0;
  int warn = 0;
  int info = 0;

  ValidationRecord(this.location, this.messages) {
    for (var vm in messages) {
      if (vm.level == IssueSeverity.fatal || vm.level == IssueSeverity.error) {
        err++;
      } else if (vm.level == IssueSeverity.warning) {
        warn++;
      } else if (!vm.isSignpost) {
        info++;
      }
    }
  }

  int get errCount => err;
  int get warnCount => warn;
  int get infoCount => info;
}
