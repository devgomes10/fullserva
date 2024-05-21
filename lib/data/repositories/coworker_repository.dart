import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fullserva/domain/entities/coworker.dart';

class CoworkerRepository {
  late String uidCoworker;
  late CollectionReference coworkerCollection;
  FirebaseFirestore db = FirebaseFirestore.instance;

  CoworkerRepository() {
    uidCoworker = FirebaseAuth.instance.currentUser!.uid;
    coworkerCollection = db.collection("coworker_$uidCoworker");
  }

  Future<void> addCoworker(Coworker coworker) async {
    try {
      await coworkerCollection.doc(coworker.id).set(coworker.toMap());
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<Coworker>> getCoworkers() {
    try {
      return coworkerCollection.snapshots().map(
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
                startUnavailable: (doc["startUnavailable"] as Timestamp).toDate(),
                endUnavailable: (doc["endUnavailable"] as Timestamp).toDate(),
                role: doc["role"],
                offeringIds: offeringIds,
              );
            },
          ).toList();
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateCoworker(Coworker coworker) async {
    try {
      await coworkerCollection.doc(coworker.id).update(coworker.toMap());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeCoworker(String coworker) async {
    try {
      await coworkerCollection.doc(coworker).delete();
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<Coworker>> getCoworkerByOfferingId(String offeringId) {
    try {
      return coworkerCollection
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
                startUnavailable: (doc["startUnavailable"] as Timestamp).toDate(),
                endUnavailable: (doc["endUnavailable"] as Timestamp).toDate(),
                role: doc["role"],
                offeringIds: offeringIds,
              );
            },
          ).toList();
        },
      );
    } catch (error) {
      rethrow;
    }
  }
}
