import 'package:fullserva/domain/entities/calendar_times.dart';

abstract class CalendarTimesUseCase {
  Stream<List<CalendarTimes>> getCalendarTimes();

  Future<void> updateCalendarTimes(CalendarTimes calendarTimes);
}