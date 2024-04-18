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
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.tuesday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.wednesday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.thursday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.friday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.saturday,
        working: false,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.sunday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
    ];

    try {
      for (var day in openingHours) {
        await openingHoursRepository.openingHoursCollection
            .doc(day.id.toString())
            .set(day.toMap());
      }
      print("Dias da semana adicionados com sucesso!");
    } catch (error) {
      print("Erro ao adicionar dias da semana: $error");
    }
  }
}
