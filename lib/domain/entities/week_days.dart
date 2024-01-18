class WeekDays {
  String? id;
  bool working;
  DateTime startTime;
  DateTime endTime;
  DateTime? startTimeInterval;
  DateTime? endTimeInterval;
  int appointmentInterval;

  WeekDays({
    this.id,
    required this.working,
    required this.startTime,
    required this.endTime,
    this.startTimeInterval,
    this.endTimeInterval,
    required this.appointmentInterval,
  });

  // Converting a map to an instance
  WeekDays.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        working = map["working"],
        startTime = map["startTime"],
        endTime = map["endTime"],
        startTimeInterval = map["startTimeInterval"],
        endTimeInterval = map["endTimeInterval"],
        appointmentInterval = map["appointmentInterval"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "working": working,
      "startTime": startTime,
      "endTime": endTime,
      "startTimeInterval": startTimeInterval,
      "endTimeInterval": endTimeInterval,
      "appointmentInterval": appointmentInterval,
    };
  }
}
