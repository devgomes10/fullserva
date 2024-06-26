import 'package:fullserva/data/repositories/coworker_repository.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/domain/usecases/coworker_usecase.dart';

class CoworkerController implements CoworkerUseCase {
  CoworkerRepository coworkerRepository = CoworkerRepository();

  @override
  Future<void> addCoworker(Coworker coworker) {
    return coworkerRepository.addCoworker(coworker);
  }

  @override
  Stream<List<Coworker>> getCoworker() {
    return coworkerRepository.getCoworkers();
  }

  @override
  Future<void> updateCoworker(Coworker coworker) {
    return coworkerRepository.updateCoworker(coworker);
  }

  @override
  Future<void> removeCoworker(String coworker) {
    return coworkerRepository.removeCoworker(coworker);
  }
}