import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fullserva/domain/entities/working_day.dart';

class WorkingDayRepository {
  // late String uidWorkingDay;
  late CollectionReference workingDayCollection;
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  WorkingDayRepository() {
    // uidWorkingDay = FirebaseAuth.instance.currentUser!.uid;
    workingDayCollection = firebase.collection("working_day");
  }

  Future<void> updateWorkingDay(WorkingDay workingDay) async {
    try {
      await workingDayCollection.get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.update(workingDay.toMap());
        }
      });
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<WorkingDay>> getWorkingDays() {
    return workingDayCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return WorkingDay(
              id: doc["id"],
              day: doc["day"],
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
