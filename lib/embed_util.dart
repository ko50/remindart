import 'package:nyxx/nyxx.dart';
import 'package:remindart/plan.dart';

const String icon_url =
    'https://cdn.discordapp.com/avatars/731008600339644466/5f0ff6a1967ee907b517f0cbfed8baa9.png?size=128';

EmbedBuilder buildEmbedPlan(Plan plan) => EmbedBuilder()
  ..author = (EmbedAuthorBuilder()
    ..iconUrl = icon_url
    ..name = '予定の詳細')
  ..color = DiscordColor.fromRgb(255, 150, 255)
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
    ..color = DiscordColor.fromRgb(255, 150, 255)
    ..title = mode
    ..footer = (EmbedFooterBuilder()..text = 'わたし…ちゃんとできましたか…？');
  planList.asMap().forEach((index, plan) => embed.addField(
      name: '`${index}.` ${plan.name}',
      content:
          'Info: ${plan.describe}\nTime: ${plan.scheduledTime.toIso8601String()}'));
  return embed;
}
