import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/business.dart';

class BusinessRepository {
  // late String uidBusiness;
  late CollectionReference businessCollection;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BusinessRepository() {
    // uidBusiness = FirebaseAuth.instance.currentUser!.uid;
    businessCollection = _firestore.collection("business");
  }

  Future<void> updateBusiness(Business business) async {
    try {
      await businessCollection.doc(business.id).update(business.toMap());
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Stream<List<Business>> getBusiness() {
    return businessCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return Business(
              id: doc["id"],
              name: doc["name"],
              email: doc["email"],
              phone: doc["phone"],
              address: doc["address"],
            );
          },
        ).toList();
      },
    );
  }
}
