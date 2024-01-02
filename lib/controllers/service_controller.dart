import 'package:fullserva/data/repositories/service_repository.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:fullserva/domain/usecases/service_usecase.dart';

class ServiceController implements ServiceUseCase {
  final ServiceRepository _serviceRepository = ServiceRepository();
  
  @override
  Future<void> addService(Service service) {
    return _serviceRepository.addService(service);
  }

  @override
  Stream<List<Service>> getService() {
    return _serviceRepository.getService();
  }

  @override
  Future<void> removeService(Service service) {
    return _serviceRepository.removeService(service);
  }

  @override
  Future<void> updateService(Service service) {
    return _serviceRepository.updateService(service);
  }
}