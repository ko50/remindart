import 'dart:io';

import 'package:nyxx/Vm.dart';

import 'package:remindart/remindart.dart';

void main() {
  configureNyxxForVM();
  final token = Platform.environment['REMINDART_TOKEN'];
  final remindart = Remindart(token);

  remindart.onReady;
  remindart.onMessage;
}
