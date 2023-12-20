import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/entities/service.dart';

class ServiceController {
  late String uidService;
  late CollectionReference serviceCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ServiceController() {
    uidService = FirebaseAuth.instance.currentUser!.uid;
    serviceCollection =
        FirebaseFirestore.instance.collection("service_$uidService");
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
              serviceMode: doc["serviceMode"],
              estimatedDuration: doc["estimatedDuration"],
              price: doc["price"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateService(Service updateService) async {
    try {
      final doc = await serviceCollection.doc(updateService.id).get();
      if (doc.exists) {
        await serviceCollection
            .doc(updateService.id)
            .update(updateService.toMap());
      } else {
        // tratar em caso de erro
      }
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<void> removeService(String serviceId) async {
    try {
      await serviceCollection.doc(serviceId).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
