import 'package:cloud_firestore/cloud_firestore.dart';
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

  Stream<List<Coworker>> getCoworkerByOfferingId(String offeringId) {
    return FirebaseFirestore.instance
        .collection('coworker')
        .where('offeringIds', arrayContains: offeringId)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            List<String> offeringIds =
                List<String>.from(doc["offeringIds"] ?? []);
            return Coworker(
              id: doc["id"],
              name: doc["name"],
              email: doc["email"],
              password: doc["password"],
              phone: doc["phone"],
              startUnavailable: doc["startUnavailable"],
              endUnavailable: doc["endUnavailable"],
              role: doc["role"],
              offeringIds: offeringIds,
            );
          },
        ).toList();
      },
    );
  }
}