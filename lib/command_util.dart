import 'package:nyxx/nyxx.dart';

import 'package:remindart/remindart.dart';
import 'package:remindart/embed_util.dart';
import 'package:remindart/plan.dart';

class CommandUtil {
  CommandUtil.executeMessageCommand(MessageReceivedEvent event) {
    if (event.message.author.bot) return;

    final message = event.message;
    final chan = message.channel;
    final authorID = message.author.id.toString();
    final contents = message.content.split(' ');
    final prefix = contents[0];

    if (prefix == '<@!731008600339644466>' &&
        contents.length == 2 &&
        contents[1] == 'help') help(chan);

    if (prefix == 'reminder' && contents.length >= 3) {
      final subCommand = contents[1];
      final orders = contents.sublist(2);

      switch (subCommand) {
        case 'add':
          add(chan, authorID, orders);
          return;
        case 'remove':
          remove(chan, authorID, orders.join(' '));
          return;
        case 'show':
          show(chan, authorID, orders);
          return;
        case 'list':
          list(chan, authorID, orders);
          return;
      }
    }
  }

  // エラー判定は関数化できますよね？やれ
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

  void remove(TextChannel chan, String authorID, String name) {
    final planList = Remindart.planList;
    final matchedPlan = planList
        .where((plan) => plan.name == name && plan.authorID == authorID)
        .toList();
    if (planList.isEmpty || matchedPlan.isEmpty) {
      chan.send(content: formattedErrorMessage(authorID, '存在しない予定は削除できません'));
      return;
    }

    var selectedPlan = matchedPlan.first;
    final index = planList.indexOf(selectedPlan);
    Remindart.removePlan(index);
    chan.send(content: '<@!${authorID}>さん！\n予定 \"${name}\" は正常に削除されたみたいです！');
  }

  void show(TextChannel chan, String authorID, List<String> orders) {
    var settedAuthorID = authorID;
    final planName = orders.first;

    if (orders.length > 2) {
      switch (orders[1]) {
        case '-u':
        case '--user':
          settedAuthorID = orders[2];
      }
    }

    final planList = Remindart.planList;
    final matchedPlan = planList
        .where(
            (plan) => plan.name == planName && plan.authorID == settedAuthorID)
        .toList();
    if (planList.isEmpty || matchedPlan.isEmpty) {
      chan.send(
          content: formattedErrorMessage(
              authorID, '該当する予定が存在しません  IDを `-u` か `--user` で指定してみてください'));
      return;
    }

    var selectedPlan = matchedPlan.first;
    chan.send(embed: buildEmbedPlan(selectedPlan));
  }

  // TODO †実装†
  void list(TextChannel chan, String authorID, List<String> orders) {}

  void help(TextChannel chan) {
    chan.send(embed: buildEmbedHelp());
  }

  String formattedErrorMessage(String authorID, String errorMessage) =>
      'あばばばばば…、 <@!${authorID}> さん！ど、どうやらエラーが起きてしまったようです…。\nエラーの内容によると、"${errorMessage}" だそうです！';

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
