import 'package:fullserva/data/repositories/service_repository.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:fullserva/domain/usecases/service_usecase.dart';

class ServiceController implements ServiceUseCase {
  final ServiceRepository serviceRepository = ServiceRepository();

  @override
  Future<void> addService(Service service) {
    return serviceRepository.addService(service);
  }

  @override
  Stream<List<Service>> getService() {
    return serviceRepository.getService();
  }

  @override
  Future<void> removeService(String service) {
    return serviceRepository.removeService(service);
  }

  @override
  Future<void> updateService(Service service) {
    return serviceRepository.updateService(service);
  }
}