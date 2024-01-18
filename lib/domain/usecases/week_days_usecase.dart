import 'package:fullserva/domain/entities/week_days.dart';

abstract class WeekDaysUseCase {
  Stream<List<WeekDays>> getWeekDays();

  Future<void> updateWeekDays(WeekDays weekDays);
}