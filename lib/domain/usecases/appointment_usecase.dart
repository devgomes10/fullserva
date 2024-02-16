import '../../domain/entities/appointment.dart';

abstract class AppointmentUseCase {
  Future<void> addAppointment(Appointment appointment);

  Stream<List<Appointment>> getAppointments();

  Future<void> updateAppointment(Appointment appointment);

  Future<void> removeAppointment(String appointment);
}
