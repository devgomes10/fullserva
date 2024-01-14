import 'package:fullserva/data/repositories/appointment_repository.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/usecases/appointment_usecase.dart';

class AppointmentController implements AppointmentUseCase {
  final AppointmentRepository appointmentRepository = AppointmentRepository();

  @override
  Future<void> addAppointment(Appointment appointment) async {
    // List<Appointment> appointmentsForDay =
    //   await appointmentRepository.getAppointmentsForDay(appointment.dateTime);
    //
    // List<DateTime> checkAvailability(
    //     DateTime requestedTime, Duration appointmentDuration) {
    //   // Verificar se o horário solicitado está dentro do horário de funcionamento
    //   if (requestedTime.isBefore(startTime) || requestedTime.isAfter(endTime)) {
    //     print("Horário fora do horário de funcionamento.");
    //     return [];
    //   }
    //
    //   // Verificar se o horário solicitado está dentro de algum intervalo de descanso
    //   for (Map<String, DateTime> breakTime in breakTimes) {
    //     DateTime breakStart = breakTime['start']!;
    //     DateTime breakEnd = breakTime['end']!;
    //
    //     if (requestedTime.isAfter(breakStart) &&
    //         requestedTime.isBefore(breakEnd)) {
    //       print("Horário dentro do intervalo de descanso.");
    //       return [];
    //     }
    //   }
    //
    //   // Consultar agendamentos para o dia especificado
    //   DateTime startOfDay =
    //       DateTime(requestedTime.year, requestedTime.month, requestedTime.day);
    //   DateTime endOfDay = startOfDay.add(Duration(days: 1));
    //   List<Appointment> appointments = appointmentsForDay;
    //
    //   // Verificar se o horário solicitado entra em conflito com os agendamentos existentes
    //   List<DateTime> availableSlots = [];
    //   DateTime currentSlot = startTime;
    //
    //   while (currentSlot.add(appointmentDuration).isBefore(endTime)) {
    //     DateTime endTime = currentSlot.add(appointmentDuration);
    //
    //     bool isSlotFree = true;
    //
    //     // Verificar se o intervalo colide com horários ocupados
    //     for (Appointment appointment in appointments) {
    //       if ((currentSlot.isAfter(appointment.dateTime) &&
    //               endTime.isBefore(
    //                   appointment.dateTime.add(appointmentDuration))) ||
    //           (endTime.isAfter(appointment.dateTime) &&
    //               currentSlot.isBefore(
    //                   appointment.dateTime.add(appointmentDuration)))) {
    //         isSlotFree = false;
    //         break;
    //       }
    //     }
    //
    //     // Se o intervalo for livre, adicionar à lista de horários disponíveis
    //     if (isSlotFree) {
    //       availableSlots.add(currentSlot);
    //     }
    //
    //     // Avançar para o próximo intervalo
    //     currentSlot = currentSlot.add(appointmentInterval);
    //   }
    //
    //   return availableSlots;
    // }
  }

  @override
  Stream<List<Appointment>> getAppointments() {
    return appointmentRepository.getAppointments();
  }

  @override
  Future<void> removeAppointment(String appointment) {
    return appointmentRepository.removeAppointment(appointment);
  }

  @override
  Future<void> updateAppointment(Appointment appointment) {
    return appointmentRepository.updateAppointment(appointment);
  }
}
