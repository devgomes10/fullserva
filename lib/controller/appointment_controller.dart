import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/entities/appointment.dart';

class AppointmentController {
  late String uidAppointment;
  late CollectionReference appointmentCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AppointmentController() {
    uidAppointment = FirebaseAuth.instance.currentUser!.uid;
    appointmentCollection =
        FirebaseFirestore.instance.collection("appointment_$uidAppointment");
  }

  Future<void> addAppointment(Appointment appointment) async {
    try {
      await appointmentCollection.doc(appointment.id).set(appointment.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<Appointment>> getAppointments() {
    return appointmentCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return Appointment(
              id: doc.id,
              client: doc['client'],
              employee: doc['employee'],
              service: doc['service'],
              dateTime: doc['datetime'],
              paid: doc['paid'],
              complete: doc['complete'],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateAppointment(Appointment updatedAppointment) async {
    try {
      final doc = await appointmentCollection.doc(updatedAppointment.id).get();
      if (doc.exists) {
        await appointmentCollection
            .doc(updatedAppointment.id)
            .update(updatedAppointment.toMap());
      } else {
        // tratar em caso de erro
      }
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<void> removeAppointment(String appointmentId) async {
    try {
      await appointmentCollection.doc(appointmentId).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
