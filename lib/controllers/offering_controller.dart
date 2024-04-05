import 'package:fullserva/data/repositories/offering_repository.dart';
import 'package:fullserva/domain/entities/offering.dart';
import 'package:fullserva/domain/usecases/offering_usecase.dart';

class OfferingController implements OfferingUseCase {
  OfferingRepository offeringRepository = OfferingRepository();

  @override
  Future<void> addOffering(Offering offering) {
    return offeringRepository.addOffering(offering);
  }

  @override
  Stream<List<Offering>> getOfferings() {
    return offeringRepository.getOffering();
  }

  @override
  Future<void> updateOffering(Offering offering) {
    return offeringRepository.updateOffering(offering);
  }

  @override
  Future<void> removeOffering(String offering) {
    return offeringRepository.removeOffering(offering);
  }
}