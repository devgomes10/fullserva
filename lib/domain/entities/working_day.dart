class WorkingDay {
  String id;
  String day;
  bool working;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? startTimeInterval;
  DateTime? endTimeInterval;

  WorkingDay({
    required this.id,
    required this.day,
    required this.working,
    this.startTime,
    this.endTime,
    this.startTimeInterval,
    this.endTimeInterval,
  });

  // Converting a map to an instance
  WorkingDay.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        day = map["day"],
        working = map["working"],
        startTime = map["startTime"],
        endTime = map["endTime"],
        startTimeInterval = map["startTimeInterval"],
        endTimeInterval = map["endTimeInterval"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "day": day,
      "working": working,
      "startTime": startTime,
      "endTime": endTime,
      "startTimeInterval": startTimeInterval,
      "endTimeInterval": endTimeInterval,
    };
  }
}
