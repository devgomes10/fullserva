import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
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
      // await appointmentCollection.doc(appointment.id).set(appointment.toMap());
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }

  Stream<List<Appointment>> getAppointments() {
    return appointmentCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Appointment(
              id: doc.id,
              clientName: doc['clientName'],
              clientPhone: doc['clientPhone'],
              serviceId: doc['serviceId'],
              dateTime: (doc['datetime'] as Timestamp).toDate(),
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
      // final doc = await appointmentCollection.doc(appointment.id).get();
      // if (doc.exists) {
      //   await appointmentCollection
      //       .doc(appointment.id)
      //       .update(appointment.toMap());
      // } else {
      //   // tratar em caso de erro
      // }
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
      // await appointmentCollection.doc(appointment).delete();
    } catch (error) {
      print("Erro: $error");
      // tratar em caso de erro
    }
  }
}
