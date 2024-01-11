import 'package:fullserva/domain/entities/working_day.dart';

abstract class WorkingDayUseCase {
  Stream<List<WorkingDay>> getWorkingDays();

  Future<void> updateWorkingDay(WorkingDay workingDay);
}