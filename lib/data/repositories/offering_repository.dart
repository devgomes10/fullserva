import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/offering.dart';

class OfferingRepository {
  late String uidOffering;
  late CollectionReference offeringCollection;
  FirebaseFirestore db = FirebaseFirestore.instance;

  OfferingRepository() {
    uidOffering = FirebaseAuth.instance.currentUser!.uid;
    offeringCollection =
        FirebaseFirestore.instance.collection("offering_$uidOffering");
  }

  Future<void> addOffering(Offering offering) async {
    try {
      await offeringCollection.doc(offering.id).set(offering.toMap());
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<Offering>> getOffering() {
    try {
      return offeringCollection.snapshots().map(
        (snapshot) {
          return snapshot.docs.map(
            (doc) {
              return Offering(
                id: doc["id"],
                name: doc["name"],
                duration: doc["duration"],
                price: doc["price"],
              );
            },
          ).toList();
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateOffering(Offering offering) async {
    try {
      await offeringCollection.doc(offering.id).update(offering.toMap());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeOffering(String offering) async {
    try {
      await offeringCollection.doc(offering).delete();
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getNameByOffering(String id) async {
    try {
      DocumentSnapshot doc = await offeringCollection.doc(id).get();
      if (doc.exists) {
        return doc.get('name');
      } else {
        throw Exception("Offering not found");
      }
    } catch (error) {
      rethrow;
    }
  }
}
