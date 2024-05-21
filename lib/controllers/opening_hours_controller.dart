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
}