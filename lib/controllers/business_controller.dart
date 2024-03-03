import 'package:fullserva/data/repositories/business_repository.dart';
import 'package:fullserva/domain/entities/business.dart';
import 'package:fullserva/domain/usecases/business_usecase.dart';

class BusinessController implements BusinessUseCase {
  final BusinessRepository _businessRepository = BusinessRepository();

  @override
  Stream<List<Business>> getBusiness() {
    return _businessRepository.getBusiness();
  }

  @override
  Future<void> updateBusiness(Business business) {
    return _businessRepository.updateBusiness(business);
  }
}