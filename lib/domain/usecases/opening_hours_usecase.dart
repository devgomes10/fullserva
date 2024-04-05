import 'package:fullserva/domain/entities/opening_hours.dart';

abstract class OpeningHoursUseCase {
  Stream<List<OpeningHours>> getOpeningHours();

  Future<void> updateOpeningHours(OpeningHours openingHours);
}