import 'package:flutter/material.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/views/appointment_form_view.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendamentos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppointmentFormView()),
          );

          if (result == true) {
            // Sem a necessidade de chamar _getAppointmentsForDay, pois o StreamBuilder
            // irá atualizar automaticamente com as alterações no stream.
          }
        },
        child: Icon(Icons.add),
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
                // Remova a chamada para o método _getAppointmentsForDay
              });
            },
          ),
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: _controller.getAppointments(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // Filtra os compromissos para o dia selecionado
                  final appointmentsForDay = snapshot.data!
                      .where((appointment) =>
                  appointment.dateTime.year == today.year &&
                      appointment.dateTime.month == today.month &&
                      appointment.dateTime.day == today.day)
                      .toList();

                  return ListView.builder(
                    itemCount: appointmentsForDay.length,
                    itemBuilder: (context, index) {
                      final appointment = appointmentsForDay[index];
                      return ListTile(
                        title: Text(appointment.clientName),
                        subtitle: Text(
                          "${appointment.dateTime.hour}:${appointment.dateTime.minute}",
                        ),
                        // Adicione mais detalhes conforme necessário
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("Erro: ${snapshot.error}");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
