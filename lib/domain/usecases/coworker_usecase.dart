import '../entities/coworker.dart';

abstract class CoworkerUseCase {
  Future<void> addCoworker (Coworker coworker);

  Stream<List<Coworker>> getCoworker();

  Future<void> updateCoworker (Coworker coworker);

  Future<void> removeCoworker (String coworker);
}