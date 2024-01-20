import 'package:fullserva/data/repositories/week_days_repository.dart';
import 'package:fullserva/domain/entities/week_days.dart';
import 'package:fullserva/domain/usecases/week_days_usecase.dart';

class WeekDaysController implements WeekDaysUseCase {
  final WeekDaysRepository weekDaysRepository =
  WeekDaysRepository();

  @override
  Stream<List<WeekDays>> getWeekDays() {
    return weekDaysRepository.getWeekDays();
  }

  @override
  Future<void> updateWeekDays(WeekDays weekDays) {
    return weekDaysRepository.updateWeekDays(weekDays);
  }

  Future<void> setupInitialWeekDays() async {

    // Cria uma lista de dias da semana
    final weekDays = [
      WeekDays(
        id: DateTime.monday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      WeekDays(
        id: DateTime.tuesday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      WeekDays(
        id: DateTime.wednesday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      WeekDays(
        id: DateTime.thursday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      WeekDays(
        id: DateTime.friday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      WeekDays(
        id: DateTime.saturday,
        working: false,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      WeekDays(
        id: DateTime.sunday,
        working: false,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
    ];

    try {
      for (var day in weekDays) {
        await weekDaysRepository
            .weekDaysCollection
            .doc(day.id.toString()) // Use o ID como identificador único
            .set(day.toMap());
      }
      print("Dias da semana adicionados com sucesso!");
    } catch (error) {
      print("Erro ao adicionar dias da semana: $error");
    }
  }
}
