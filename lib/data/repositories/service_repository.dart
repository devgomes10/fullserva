import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/service.dart';

class ServiceRepository {
  late String uidService;
  late CollectionReference serviceCollection;
  FirebaseFirestore firestore;

  ServiceRepository(this.firestore) {
    // Creating a unique identifier
    uidService = FirebaseAuth.instance.currentUser!.uid;
    serviceCollection = firestore.collection("service_$uidService");
  }

  Future<void> addService(Service service) async {
    try {
      await serviceCollection.doc(service.id).set(service.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<Service>> getService() {
    return serviceCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return Service(
              id: doc.id,
              name: doc["name"],
              employee: doc["employee"],
              description: doc["description"],
              estimatedDuration: doc["estimatedDuration"],
              price: doc["price"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateService(Service service) async {
    try {
      final doc = await serviceCollection.doc(service.id).get();
      if (doc.exists) {
        await serviceCollection
            .doc(service.id)
            .update(service.toMap());
      } else {
        // tratar em caso de erro
      }
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<void> removeService(String service) async {
    try {
      await serviceCollection.doc(service).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
