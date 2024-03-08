// import 'package:flutter/material.dart';
//
// import '../../controllers/appointment_controller.dart';
//
// class AppointmentsView extends StatefulWidget {
//   const AppointmentsView({super.key});
//
//   @override
//   State<AppointmentsView> createState() => _AppointmentsViewState();
// }
//
// class _AppointmentsViewState extends State<AppointmentsView> {
//   late final AppointmentController _appointmentController;
//   late final DateTime _firstDay;
//   late final DateTime _lastDay;
//   late final DateTime _focusedDay;
//   late final DateTime _selectedDay;
//
//   @override
//   void initState() {
//     super.initState();
//     _appointmentController = AppointmentController();
//     _firstDay = DateTime.now().add(const Duration(days: -365));
//     _lastDay = DateTime.now().add(const Duration(days: 365));
//     _focusedDay = DateTime.now();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

import 'package:flutter/material.dart';
import 'package:fullserva/data/repositories/appointment_repository.dart';
import 'package:fullserva/views/appointments/appointment_form_view.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../domain/entities/appointment.dart';

class AppointmentView extends StatefulWidget {
  const AppointmentView({super.key});

  @override
  _AppointmentViewState createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late final Map<DateTime, List<Appointment>> _events;
  late final List<Appointment> _selectedEvents;
  late final ValueNotifier<List<Appointment>> _selectedEventsNotifier;
  late final CalendarFormat _calendarFormat;
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _firstDay = DateTime.now().add(const Duration(days: -365));
    _lastDay = DateTime.now().add(const Duration(days: 365));
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _events = {};
    _selectedEvents = [];
    _selectedEventsNotifier = ValueNotifier(_selectedEvents);
    _calendarFormat = CalendarFormat.month;
    _loadAppointments(_selectedDay);
    _isLoading = false; // Inicializar como falso, pois não estamos carregando os agendamentos inicialmente
  }

  Future<void> _loadAppointments(DateTime day) async {
    try {
      // Exibir CircularProgressIndicator durante o carregamento
      setState(() {
        _isLoading = true;
      });

      final appointments = await AppointmentRepository().getAppointmentsForDay(day);

      setState(() {
        _events.clear();
        _events[day] = appointments;
        _selectedEvents.clear();
        _selectedEvents.addAll(appointments);
        _selectedEventsNotifier.value = _selectedEvents;
        _isLoading = false; // Remover CircularProgressIndicator quando o carregamento estiver completo
      });

      // Verificar se não há agendamentos disponíveis
      if (appointments.isEmpty) {
        print('Nenhum agendamento disponível para o dia $day');
      }
    } catch (error) {
      print('Erro ao carregar os agendamentos: $error');
      // Tratar o erro conforme necessário
      setState(() {
        _isLoading = false; // Remover CircularProgressIndicator em caso de erro
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
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
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = focusedDay;
                _loadAppointments(_selectedDay);
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _loadAppointments(_selectedDay);
              });
            },
          ),
          // Exibir CircularProgressIndicator se isLoading for verdadeiro
          if (_isLoading) CircularProgressIndicator(),
          Expanded(
            child:
            ValueListenableBuilder<List<Appointment>>(
              valueListenable: _selectedEventsNotifier,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: _selectedEvents.length,
                  itemBuilder: (context, index) {
                    final appointment = _selectedEvents[index];
                    return ListTile(
                      title: Text(appointment.clientName),
                      subtitle: Text(
                          'Serviço: ${appointment.serviceId}, Hora: ${appointment.dateTime}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Appointment> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }
}
