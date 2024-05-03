import 'package:flutter/material.dart';
import 'package:fullserva/data/repositories/appointment_repository.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/usecases/appointment_usecase.dart';

import '../domain/entities/coworker.dart';
import '../domain/entities/offering.dart';

class AppointmentController implements AppointmentUseCase {
  AppointmentRepository appointmentRepository = AppointmentRepository();

  @override
  Future<void> addAppointment(Appointment appointment) async {
    return appointmentRepository.addAppointment(appointment);
  }

  @override
  Stream<List<Appointment>> getAppointments() {
    return appointmentRepository.getAppointments();
  }

  @override
  Future<void> updateAppointment(Appointment appointment) {
    return appointmentRepository.updateAppointment(appointment);
  }

  @override
  Future<void> removeAppointment(String appointment) {
    return appointmentRepository.removeAppointment(appointment);
  }

  @override
  Future<List<Appointment>> getAppointmentsByCoworkerAndDate(Coworker coworker, DateTime date,) {
    return appointmentRepository.getAppointmentsByCoworkerAndDate(coworker, date);
  }

  // @override
  // Future<List<TimeOfDay>> getAvailableTimes(List<Appointment> appointments, Offering selectedOffering,) {
  //   return appointmentRepository.getAvailableTimes(appointments, selectedOffering);
  // }
}
