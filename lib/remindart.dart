import 'dart:async';

import 'package:nyxx/nyxx.dart';

import 'package:remindart/plan.dart';

class Remindart extends Nyxx {
  DateTime now;
  List<Plan> planList;

  Remindart(String _token) : super(_token) {
    planList = [];
    onMessageReceived.listen((event) => executeMessageCommnad(event));
  }

  // TODO
  final _timeController = StreamController<DateTime>();

  DateTime decodeTime(List<String> time) {
    return DateTime(
      int.parse(time[0]),
      int.parse(time[1]),
      int.parse(time[2]),
      int.parse(time[3]),
      int.parse(time[4]),
    );
  }

  void executeMessageCommnad(MessageReceivedEvent event) {
    final message = event.message;
    final contents = message.content.split(' ');
    final channel = message.channel;
    final authorID = message.author.id.toString();

    if (contents[0] == 'remind') {
      planList.add(Plan(
        authorID: message.author.id.toString(),
        name: contents[1],
        body: contents[2],
        scheduledTime: decodeTime(contents[3].split(':')),
      ));
      channel.send(
          content:
              '<@!${authorID}>\n${contents[3]}に予定 ${contents[1]} を設定しました！');
    }
  }

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
