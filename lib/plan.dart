import 'package:nyxx/nyxx.dart';

class Plan {
  String authorID;
  String name;
  String body;
  DateTime scheduledTime;
  TextChannel chan;
  bool past = false;

  Plan({this.authorID, this.name, this.body, this.scheduledTime, this.chan});

  void notifyScheduledTime(DateTime now) {
    if (scheduledTime.difference(now).inSeconds > 60) return;

    chan.send(
      content:
          '<@!${authorID}>さん！起きてください！\n${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}です！ \"${name}\" の時間ですよ！',
    );
    past = true;
  }

  bool get isNotPast => !past;
}
