import 'dart:io';

import 'package:nyxx/Vm.dart';
import 'package:nyxx/nyxx.dart';

import 'package:remindart/remindart.dart';

void executeMessageCommand(MessageReceivedEvent event) {
  final message = event.message;
  final contents = message.content.split(' ');
  final channel = message.channel;
  final authorID = message.author.id.toString();

  if (contents[0] == 'remind') Remindart.addPlan(channel, authorID, contents);
}

void main() {
  configureNyxxForVM();
  final token = Platform.environment['REMINDART_TOKEN'];
  final client = Remindart(token);

  client.onReady;
  client.onMessageReceived.listen((event) => executeMessageCommand(event));
}
