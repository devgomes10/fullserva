class WorkingDay {
  String day;
  bool working;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? startTimeInterval;
  DateTime? endTimeInterval;
  List<DateTime> availableSlots = [];

  WorkingDay({
    required this.day,
    required this.working,
    this.startTime,
    this.endTime,
    this.startTimeInterval,
    this.endTimeInterval,
  });

  void generateAvailableSlots() {
    availableSlots.clear();
    if (working && startTime != null && endTime != null) {
      DateTime currentTime =
          DateTime.utc(0, 1, 1, startTime!.hour, startTime!.minute);
      DateTime endTime =
          DateTime.utc(0, 1, 1, this.endTime!.hour, this.endTime!.minute);

      while (currentTime.isBefore(endTime)) {
        availableSlots.add(currentTime);
        currentTime = currentTime.add(Duration(minutes: getSlotDuration()));
      }
    }
  }

  bool hasAvailability(DateTime appointmentStartTime, int appointmentDuration) {
    if (!working) {
      return false; // O dia não está marcado como dia de trabalho
    }

    DateTime appointmentEndTime =
    appointmentStartTime.add(Duration(minutes: appointmentDuration));

    if (startTime == null || endTime == null) {
      return false; // O horário de funcionamento não está configurado
    }

    if (appointmentStartTime.isBefore(startTime!) ||
        appointmentEndTime.isAfter(endTime!)) {
      return false; // O agendamento começa antes ou termina após o horário de funcionamento
    }

    if (startTimeInterval != null && endTimeInterval != null) {
      // Verificar se o agendamento está dentro do intervalo, se houver
      if (appointmentStartTime.isBefore(startTimeInterval!) ||
          appointmentEndTime.isAfter(endTimeInterval!)) {
        return false; // O agendamento está fora do intervalo
      }
    }

    // Verificar se o agendamento se sobrepõe a slots já ocupados
    for (DateTime slot in availableSlots) {
      DateTime slotEndTime = slot.add(Duration(minutes: getSlotDuration()));

      if ((appointmentStartTime.isBefore(slotEndTime) &&
          appointmentEndTime.isAfter(slot)) ||
          (slot.isBefore(appointmentEndTime) &&
              slotEndTime.isAfter(appointmentStartTime))) {
        return false; // O agendamento se sobrepõe a um slot ocupado
      }
    }

    return true; // O agendamento é possível dentro do horário de atendimento
  }


  int getSlotDuration() {
    return 15;
  }
}
