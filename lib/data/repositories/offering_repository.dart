import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/offering.dart';

class OfferingRepository {
  // late String uidService;
  late CollectionReference offeringCollection;
  FirebaseFirestore db = FirebaseFirestore.instance;

  OfferingRepository() {
    // uidService = FirebaseAuth.instance.currentUser!.uid;
    offeringCollection = FirebaseFirestore.instance.collection("offering");
  }

  Future<void> addOffering(Offering offering) async {
    try {
      await offeringCollection.doc(offering.id).set(offering.toMap());
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Stream<List<Offering>> getOffering() {
    return offeringCollection.snapshots().map(
          (snapshot) {
        return snapshot.docs.map(
              (doc) {
            // Convertendo a lista dinâmica para uma lista de strings
            List<String> coworkerIds = List<String>.from(doc["coworkerIds"] ?? []);
            return Offering(
              id: doc.id,
              name: doc["name"],
              duration: doc["duration"],
              price: doc["price"],
              coworkerIds: coworkerIds,
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateOffering(Offering offering) async {
    try {
      await offeringCollection.doc(offering.id).update(offering.toMap());
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Future<void> removeOffering(String offering) async {
    try {
      await offeringCollection.doc(offering).delete();
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }
}
