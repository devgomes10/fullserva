import '../entities/client.dart';

abstract class ClientUseCase {
  Future<void> addClient(Client client);

  Stream<List<Client>> getClients();

  Future<void> updateClient(Client client);

  Future<void> removeClient(String client);
}