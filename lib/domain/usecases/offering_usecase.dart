import '../entities/offering.dart';

abstract class OfferingUseCase {
  Future<void> addOffering(Offering offering);

  Stream<List<Offering>> getOfferings();

  Future<void> updateOffering(Offering offering);

  Future<void> removeOffering(String offering);
}