import 'package:nyxx/nyxx.dart';
import 'package:remindart/plan.dart';

EmbedBuilder buildEmbedPlan(Plan plan) => EmbedBuilder()
  ..author = (EmbedAuthorBuilder()..name = '予定の詳細')
  ..color = DiscordColor.fromRgb(255, 150, 255)
  ..title = '予定名: ${plan.name}'
  ..description = '説明: ${plan.describe}'
  ..footer = (EmbedFooterBuilder()
    ..text = 'This Plan was Added by <@!${plan.authorID}>.');

EmbedBuilder buildEmbedListedPlan(
    String mode, List<Plan> planList, String authorID) {
  var embed = EmbedBuilder()
    ..author = (EmbedAuthorBuilder()..name = '予定のリストアップ')
    ..color = DiscordColor.fromRgb(255, 150, 255)
    ..title = mode
    ..footer = (EmbedFooterBuilder()
      ..text = 'Plan List Requiested by <@!${authorID}>.');
  planList.asMap().forEach((index, plan) => embed.addField(
      name: '`${index}.` ${plan.name}',
      content:
          'Info: ${plan.describe}\nRemind: ${plan.scheduledTime.toIso8601String()}'));
  return embed;
}
