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

  Future<void> setupInitialCalendarTimes() async {
    // Cria uma lista de dias da semana
    final diasDaSemana = [
      CalendarTimes(
        id: "Segunda-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: Duration(minutes: 30),
        breakTimes: null,
      ),
      CalendarTimes(
        id: "Terça-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: Duration(minutes: 30),
        breakTimes: null,
      ),
      CalendarTimes(
        id: "Quarta-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: Duration(minutes: 30),
        breakTimes: null,
      ),
      CalendarTimes(
        id: "Quinta-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: Duration(minutes: 30),
        breakTimes: null,
      ),
      CalendarTimes(
        id: "Sexta-feira",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: Duration(minutes: 30),
        breakTimes: null,
      ),
      CalendarTimes(
        id: "Sabádo",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: Duration(minutes: 30),
        breakTimes: null,
      ),
      CalendarTimes(
        id: "Domingo",
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        appointmentInterval: Duration(minutes: 30),
        breakTimes: null,
      ),
    ];

// Adiciona os dias à coleção
    try {
      for (var day in diasDaSemana) {
        await CalendarTimesRepository()
            .calendarTimesCollection
            .doc(day.id) // Use o ID como identificador único
            .set(day.toMap());
      }
      print("Dias da semana adicionados com sucesso!");
    } catch (error) {
      print("Erro ao adicionar dias da semana: $error");
    }
  }
}
