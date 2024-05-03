import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/coworker.dart';
import '../../domain/entities/offering.dart';

class AppointmentRepository {
  // late String uidAppointment;
  late CollectionReference appointmentCollection;
  FirebaseFirestore db = FirebaseFirestore.instance;

  AppointmentRepository() {
    // uidAppointment = FirebaseAuth.instance.currentUser!.uid;
    appointmentCollection = db.collection("appointment");
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
              coworkerId: doc["coworkerId"],
              clientPhone: doc["clientPhone"],
              offeringId: doc["offeringId"],
              dateTime: (doc["dateTime"] as Timestamp).toDate(),
              observations: doc["observations"],
            );
          },
        ).toList();
      },
    );
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      await appointmentCollection
          .doc(appointment.id)
          .update(appointment.toMap());
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

  Future<List<Appointment>> getAppointmentsByCoworkerAndDate(
    Coworker coworker,
    DateTime date,
  ) async {
    try {
      QuerySnapshot querySnapshot = await appointmentCollection
          .where("coworkerId", isEqualTo: coworker.id)
          .where("dateTime",
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                  DateTime(date.year, date.month, date.day, 0, 0, 0)))
          .where("dateTime",
              isLessThanOrEqualTo: Timestamp.fromDate(
                DateTime(date.year, date.month, date.day, 23, 59, 59),
              ))
          .get();

      List<Appointment> appointments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Appointment(
          id: data['id'],
          clientName: data['clientName'],
          coworkerId: data['coworkerId'],
          clientPhone: data['clientPhone'],
          offeringId: data['offeringId'],
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          observations: data['observations'],
        );
      }).toList();

      return appointments;
    } catch (error) {
      print("Erro ao buscar os agendamentos: $error");
      rethrow;
    }
  }
}
