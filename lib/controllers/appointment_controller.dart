import 'package:fullserva/data/repositories/appointment_repository.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/usecases/appointment_usecase.dart';

class AppointmentController implements AppointmentUseCase {
  final AppointmentRepository _appointmentRepository = AppointmentRepository();

  @override
  Future<void> addAppointment(Appointment appointment) {
    return _appointmentRepository.addAppointment(appointment);
  }

  @override
  Stream<List<Appointment>> getAppointments() {
    return _appointmentRepository.getAppointments();
  }

  @override
  Future<void> removeAppointment(String appointment) {
    return _appointmentRepository.removeAppointment(appointment);
  }

  @override
  Future<void> updateAppointment(Appointment appointment) {
    return _appointmentRepository.updateAppointment(appointment);
  }

  Future<List<double>> getAppointmentsCountPerMonth() {
    return _appointmentRepository.getAppointmentsCountPerMonth();
  }
}
