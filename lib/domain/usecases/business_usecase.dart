import 'package:fullserva/domain/entities/business.dart';

abstract class BusinessUseCase {
  Stream<List<Business>> getBusiness();

  Future<void> updateBusiness(Business business);
}