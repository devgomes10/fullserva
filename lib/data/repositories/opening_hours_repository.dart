import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fullserva/domain/entities/opening_hours.dart';

class OpeningHoursRepository {
  late String uidOpeningHours;
  late CollectionReference openingHoursCollection;
  FirebaseFirestore db = FirebaseFirestore.instance;

  OpeningHoursRepository() {
    uidOpeningHours = FirebaseAuth.instance.currentUser!.uid;
    openingHoursCollection = db.collection("opening_hours_$uidOpeningHours");
  }

  Future<void> updateOpeningHours(OpeningHours openingHours) async {
    try {
      await openingHoursCollection.doc(openingHours.id.toString()).set({
        "id": openingHours.id,
        "working": openingHours.working,
        "startTime": openingHours.startTime,
        "endTime": openingHours.endTime,
        "startTimeInterval": openingHours.startTimeInterval,
        "endTimeInterval": openingHours.endTimeInterval,
      });
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<OpeningHours>> getOpeningHours() {
    return openingHoursCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return OpeningHours(
              id: doc["id"],
              working: doc["working"],
              startTime: doc["startTime"],
              endTime: doc["endTime"],
              startTimeInterval: doc["startTimeInterval"],
              endTimeInterval: doc["endTimeInterval"],
            );
          },
        ).toList();
      },
    );
  }
}
