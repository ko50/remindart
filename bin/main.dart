import 'dart:io';

import 'package:nyxx/Vm.dart';
import 'package:nyxx/nyxx.dart';
import 'package:remindart/command_util.dart';

import 'package:remindart/remindart.dart';

void executeMessageCommand(
    MessageReceivedEvent event, CommandUtil commandUtil) {
  final message = event.message;
  final contents = message.content.split(' ');
  final channel = message.channel;
  final authorID = message.author.id.toString();
  final prefix = contents[0];

  if (prefix == 'remind' && contents.length >= 2) {
    final commands = contents.sublist(1);

    switch (commands[0]) {
      case 'add': commandUtil.Add(channel, authorID, commands); break;
      // case
    }
  }
}

void main() {
  configureNyxxForVM();
  final token = Platform.environment['REMINDART_TOKEN'];
  final client = Remindart(token);
  final commandUtil = CommandUtil();

  client.onReady;
  client.onMessageReceived
      .listen((event) => executeMessageCommand(event, commandUtil));
}
