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
      await appointmentCollection.add(appointment.toMap());
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
              clientName: doc['clientName'],
              clientPhone: doc['clientPhone'],
              serviceId: doc['serviceId'],
              dateTime: (doc['dateTime'] as Timestamp).toDate(),
              internalObservations: doc['internalObservations'],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await appointmentCollection.get().then(
        (snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.update(appointment.toMap());
          }
        },
      );
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

  Future<List<Appointment>> getAppointmentsForDay(DateTime day) async {
    // Consulta no Firestore para obter os agendamentos para o dia especificado
    var querySnapshot = await appointmentCollection
        .where('dateTime', isGreaterThanOrEqualTo: day)
        .where('dateTime', isLessThan: day.add(Duration(days: 1)))
        .get();

    return querySnapshot.docs.map(
          (doc) {
        return Appointment(
          id: doc.id,
          clientName: doc['clientName'],
          clientPhone: doc['clientPhone'],
          serviceId: doc['serviceId'],
          dateTime: (doc['dateTime'] as Timestamp).toDate(),
          internalObservations: doc['internalObservations'],
        );
      },
    ).toList();
  }
}
