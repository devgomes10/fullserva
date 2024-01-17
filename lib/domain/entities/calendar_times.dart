class CalendarTimes {
  String id;
  bool working;
  DateTime startTime;
  DateTime endTime;
  Duration appointmentInterval;
  List<Map<String, DateTime>>? breakTimes;

  CalendarTimes({
    required this.id,
    required this.working,
    required this.startTime,
    required this.endTime,
    required this.appointmentInterval,
    this.breakTimes,
  });

  CalendarTimes.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        working = map["working"],
        startTime = map["startTime"],
        endTime = map["endTime"],
        appointmentInterval = map["appointmentInterval"],
        breakTimes = map["breakTimes"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "working": working,
      "startTime": startTime,
      "endTime": endTime,
      "appointmentInterval": appointmentInterval.inMinutes,
      "breakTimes": breakTimes,
    };
  }
}
