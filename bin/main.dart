import 'dart:io';

import 'package:nyxx/Vm.dart';

import 'package:remindart/remindart.dart';
import 'package:remindart/command_util.dart';

void main() {
  configureNyxxForVM();
  final token = Platform.environment['REMINDART_TOKEN'];
  final client = Remindart(token);

  client.onReady;
  client.onMessageReceived
      .listen((event) => CommandUtil.executeMessageCommand(event));
}
