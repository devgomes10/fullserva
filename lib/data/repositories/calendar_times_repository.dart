import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fullserva/domain/entities/calendar_times.dart';

class CalendarTimesRepository {
  // late String uidWorkingDay;
  late CollectionReference calendarTimesCollection;
  FirebaseFirestore firebase = FirebaseFirestore.instance;

  CalendarTimesRepository() {
    // uidWorkingDay = FirebaseAuth.instance.currentUser!.uid;
    calendarTimesCollection = firebase.collection("calendar_times");
  }

  Future<void> updateCalendarTimes(CalendarTimes calendarTimes) async {
    try {
      await calendarTimesCollection.get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.update(calendarTimes.toMap());
        }
      });
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<CalendarTimes>> getCalendarTimes() {
    return calendarTimesCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return CalendarTimes(
              id: doc["id"],
              working: doc["working"],
              startTime: doc["startTime"],
              endTime: doc["endTime"],
              appointmentInterval: doc["appointmentInterval"],
              breakTimes: doc["breakTimes"],
            );
          },
        ).toList();
      },
    );
  }
}
