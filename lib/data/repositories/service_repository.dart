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
            estimatedDuration: doc["estimatedDuration"],
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



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../domain/entities/service.dart';
//
// class ServiceRepository {
//   late String uidService;
//   late CollectionReference serviceCollection;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   ServiceRepository() {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       uidService = user.uid;
//       serviceCollection = FirebaseFirestore.instance.collection("services_$uidService");
//     } else {
//       print("usuário não está autenticado");
//       throw Exception("Usuário não está autenticado");
//     }
//   }
//
//   Future<void> addService(Service service) async {
//     try {
//       await serviceCollection.doc(service.id).set(service.toMap());
//     } catch (error) {
//       print("Erro: $error");
//       // Tratar em caso de erro
//     }
//   }
//
//   Stream<List<Service>> getService() {
//     return serviceCollection.snapshots().map(
//       (snapshot) {
//         return snapshot.docs.map((doc) {
//           return Service(
//             id: doc["id"],
//             name: doc["name"],
//             estimatedDuration: doc["estimatedDuration"],
//             price: doc["price"],
//           );
//         }).toList();
//       },
//     );
//   }
//
//   Future<void> updateService(Service service) async {
//     try {
//       await serviceCollection.doc(service.id).update(service.toMap());
//     } catch (error) {
//       print("Erro: $error");
//       // Tratar em caso de erro
//     }
//   }
//
//
//   Future<void> removeService(Service service) async {
//     try {
//       await serviceCollection.doc(service.id).delete();
//     } catch (error) {
//       print("Erro: $error");
//       // Tratar em caso de erro
//     }
//   }
// }
//
