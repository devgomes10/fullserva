import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/client.dart';

class ClientController {
  late String uidClient;
  late CollectionReference clientCollection;
  FirebaseFirestore firestore;

  ClientController(this.firestore) {
    uidClient = FirebaseAuth.instance.currentUser!.uid;
    clientCollection = firestore.collection("client_$uidClient");
  }

  Future<void> addClient(Client client) async {
    try {
      await clientCollection.doc(client.id).set(client.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<Client>> getClients() {
    return clientCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return Client(
              id: doc.id,
              name: doc["name"],
              phone: doc["phone"],
              appointmentHistory: doc["appointmentHistory"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateClient(Client client) async {
    try {
      final doc = await clientCollection.doc(client.id).get();
      if (doc.exists) {
        await clientCollection.doc(client.id).update(client.toMap());
      } else {
        // tratar em caso de erro
      }
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<void> removeClient(String client) async {
    try {
      await clientCollection.doc(client).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
