import 'package:flutter/material.dart';
import 'package:fullserva/domain/entities/offering.dart';
import '../../domain/entities/appointment.dart';

abstract class AppointmentUseCase {
  Future<void> addAppointment(Appointment appointment);

  Stream<List<Appointment>> getAppointments();

  Future<void> updateAppointment(Appointment appointment);

  Future<void> removeAppointment(String appointment);

Future<List<TimeOfDay>> getAvailableTimes(
    List<Map<String, TimeOfDay>> busyTimes,
    DateTime? selectedDate,
    Offering? selectedOffering,
  );
}
