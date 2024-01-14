import 'package:fullserva/data/repositories/calendar_times_repository.dart';
import 'package:fullserva/domain/entities/calendar_times.dart';
import 'package:fullserva/domain/usecases/calendar_times_usecase.dart';

class CalendarTimesController implements CalendarTimesUseCase {
  final CalendarTimesRepository calendarTimesRepository =
      CalendarTimesRepository();

  @override
  Stream<List<CalendarTimes>> getCalendarTimes() {
    return calendarTimesRepository.getCalendarTimes();
  }

  @override
  Future<void> updateCalendarTimes(CalendarTimes calendarTimes) {
    return calendarTimesRepository.updateCalendarTimes(calendarTimes);
  }
}
