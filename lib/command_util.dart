import 'package:nyxx/nyxx.dart';

import 'package:remindart/remindart.dart';

class CommandUtil {
  Function(TextChannel, String, List<String>) get Add => add;

  void add(TextChannel channel, String authorID, List<String> commands) {
    final now = Remindart.now;

    if (commands.length < 5) {
      channel.send(content: formattedErrorMessage(authorID, '引数の数が足りていない'));
      return;
    }

    final date = commands[3].split('/');
    final time = commands[4].split(':');

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

    Remindart.addPlan(channel, authorID, commands, scheduledTime);
    channel.send(
        content:
            '<@!${authorID}>さん！\n${commands[3]}  ${commands[4]}に、予定  \"${commands[1]}\"  を登録しました！');
  }

  String formattedErrorMessage(String authorID, String errorMessage) =>
      'あばばばば…、 <@!${authorID}> さん！どうやらエラーが起きてしまったようです…。\nエラー内容は、"${errorMessage}" とのことです！';

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
