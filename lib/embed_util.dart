import 'package:nyxx/nyxx.dart';
import 'package:remindart/plan.dart';

const String icon_url =
    'https://cdn.discordapp.com/avatars/731008600339644466/5f0ff6a1967ee907b517f0cbfed8baa9.png?size=128';
final remindart_color = DiscordColor.fromRgb(255, 150, 255);

EmbedBuilder buildEmbedPlan(Plan plan) => EmbedBuilder()
  ..author = (EmbedAuthorBuilder()
    ..iconUrl = icon_url
    ..name = '予定の詳細')
  ..color = remindart_color
  ..title = '予定名: ${plan.name}'
  ..description =
      '説明: ${plan.describe}\n日時: ${plan.scheduledTime.toIso8601String()}'
  ..footer =
      (EmbedFooterBuilder()..text = '予定の時間が来たら起こしてあげますから、それまではゆっくり休んでください！');

EmbedBuilder buildEmbedListedPlan(
    String mode, List<Plan> planList, String authorID) {
  var embed = EmbedBuilder()
    ..author = (EmbedAuthorBuilder()
      ..iconUrl = icon_url
      ..name = '予定のリストアップ')
    ..color = remindart_color
    ..title = mode
    ..footer = (EmbedFooterBuilder()..text = 'わたし…ちゃんとできましたか…？');
  planList.asMap().forEach((index, plan) => embed.addField(
      name: '`${index}.` ${plan.name}',
      content:
          'Info: ${plan.describe}\nTime: ${plan.scheduledTime.toIso8601String()}'));
  return embed;
}

EmbedBuilder buildEmbedHelp() => EmbedBuilder()
  ..author = (EmbedAuthorBuilder()
    ..iconUrl = icon_url
    ..name = 'Remindart じこしょうかい')
  ..color = remindart_color
  ..title = 'わたしはDiscord上で動くリマインダーです！'
  ..description = '```ぷれふぃっくす: reminder```\n'
      '```\n'
      '---------------------------------------------\n'
      ' こまんど  | しようれい                       \n'
      '---------------------------------------------\n'
      ' add      | add <予定名> <説明> 年/月/日 時:分\n'
      '          |                                   \n'
      ' remove   | remove <予定名>                   \n'
      '          |                                   \n'
      ' show     | show <予定名>                     \n'
      '          |                                   \n'
      ' list     | <dose not decided yet>            \n'
      // '          |                                   \n'
      '---------------------------------------------\n'
      '```'
  ..thumbnailUrl = icon_url
  ..footer = (EmbedFooterBuilder()
    ..text = '忘れちゃダメな予定があるとき、もしよければわたしを使っていただけるとうれしいです…！');
