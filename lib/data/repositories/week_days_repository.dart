import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fullserva/domain/entities/week_days.dart';

class WeekDaysRepository {
  // late String uidWorkingDay;
  late CollectionReference weekDaysCollection;
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  WeekDaysRepository() {
    // uidWorkingDay = FirebaseAuth.instance.currentUser!.uid;
    weekDaysCollection = firebase.collection("week_days");
  }

  Future<void> updateWeekDays(WeekDays weekDays) async {
    try {
      await weekDaysCollection.doc(weekDays.id.toString()).set(weekDays.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<WeekDays>> getWeekDays() {
    return weekDaysCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return WeekDays(
              id: doc["id"],
              working: doc["working"],
              startTime: (doc["startTime"] as Timestamp).toDate(),
              endTime: (doc["endTime"] as Timestamp).toDate(),
              startTimeInterval: (doc["startTimeInterval"] as Timestamp).toDate(),
              endTimeInterval: (doc["endTimeInterval"] as Timestamp).toDate(),
              appointmentInterval: doc["appointmentInterval"],
            );
          },
        ).toList();
      },
    );
  }
}
