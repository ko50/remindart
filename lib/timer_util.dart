import 'dart:async';
class TimerUtil {
  final StreamController<DateTime> _timerController = StreamController<DateTime>();
  
  Stream<DateTime> get onTimeUpdate {
    
    return _timerController.stream;
  }
}