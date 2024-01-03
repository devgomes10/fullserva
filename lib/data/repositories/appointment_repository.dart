import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/appointment.dart';

class AppointmentRepository {
  late CollectionReference appointmentCollection;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AppointmentRepository() {
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
      await appointmentCollection
          .where("name", isEqualTo: appointment)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
