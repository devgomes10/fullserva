import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service.dart';

class ServiceRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addService(Service service) async {
    try {
      await firestore.collection("services").doc(service.id).set(service.toMap());
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Stream<List<Service>> getService() {
    return firestore.collection("services").snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return Service(
            id: doc["id"],
            name: doc["name"],
            duration: doc["duration"],
            price: doc["price"],
          );
        }).toList();
      },
    );
  }

  Future<void> updateService(Service service) async {
    try {
      await firestore.collection("services").doc(service.id).update(service.toMap());
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }

  Future<void> removeService(Service service) async {
    try {
      await firestore.collection("services").doc(service.id).delete();
    } catch (error) {
      print("Erro: $error");
      // Tratar em caso de erro
    }
  }
}