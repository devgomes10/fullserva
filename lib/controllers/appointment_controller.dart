import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fullserva/data/repositories/appointment_repository.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/usecases/appointment_usecase.dart';

import '../domain/entities/coworker.dart';

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
}
