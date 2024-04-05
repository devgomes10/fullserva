class OpeningHours {
  int id;
  bool working;
  DateTime startTime;
  DateTime endTime;
  DateTime startTimeInterval;
  DateTime endTimeInterval;

  OpeningHours({
    required this.id,
    required this.working,
    required this.startTime,
    required this.endTime,
    required this.startTimeInterval,
    required this.endTimeInterval,
  });

  // Converting a map to an instance
  OpeningHours.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        working = map["working"],
        startTime = map["startTime"],
        endTime = map["endTime"],
        startTimeInterval = map["startTimeInterval"],
        endTimeInterval = map["endTimeInterval"];

  // Convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "working": working,
      "startTime": startTime,
      "endTime": endTime,
      "startTimeInterval": startTimeInterval,
      "endTimeInterval": endTimeInterval,
    };
  }
}
