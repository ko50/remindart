import 'dart:io';
import 'dart:async';

class TimerUtil {
  DateTime now = DateTime.now();
  final StreamController<DateTime> _timerController =
      StreamController<DateTime>();

  TimerUtil() {
    print('Time Adjusting. Please Wait Just a Little...');
    sleep(Duration(
        seconds: 60 - now.second, microseconds: 1000 - now.millisecond));
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      now = DateTime.now();
      print(now.toIso8601String());
      add(now);
    });
  }

  Function(DateTime) get add => _timerController.sink.add;

  Stream<DateTime> get onTimeUpdate => _timerController.stream;
}
