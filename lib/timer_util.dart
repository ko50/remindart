import 'dart:io';
import 'dart:async';

class TimerUtil {
  DateTime now = DateTime.now();
  final StreamController<DateTime> _timerController =
      StreamController<DateTime>();

  TimerUtil() {
    sleep(Duration(seconds: 60 - now.second));
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      now = DateTime.now();
      add(now);
      print(now.toIso8601String());
    });
  }

  Function(DateTime) get add => _timerController.sink.add;

  Stream<DateTime> get onTimeUpdate => _timerController.stream;
}
