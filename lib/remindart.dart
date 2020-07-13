import 'dart:async';

import 'package:nyxx/nyxx.dart';

import 'package:remindart/plan.dart';
import 'package:remindart/timer_util.dart';

// TODO リストアップ処理、キャンセル処理、予定通知処理を追加しよう

class Remindart extends Nyxx {
  static DateTime now = DateTime.now();
  static List<Plan> planList = [];
  final TimerUtil timerUtil = TimerUtil();

  Remindart(String _token) : super(_token) {
    timerUtil.onTimeUpdate.listen((givenTime) {
      now = givenTime;
      planList.forEach((plan) => notifyScheduledTime(plan));
      planList = planList.where((plan) => !plan.done).toList();
    });
  }

  void notifyScheduledTime(Plan plan) {
    if (plan.scheduledTime.difference(now).inSeconds > 60) return;

    plan.channel.send(
      content:
          '<@!${plan.authorID}>さん！起きてください！\n${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}です！ \"${plan.name}\" の時間ですよ！',
    );
    plan.done = true;
  }

  static void addPlan(
      TextChannel channel, String authorID, List<String> contents) {
    if (contents.length < 5) {
      channel.send(content: formattedErrorMessage(authorID, '引数の数が足りていない'));
      return;
    }

    final date = contents[3].split('/');
    final time = contents[4].split(':');

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

    final scheduledTime = decodeTime(date, time);

    if (scheduledTime.difference(now).inSeconds < 0) {
      channel.send(
          content: formattedErrorMessage(authorID, '現在よりも以前の時間で登録しようとするなカス'));
      return;
    }

    planList.add(Plan(
      authorID: authorID,
      name: contents[1],
      body: contents[2],
      scheduledTime: scheduledTime,
      channel: channel,
    ));

    channel.send(
        content:
            '<@!${authorID}>さん！\n${contents[3]}  ${contents[4]}に、予定  \"${contents[1]}\"  を登録しました！');
  }

  static String formattedErrorMessage(String authorID, String errorMessage) =>
      'あばばばば…、 <@!${authorID}> さん！どうやらエラーが起きてしまったようです…。\nエラー内容は、"${errorMessage}" とのことです！';

  static DateTime decodeTime(List<String> date, List<String> time) {
    final year = int.parse(date[0]);
    final month = int.parse(date[1]);
    final day = int.parse(date[2]);

    final hour = int.parse(time[0]);
    final minute = int.parse(time[1]);

    return DateTime(year, month, day, hour, minute, 0);
  }

  @override
  Stream<ReadyEvent> get onReady {
    print('================ Successfully Logged In ================');
    print(now.toIso8601String());

    // ここかコンストラクタ内で予定をデータベースからフェッチするようにする

    return super.onReady;
  }
}
