import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fullserva/domain/entities/opening_hours.dart';

class OpeningHoursRepository {
  // late String uidWorkingDay;
  late CollectionReference openingHoursCollection;
  FirebaseFirestore db = FirebaseFirestore.instance;

  OpeningHoursRepository() {
    // uidWorkingDay = FirebaseAuth.instance.currentUser!.uid;
    openingHoursCollection = db.collection("opening_hours");
  }

  Future<void> updateOpeningHours(OpeningHours openingHours) async {
    try {
      await openingHoursCollection.doc(openingHours.id.toString()).set({
        "id": openingHours.id,
        "working": openingHours.working,
        "startTime": Timestamp.fromDate(openingHours.startTime.toLocal()),
        "endTime": Timestamp.fromDate(openingHours.endTime.toLocal()),
        "startTimeInterval": Timestamp.fromDate(openingHours.startTimeInterval.toLocal()),
        "endTimeInterval": Timestamp.fromDate(openingHours.endTimeInterval.toLocal()),
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
              startTime: (doc["startTime"] as Timestamp).toDate(),
              endTime: (doc["endTime"] as Timestamp).toDate(),
              startTimeInterval: (doc["startTimeInterval"] as Timestamp).toDate(),
              endTimeInterval: (doc["endTimeInterval"] as Timestamp).toDate(),
            );
          },
        ).toList();
      },
    );
  }
}
