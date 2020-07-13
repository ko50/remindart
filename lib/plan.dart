import 'package:nyxx/nyxx.dart';

class Plan {
  String authorID;
  String name;
  String body;
  DateTime scheduledTime;
  TextChannel channel;
  bool done = false;

  Plan({this.authorID, this.name, this.body, this.scheduledTime, this.channel});
}
