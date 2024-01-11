import 'package:fullserva/data/repositories/working_day_repository.dart';
import 'package:fullserva/domain/entities/working_day.dart';
import 'package:fullserva/domain/usecases/working_day_usecase.dart';

class WorkingDayController implements WorkingDayUseCase {
  final WorkingDayRepository workingDayRepository = WorkingDayRepository();

  @override
  Stream<List<WorkingDay>> getWorkingDays() {
    return workingDayRepository.getWorkingDays();
  }

  @override
  Future<void> updateWorkingDay(WorkingDay workingDay) {
    return workingDayRepository.updateWorkingDay(workingDay);
  }
}
