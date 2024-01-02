import 'package:flutter/material.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:table_calendar/table_calendar.dart';

import '../domain/entities/appointment.dart';

class AppointmentView extends StatefulWidget {
  const AppointmentView({Key? key}) : super(key: key);

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  DateTime today = DateTime.now();
  final AppointmentController _controller = AppointmentController();
  late List<Appointment> _appointmentsForDay;

  @override
  void initState() {
    super.initState();
    _appointmentsForDay = []; // Inicialize a lista aqui
    _getAppointmentsForDay(today);
  }

  void _getAppointmentsForDay(DateTime day) {
    _controller.getAppointments().listen((appointments) {
      // Filtra os compromissos para o dia selecionado
      setState(() {
        _appointmentsForDay = appointments
            .where((appointment) =>
        appointment.dateTime.year == day.year &&
            appointment.dateTime.month == day.month &&
            appointment.dateTime.day == day.day)
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendamentos"),
      ),
      body: Column(
        children: [
          TableCalendar(
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            daysOfWeekVisible: true,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            rowHeight: 35,
            focusedDay: today,
            firstDay: DateTime.utc(2000, 01, 01),
            lastDay: DateTime.utc(2030, 01, 01),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                today = focusedDay;
                _getAppointmentsForDay(focusedDay);
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _appointmentsForDay.length,
              itemBuilder: (context, index) {
                final appointment = _appointmentsForDay[index];
                return ListTile(
                  title: Text(appointment.clientName),
                  subtitle: Text(
                    "${appointment.dateTime.hour}:${appointment.dateTime.minute}",
                  ),
                  // Adicione mais detalhes conforme necessário
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
