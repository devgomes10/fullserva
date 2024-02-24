import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/appointment.dart';

class AppointmentRepository {
  // late String uidAppointment;
  late CollectionReference appointmentCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AppointmentRepository() {
    // uidAppointment = FirebaseAuth.instance.currentUser!.uid;
    appointmentCollection = firestore.collection("appointment");
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
              id: doc["id"],
              clientName: doc["clientName"],
              clientEmail: doc["clientEmail"],
              employeeEmail: doc["employeeEmail"],
              clientPhone: doc["clientPhone"],
              serviceId: doc["serviceId"],
              dateTime: (doc["dateTime"] as Timestamp).toDate(),
              internalObservations: doc["dateTime"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await appointmentCollection.doc(appointment.id).update(appointment.toMap());
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
