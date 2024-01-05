class WorkingDay {
  String day;
  bool working;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? startTimeInterval;
  DateTime? endTimeInterval;

  WorkingDay({
    required this.day,
    required this.working,
    this.startTime,
    this.endTime,
    this.startTimeInterval,
    this.endTimeInterval,
  });
}
