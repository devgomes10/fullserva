import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/service.dart';

class ServiceRepository {
  late String uidService;
  late CollectionReference serviceCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ServiceRepository() {
    // uidService = FirebaseAuth.instance.currentUser!.uid;
    serviceCollection = FirebaseFirestore.instance.collection("service");
  }

  Future<void> addService(Service service) async {
    try {
      await serviceCollection.doc(service.id).set(service.toMap());
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Stream<List<Service>> getService() {
    return serviceCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return Service(
              id: doc["id"],
              name: doc["name"],
              duration: doc["duration"],
              price: doc["price"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateService(Service service) async {
    try {
      await serviceCollection.doc(service.id).update(service.toMap());
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Future<void> removeService(String service) async {
    try {
      await serviceCollection.doc(service).delete();
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }
}
