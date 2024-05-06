import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/data/repositories/offering_repository.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/views/appointments/appointment_form_view.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../domain/entities/appointment.dart';
import '../components/modals/modal_coworkers.dart';

class AppointmentView extends StatefulWidget {
  const AppointmentView({Key? key}) : super(key: key);

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  final AppointmentController _appointmentController = AppointmentController();
  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime today;
  CalendarFormat calendarFormat = CalendarFormat.month;
  String locale = 'pt-BR';
  Coworker? _selectedCoworker;
  late StreamSubscription<List<Appointment>> _subscription;

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  void initState() {
    _subscription = _appointmentController.getAppointments().listen((_) {});
    firstDay = DateTime.now().add(const Duration(days: -365));
    lastDay = DateTime.now().add(const Duration(days: 365));
    today = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("AGENDA"),
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
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                titleTextFormatter: (day, locale) {
                  String formattedText =
                      DateFormat('MMMM yyyy', locale).format(day);
                  return capitalizeFirstLetter(formattedText);
                },
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                dowTextFormatter: (day, locale) =>
                    DateFormat.E(locale).format(day)[0].toUpperCase(),
              ),
              calendarStyle: const CalendarStyle(
                rangeHighlightColor: Colors.yellow,
                outsideDaysVisible: false,
                holidayDecoration: BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
              ),
              // calendarFormat: calendarFormat,
              // onFormatChanged: (day) => onFormatChanged(day),
              daysOfWeekVisible: true,
              rowHeight: 35,
            ),
            const SizedBox(
              height: 14,
            ),
            ElevatedButton(
              onPressed: () async {
                final coworker = await showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => modalCoworkers(
                    context: context,
                  ),
                );
                if (coworker != null) {
                  setState(() {
                    _selectedCoworker = coworker as Coworker;
                  });
                }
              },
              style: ElevatedButton.styleFrom(),
              child: Text(_selectedCoworker?.name ?? "Filtre por um colaborador"),
            ),
            const SizedBox(
              height: 14,
            ),
            // Dentro do método build()
            Expanded(
              child: StreamBuilder<List<Appointment>>(
                stream: _appointmentController.getAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar os dados'));
                  }
                  final appointments = snapshot.data;
                  if (appointments == null || appointments.isEmpty) {
                    return Center(child: Text("Nenhum dado disponível"));
                  }

                  // Filtrar os agendamentos para o dia selecionado
                  var appointmentsForDay = appointments.where((appointment) =>
                  appointment.dateTime.year == today.year &&
                      appointment.dateTime.month == today.month &&
                      appointment.dateTime.day == today.day).toList();

                  // Aplicar filtro por colaborador selecionado, se houver
                  if (_selectedCoworker != null) {
                    appointmentsForDay = appointmentsForDay.where((appointment) =>
                    appointment.coworkerId == _selectedCoworker!.id).toList();
                  }

                  return ListView.separated(
                    separatorBuilder: (_, __) => Divider(),
                    itemCount: appointmentsForDay.length,
                    itemBuilder: (context, index) {
                      final appointment = appointmentsForDay[index];
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("offering_${OfferingRepository().uidOffering}")
                            .doc(appointment.offeringId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Erro ao carregar o serviço');
                          }
                          final serviceName = snapshot.data?['name'];
                          return ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(serviceName ?? 'Serviço não encontrado'),
                                  content: Text(
                                    "Cliente: ${appointment.clientName}\n"
                                        "Data: ${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}\n"
                                        "Horário: ${appointment.dateTime.hour}:${appointment.dateTime.minute}",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Legal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _appointmentController.removeAppointment(appointment.id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Desmarcar"),
                                    )
                                  ],
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
