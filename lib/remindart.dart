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
      planList.forEach((plan) => plan.notifyScheduledTime(now));
      planList = planList.where((plan) => plan.isNotPast).toList();
    });
  }

  static void addPlan(TextChannel channel, String authorID,
      List<String> commands, DateTime scheduledTime) {
    planList.add(Plan(
      authorID: authorID,
      name: commands[1],
      body: commands[2],
      channel: channel,
      scheduledTime: scheduledTime,
    ));
  }

  @override
  Stream<ReadyEvent> get onReady {
    print('================ Successfully Logged In ================');
    print(now.toIso8601String());

    // ここかコンストラクタ内で予定をデータベースからフェッチするようにする

    return super.onReady;
  }
}
