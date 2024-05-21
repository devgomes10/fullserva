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
      rethrow;
    }
  }

  Stream<List<OpeningHours>> getOpeningHours() {
    try {
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
    } catch (error) {
      rethrow;
    }
  }

  Future<void> setupInitialOpeningHours() async {
    // Cria uma lista de dias da semana
    final openingHours = [
      OpeningHours(
        id: DateTime.monday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.tuesday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.wednesday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.thursday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.friday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.saturday,
        working: false,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
      OpeningHours(
        id: DateTime.sunday,
        working: true,
        startTime: 480,
        endTime: 960,
        startTimeInterval: 720,
        endTimeInterval: 780,
      ),
    ];

    try {
      for (var day in openingHours) {
        await openingHoursCollection.doc(day.id.toString()).set(day.toMap());
      }
    } catch (error) {
      rethrow;
    }
  }
}