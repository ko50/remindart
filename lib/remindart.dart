import 'dart:async';

import 'package:nyxx/nyxx.dart';

class Remindart extends Nyxx {

  Remindart(String _token) : super(_token);

  // TODO
  final _timeController = StreamController<DateTime>();

  DateTime now;
  

  @override
  Stream<ReadyEvent> get onReady {
    print('================ Successfully Logged In ================');
    // TODO 予定をデータベースからフェッチするようにする
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      now = DateTime.now();
      print(now.toIso8601String());
    });

    return super.onReady;
  }
}
