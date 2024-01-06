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
  final AppointmentController appointmentController = AppointmentController();
  final Map<String, String> serviceNames = {}; // Mapeia IDs de serviço para nomes

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Agendamentos"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AppointmentFormView(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              selectedDayPredicate: (day) => isSameDay(today, day),
              daysOfWeekVisible: true,
              rowHeight: 35,
              focusedDay: today,
              firstDay: DateTime.utc(2000, 01, 01),
              lastDay: DateTime.utc(2030, 01, 01),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  today = focusedDay;
                });
              },
            ),
            Expanded(
              child: StreamBuilder<List<Appointment>>(
                stream: appointmentController.getAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar os dados'),
                    );
                  }
                  final appointments = snapshot.data;
                  if (appointments == null || appointments.isEmpty) {
                    return const Center(
                      child: Text("Nenhum dado disponível"),
                    );
                  }

                  // Mapeia os IDs de serviço para os nomes correspondentes
                  for (var appointment in appointments) {
                    serviceNames[appointment.serviceId] =
                    appointment.serviceId; // Substitua pelo nome real se estiver disponível.
                  }

                  final appointmentsForDay = appointments
                      .where(
                        (appointment) =>
                    appointment.dateTime.year == today.year &&
                        appointment.dateTime.month == today.month &&
                        appointment.dateTime.day == today.day,
                  )
                      .toList();
                  return ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: appointmentsForDay.length,
                    itemBuilder: (context, index) {
                      final appointment = appointmentsForDay[index];
                      return ListTile(
                        leading: Text(
                          "${appointment.dateTime.hour}:${appointment.dateTime.minute}",
                        ),
                        title: Text(
                          serviceNames[appointment.serviceId] ??
                              'Serviço não encontrado',
                        ),
                        subtitle: Text(appointment.clientName),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
