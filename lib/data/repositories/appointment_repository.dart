import 'dart:async';

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

  Stream<int> getTotalAppointmentByMonth(DateTime selectedDate) {
    DateTime startOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime endOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 1);

    // Cria um StreamController para emitir o valor total
    StreamController<int> controller = StreamController<int>();

    // Consulta Firestore para recuperar os agendamentos dentro do intervalo de datas
    appointmentCollection
        .where('dateTime', isGreaterThanOrEqualTo: startOfMonth, isLessThan: endOfMonth)
        .snapshots()
        .listen((QuerySnapshot snapshot) {

      // Calcula o total de agendamentos
      int total = snapshot.docs.length;

      // Emite o total para o stream
      controller.add(total);
    });

    // Retorna o stream do controller
    return controller.stream;
  }
}
