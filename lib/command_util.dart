import 'dart:async';

import 'package:nyxx/nyxx.dart';

import 'package:remindart/remindart.dart';
import 'package:remindart/plan.dart';

class CommandUtil {
  CommandUtil.executeMessageCommand(MessageReceivedEvent event) {
    final message = event.message;
    final channel = message.channel;
    final authorID = message.author.id.toString();
    final contents = message.content.split(' ');
    final prefix = contents[0];

    if (prefix == 'remind' && contents.length >= 3) {
      final subCommand = contents[1];
      final orders = contents.sublist(2);

      switch (subCommand) {
        case 'add':
          add(channel, authorID, orders);
          return;
        case 'remove':
          remove(channel, authorID, orders);
          return;
        case 'list':
        case 'show':
      }
    }
  }

  void add(TextChannel chan, String authorID, List<String> orders) {
    final now = Remindart.now;

    if (orders.length < 4) {
      chan.send(content: formattedErrorMessage(authorID, '引数の数が足りていない'));
      return;
    }

    final date = orders[2].split('/');
    final time = orders[3].split(':');

    for (var plan in Remindart.planList) {
      if (plan.name == orders[0] && plan.authorID == authorID) {
        chan.send(
            content: formattedErrorMessage(authorID, '予定名が重複しているため登録できませんでした'));
        return;
      }
    }

    for (var element in date) {
      if (int.tryParse(element) == null || date.length < 3) {
        chan.send(content: formattedErrorMessage(authorID, '日にちの指定が間違っている'));
        return;
      }
    }

    for (var element in time) {
      if (int.tryParse(element) == null ||
          time.length < 2 ||
          int.parse(element) > 60) {
        chan.send(content: formattedErrorMessage(authorID, '時間の指定が間違っている'));
        return;
      }
    }

    final scheduledTime = decodeTime(date, time);

    if (scheduledTime.difference(now).inSeconds < 0) {
      chan.send(
          content: formattedErrorMessage(authorID, '現在よりも以前の時間で登録しようとするなカス'));
      return;
    }

    Remindart.addPlan(chan, authorID, orders, scheduledTime);
    chan.send(
        content:
            '<@!${authorID}>さん！\n${orders[2]}  ${orders[3]}に、予定  \"${orders[0]}\"  を登録しました！');
  }

  void remove(TextChannel chan, String authorID, List<String> orders) {
    final name = orders[0];
    var selectedPlan =
        Remindart.planList.singleWhere((plan) => plan.name == name);
    final index = Remindart.planList.indexOf(selectedPlan);
    Remindart.removePlan(index);
    chan.send(content: '<@!${authorID}>さん！\n"予定 \"${name}\" は正常に削除されました"、だそうです！');
  }

  String formattedErrorMessage(String authorID, String errorMessage) =>
      'あばばばば…、 <@!${authorID}> さん！ど、どうやらエラーが起きてしまったようです…。\nエラーの内容によると、"${errorMessage}" だそうです！';

  // 正規表現でバリデーションチェックして DateTime.parse(String) でやった方がよい
  DateTime decodeTime(List<String> date, List<String> time) {
    final year = int.parse(date[0]);
    final month = int.parse(date[1]);
    final day = int.parse(date[2]);

    final hour = int.parse(time[0]);
    final minute = int.parse(time[1]);

    return DateTime(year, month, day, hour, minute, 0);
  }
}
