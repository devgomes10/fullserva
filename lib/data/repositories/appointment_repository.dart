import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/appointment.dart';

class AppointmentRepository {
  late String uidAppointment;
  late CollectionReference appointmentCollection;
  FirebaseFirestore firestore;

  AppointmentRepository(this.firestore) {
    // Creating a unique identifier
    uidAppointment = FirebaseAuth.instance.currentUser!.uid;
    appointmentCollection = firestore.collection("appointment_$uidAppointment");
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
              clientId: doc['clientId'],
              employeeId: doc['employeeId'],
              serviceId: doc['serviceId'],
              dateTime: (doc['datetime'] as Timestamp).toDate(),
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      final doc = await appointmentCollection.doc(appointment.id).get();
      if (doc.exists) {
        await appointmentCollection
            .doc(appointment.id)
            .update(appointment.toMap());
      } else {
        // tratar em caso de erro
      }
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Future<void> removeAppointment(String appointment) async {
    try {
      await appointmentCollection.doc(appointment).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
