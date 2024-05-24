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
  late StreamSubscription<List<Appointment>> _appointmentsSubscription;

  String locale = 'pt-BR';

  late DateTime firstDay;
  late DateTime lastDay;
  late DateTime focusedDay;
  CalendarFormat calendarFormat = CalendarFormat.month;

  Coworker? _selectedCoworker;
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();
    _initializeDates();
    _appointmentsSubscription = _appointmentController.getAppointments().listen((appointmentList) {
      setState(() {
        appointments = appointmentList;
      });
    });
  }

  @override
  void dispose() {
    _appointmentsSubscription.cancel();
    super.dispose();
  }

  void _initializeDates() {
    firstDay = DateTime.now().subtract(const Duration(days: 365));
    lastDay = DateTime.now().add(const Duration(days: 365));
    focusedDay = DateTime.now();
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return appointments.where((appointment) =>
    appointment.dateTime.year == day.year &&
        appointment.dateTime.month == day.month &&
        appointment.dateTime.day == day.day
    ).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.focusedDay = focusedDay;
    });
  }

  void _showCoworkerSelectionModal() async {
    final coworker = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => modalCoworkers(context: context),
    );
    if (coworker != null) {
      setState(() {
        _selectedCoworker = coworker as Coworker;
      });
    }
  }

  void _showAppointmentDetailsDialog(Appointment appointment, String serviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(serviceName),
        content: Text(
          "Cliente: ${appointment.clientName}\n"
              "Data: ${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year}\n"
              "Horário: ${appointment.dateTime.hour}:${appointment.dateTime.minute}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("AGENDA"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
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
            _buildTableCalendar(),
            const SizedBox(height: 14),
            _buildCoworkerFilterButton(),
            const SizedBox(height: 14),
            _buildAppointmentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(focusedDay, day),
      onDaySelected: _onDaySelected,
      eventLoader: _getAppointmentsForDay,
      locale: locale,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        titleTextFormatter: (day, locale) {
          String formattedText = DateFormat('MMMM yyyy', locale).format(day);
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
      daysOfWeekVisible: true,
      rowHeight: 35,
    );
  }

  Widget _buildCoworkerFilterButton() {
    return ElevatedButton(
      onPressed: _showCoworkerSelectionModal,
      style: ElevatedButton.styleFrom(),
      child: Text(_selectedCoworker?.name ?? "Filtre por um colaborador"),
    );
  }

  Widget _buildAppointmentList() {
    return Expanded(
      child: StreamBuilder<List<Appointment>>(
        stream: _appointmentController.getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Image.asset("assets/error.jpeg", width: 200, height: 200,),
                  const Text("Error ao carregar os agendamentos"),
                ],
              ),
            );
          }
          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) {
            return Column(
              children: [
                Image.asset("assets/empty.jpeg", width: 300, height: 300,),
                const Text("Poxa, ainda não temos agendamentos nesse dia"),
              ],
            );
          }
          var appointmentsForDay = _getAppointmentsForDay(focusedDay);

          if (_selectedCoworker != null) {
            appointmentsForDay = appointmentsForDay
                .where((appointment) => appointment.coworkerId == _selectedCoworker!.id)
                .toList();
          }

          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: appointmentsForDay.length,
            itemBuilder: (context, index) {
              final appointment = appointmentsForDay[index];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("offering_${OfferingRepository().uidOffering}")
                    .doc(appointment.offeringId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text("..."));
                  }
                  if (snapshot.hasError) {
                    return const Text('...');
                  }
                  final serviceName = snapshot.data?['name'] ?? 'Serviço não encontrado';
                  return ListTile(
                    onTap: () => _showAppointmentDetailsDialog(appointment, serviceName),
                    leading: Text("${appointment.dateTime.hour}:${appointment.dateTime.minute}"),
                    title: Text(serviceName),
                    subtitle: Text(appointment.clientName),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
