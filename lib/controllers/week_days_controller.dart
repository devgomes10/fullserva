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
        id: "Segunda-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: null,
        endTimeInterval: null,
      ),
      WeekDays(
        id: "Terça-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: null,
        endTimeInterval: null,
      ),
      WeekDays(
        id: "Quarta-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: null,
        endTimeInterval: null,
      ),
      WeekDays(
        id: "Quinta-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: null,
        endTimeInterval: null,
      ),
      WeekDays(
        id: "Sexta-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: null,
        endTimeInterval: null,
      ),
      WeekDays(
        id: "Sabádo",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: null,
        endTimeInterval: null,
      ),
      WeekDays(
        id: "Domingo",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: 30,
        startTimeInterval: null,
        endTimeInterval: null,
      ),
    ];

// Adiciona os dias à coleção
    try {
      for (var day in weekDays) {
        await weekDaysRepository
            .weekDaysCollection
            .doc(day.id) // Use o ID como identificador único
            .set(day.toMap());
      }
      print("Dias da semana adicionados com sucesso!");
    } catch (error) {
      print("Erro ao adicionar dias da semana: $error");
    }
  }
}
