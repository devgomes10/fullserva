import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/data/repositories/appointment_repository.dart';
import 'package:fullserva/views/appointments/appointment_form_view.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../domain/entities/appointment.dart';

class AppointmentView extends StatefulWidget {
  const AppointmentView({Key? key}) : super(key: key);

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  final AppointmentController appointmentController = AppointmentController();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime today;
  CalendarFormat calendarFormat = CalendarFormat.month;
  String locale = 'pt-BR';

  @override
  void initState() {
    super.initState();
    firstDay = DateTime.now().add(const Duration(days: -365));
    lastDay = DateTime.now().add(const Duration(days: 365));
    today = DateTime.now();
  }

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
              firstDay: firstDay,
              lastDay: lastDay,
              focusedDay: today,
              selectedDayPredicate: (day) => isSameDay(today, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  today = focusedDay;
                });
              },
              // eventLoader: (day) {},
              locale: locale,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // calendarFormat: calendarFormat,
              // onFormatChanged: (day) => onFormatChanged(day),
              daysOfWeekVisible: true,
              rowHeight: 35,
            ),
            Expanded(
              child: // Em AppointmentView
              StreamBuilder<List<Appointment>>(
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

                  final appointmentsForDay = appointments
                      .where((appointment) =>
                  appointment.dateTime.year == today.year &&
                      appointment.dateTime.month == today.month &&
                      appointment.dateTime.day == today.day)
                      .toList();

                  return ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: appointmentsForDay.length,
                    itemBuilder: (context, index) {
                      final appointment = appointmentsForDay[index];
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("service")
                            .doc(appointment.serviceId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text('Erro ao carregar o serviço');
                          }

                          final serviceName = snapshot.data?['name'];

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AppointmentFormView(model: appointment),
                                ),
                              );
                            },
                            leading: Text(
                              "${appointment.dateTime.hour}:${appointment.dateTime.minute}",
                            ),
                            title: Text(serviceName ?? 'Serviço não encontrado'),
                            subtitle: Text(appointment.clientName),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          );
                        },
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

