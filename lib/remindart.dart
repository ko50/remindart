import 'dart:async';

import 'package:nyxx/nyxx.dart';

import 'package:remindart/plan.dart';

class Remindart extends Nyxx {
  static DateTime now = DateTime.now();
  static List<Plan> planList = [];

  Remindart(String _token) : super(_token) {
    Timer.periodic(Duration(minutes: 1), (Timer t) {
      now = DateTime.now();
      print(now.toIso8601String());

      planList.forEach((plan) => print(plan.name));
    });
  }

  static void addPlan(
      TextChannel channel, String authorID, List<String> contents) {
    if (contents.length < 5) {
      channel.send(content: formattedErrorMessage(authorID, '引数の数が足りていない'));
      return;
    }

    final date = contents[3].split('/');
    final time = contents[4].split(':');
    print('${date.length} / ${time.length}');

    for (var element in date) {
      if (int.tryParse(element) == null || date.length < 3) {
        channel.send(content: formattedErrorMessage(authorID, '日にちの指定が間違っている'));
        return;
      }
    }

    for (var element in time) {
      if (int.tryParse(element) == null ||
          time.length < 2 ||
          int.parse(element) > 60) {
        channel.send(content: formattedErrorMessage(authorID, '時間の指定が間違っている'));
        return;
      }
    }

    // キレそう
    if (now.year > int.parse(date[0]) ||
        (now.year == int.parse(date[0]) &&
            (now.month > int.parse(date[1]) ||
                (now.month == int.parse(date[1]) &&
                    now.day > int.parse(date[2]))))) {
      channel.send(
          content: formattedErrorMessage(authorID, '現在よりも以前の時間で登録しようとするなカス'));
      return;
    }

    planList.add(Plan(
      authorID: authorID,
      name: contents[1],
      body: contents[2],
      date: date,
      time: time,
    ));

    channel.send(
        content:
            '<@!${authorID}>さん！\n${contents[3]}  ${contents[4]}に、予定  \"${contents[1]}\"  を登録しました！');
  }

  static String formattedErrorMessage(String authorID, String errorMessage) =>
      'あばばばば…、 <@!${authorID}> さん！どうやらエラーが起きてしまったようです！\nエラー内容は、"${errorMessage}" とのことです！';

  @override
  Stream<ReadyEvent> get onReady {
    print('================ Successfully Logged In ================');

    // ここかコンストラクタ内で予定をデータベースからフェッチするようにする

    return super.onReady;
  }
}
