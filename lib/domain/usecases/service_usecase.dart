import '../entities/service.dart';

abstract class ServiceUseCase {
  Future<void> addService(Service service);

  Stream<List<Service>> getService();

  Future<void> updateService(Service service);

  Future<void> removeService(String service);
}