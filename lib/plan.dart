class Plan {
  String authorID;
  String name;
  String body;
  DateTime scheduledTime;

  Plan(
      {this.authorID,
      this.name,
      this.body,
      List<String> date,
      List<String> time}) {
    scheduledTime = decodeTime(date, time);
  }

  DateTime decodeTime(List<String> date, List<String> time) {
    final year = int.parse(date[0]);
    final month = int.parse(date[1]);
    final day = int.parse(date[2]);

    final hour = int.parse(time[0]);
    final minute = int.parse(time[1]);

    return DateTime(year, month, day, hour, minute);
  }
}
