import 'package:fullserva/data/repositories/opening_hours_repository.dart';
import 'package:fullserva/domain/entities/opening_hours.dart';
import 'package:fullserva/domain/usecases/opening_hours_usecase.dart';

class OpeningHoursController implements OpeningHoursUseCase {
  final OpeningHoursRepository openingHoursRepository =
  OpeningHoursRepository();

  @override
  Stream<List<OpeningHours>> getOpeningHours() {
    return openingHoursRepository.getOpeningHours();
  }

  @override
  Future<void> updateOpeningHours(OpeningHours openingHours) {
    return openingHoursRepository.updateOpeningHours(openingHours);
  }

  Future<void> setupInitialOpeningHours() async {

    // Cria uma lista de dias da semana
    final openingHours = [
      OpeningHours(
        id: DateTime.monday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      OpeningHours(
        id: DateTime.tuesday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      OpeningHours(
        id: DateTime.wednesday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      OpeningHours(
        id: DateTime.thursday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      OpeningHours(
        id: DateTime.friday,
        working: true,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      OpeningHours(
        id: DateTime.saturday,
        working: false,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
      OpeningHours(
        id: DateTime.sunday,
        working: false,
        startTime: DateTime(2024, 1, 16, 9),
        endTime: DateTime(2024, 1, 16, 17),
        startTimeInterval: DateTime(2024, 1, 1, 12),
        endTimeInterval: DateTime(2024, 1, 1, 13),
      ),
    ];

    try {
      for (var day in openingHours) {
        await openingHoursRepository
            .openingHoursCollection
            .doc(day.id.toString())
            .set(day.toMap());
      }
      print("Dias da semana adicionados com sucesso!");
    } catch (error) {
      print("Erro ao adicionar dias da semana: $error");
    }
  }
}
