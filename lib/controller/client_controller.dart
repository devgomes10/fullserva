// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../domain/entities/client.dart';
//
// class ClientController {
//   late String uidClient;
//   late CollectionReference clientCollection;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   ClientController() {
//     uidClient = FirebaseAuth.instance.currentUser!.uid;
//     clientCollection =
//         FirebaseFirestore.instance.collection("client_$uidClient");
//   }
//
//   Future<void> addClient(Client client) async {
//     try {
//       await clientCollection.doc(client.id).set(client.toMap());
//     } catch (error) {
//       print("Erro: $error");
//       // tratar em caso de erro
//     }
//   }
//
//   Stream<List<Client>> getClients() {
//     return clientCollection.snapshots().map(
//       (snapshot) {
//         return snapshot.docs.map(
//           (doc) {
//             return Client(
//               id: doc.id,
//               name: doc["name"],
//               phone: doc["phone"],
//               email: doc["email"],
//               appointmentHistory: doc["appointmentHistory"],
//               address: doc["address"],
//             );
//           },
//         ).toList();
//       },
//     );
//   }
//
//   Future<void> updateClient(Client updateClient) async {
//     try {
//       final doc = await clientCollection.doc(updateClient.id).get();
//       if (doc.exists) {
//         await clientCollection
//             .doc(updateClient.id)
//             .update(updateClient.toMap());
//       } else {
//         // tratar em caso de erro
//       }
//     } catch (error) {
//       print("Erro: $error");
//       // tratar em caso de erro
//     }
//   }
//
//   Future<void> removeClient(String clientId) async {
//     try {
//       await clientCollection.doc(clientId).delete();
//     } catch (error) {
//       print("Erro: $error");
//       // tratar em caso de erro
//     }
//   }
// }
