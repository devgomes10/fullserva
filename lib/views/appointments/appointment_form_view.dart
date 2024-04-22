import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/views/components/modal_coworkers.dart';
import 'package:fullserva/views/components/modal_offerings.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/offering.dart';

class AppointmentFormView extends StatefulWidget {
  const AppointmentFormView({Key? key}) : super(key: key);

  @override
  State<AppointmentFormView> createState() => _AppointmentFormViewState();
}

class _AppointmentFormViewState extends State<AppointmentFormView> {
  final AppointmentController _appointmentController = AppointmentController();
  final _formKey = GlobalKey<FormState>();
  final String _uniqueId = const Uuid().v4();

  DateTime _selectedDate = DateTime.now();
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _observationsController = TextEditingController();

  Offering? _selectedOfferingId;
  Coworker? _selectedCoworkerId;

  List<DateTime> unavailableDates = [
    DateTime(2024, 3, 31),
    DateTime(2024, 4, 4),
    DateTime(2024, 4, 15),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("NOVO AGENDAMENTO"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 26),
                  _buildTextFormField(
                    label: 'Nome do cliente',
                    controller: _clientNameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do cliente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  _buildTextFormField(
                    label: 'Telefone do cliente',
                    controller: _clientPhoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '(##) #####-####',
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o telefone do cliente';
                      }
                      if (value.length < 15) {
                        return 'Por favor, insira um número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  _buildElevatedButton(
                    label: _selectedOfferingId?.name ?? "Selecione um serviço",
                    onPressed: () => _selectOffering(),
                  ),
                  const SizedBox(height: 26),
                  _buildElevatedButton(
                    label: _selectedCoworkerId?.name ?? "Selecione um colaborador",
                    onPressed: () => _selectCoworker(),
                  ),
                  const SizedBox(height: 26),
                  _buildDateAndTimeButtons(),
                  const SizedBox(height: 26),
                  _buildTextFormField(
                    label: 'Observações',
                    controller: _observationsController,
                    keyboardType: TextInputType.multiline,
                    maxLength: 100,
                  ),
                  const SizedBox(height: 42),
                  _buildElevatedButton(
                    label: 'ADICIONAR',
                    onPressed: () => _addAppointment(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: validator,
      maxLength: maxLength,
    );
  }

  Widget _buildElevatedButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
      ),
      child: Text(label),
    );
  }

  Widget _buildDateAndTimeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _selectDate,
            child: Text(
              "Data: ${_selectedDate != null ? _selectedDate.toString() : 'Selecione uma data'}",
            ),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: ElevatedButton(
            onPressed: _showAvailableTimesModal,
            child: const Text("Hora"),
          ),
        ),
      ],
    );
  }

  void _selectOffering() async {
    final offering = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => modalOfferings(
        context: context,
      ),
    );
    if (offering != null) {
      setState(() {
        _selectedOfferingId = offering as Offering;
      });
    }
  }

  void _selectCoworker() async {
    final coworker = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => modalCoworkers(
        context: context,
      ),
    );
    if (coworker != null) {
      setState(() {
        _selectedCoworkerId = coworker as Coworker;
      });
    }
  }

  Future<void> _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now().add(const Duration(days: -365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (DateTime date) {
        return !unavailableDates.contains(date);
      },
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  Future<void> _showAvailableTimesModal() async {
    if (!_isServiceSelected || !_isCoworkerSelected || !_isDateSelected) {
      _showSnackbar("Selecione primeiro um serviço, um colaborador e uma data.");
      return;
    }

    List<Appointment> appointments = await _getAppointmentsByCoworkerAndDate();

    List<DateTime> busyTimes = _calculateBusyTimes(appointments);

    List<TimeOfDay> availableTimes = await _getAvailableTimes(busyTimes);

    _displayAvailableTimesModal(availableTimes);
  }

  Future<List<Appointment>> _getAppointmentsByCoworkerAndDate() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("appointments")
          .where("coworkerId", isEqualTo: _selectedCoworkerId!.id)
          .where("dateTime", isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 0, 0, 0)))
          .where("dateTime", isLessThanOrEqualTo: Timestamp.fromDate(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59)))
          .get();

      List<Appointment> appointments = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Appointment(
          id: data['id'],
          clientName: data['clientName'],
          coworkerId: data['coworkerId'],
          clientPhone: data['clientPhone'],
          offeringId: data['offeringId'],
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          observations: data['observations'],
        );
      }).toList();

      return appointments;
    } catch (error) {
      print("Erro ao buscar os agendamentos: $error");
      throw error;
    }
  }

  List<DateTime> _calculateBusyTimes(List<Appointment> appointments) {
    List<DateTime> busyTimes = [];
    for (var appointment in appointments) {
      DateTime startTime = appointment.dateTime;
      DateTime endTime = startTime.add(Duration(minutes: _selectedOfferingId!.duration));
      busyTimes.add(startTime);
      busyTimes.add(endTime);
    }
    return busyTimes;
  }

  Future<List<TimeOfDay>> _getAvailableTimes(List<DateTime> busyTimes) async {
    final List<TimeOfDay> availableTimes = await _startTimeToEndTimeList(_selectedDate);
    availableTimes.removeWhere((time) {
      DateTime dateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, time.hour, time.minute);
      return busyTimes.any((busyTime) => dateTime.isAfter(busyTime) && dateTime.isBefore(busyTimes[busyTimes.indexOf(busyTime) + 1]));
    });
    return availableTimes;
  }

  Future<List<TimeOfDay>> _startTimeToEndTimeList(DateTime dateTime) async {
    final int weekday = dateTime.weekday;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("opening_hours")
        .doc("$weekday")
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      int startTime = data['startTime'];
      int endTime = data['endTime'];

      TimeOfDay startTimeOfDay = _convertMinutesToTimeOfDay(startTime);
      TimeOfDay endTimeOfDay = _convertMinutesToTimeOfDay(endTime);

      List<TimeOfDay> timeList = [];
      TimeOfDay currentTime = startTimeOfDay;
      while (currentTime != endTimeOfDay) {
        timeList.add(currentTime);
        int minutes = currentTime.hour * 60 + currentTime.minute + 15;
        currentTime = _convertMinutesToTimeOfDay(minutes);
      }
      timeList.add(endTimeOfDay);
      return timeList;
    } else {
      return [];
    }
  }

  TimeOfDay _convertMinutesToTimeOfDay(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    return TimeOfDay(hour: hours, minute: remainingMinutes);
  }

  void _displayAvailableTimesModal(List<TimeOfDay> availableTimes) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Selecione um horário disponível',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableTimes.length,
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () {
                        _selectTime(availableTimes[index]);
                      },
                      child: Text("${availableTimes[index].hour}:${availableTimes[index].minute}"),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _selectTime(TimeOfDay time) {}

  void _addAppointment() async {
    if (_formKey.currentState!.validate()) {
      Appointment appointment = Appointment(
        id: _uniqueId,
        clientName: _clientNameController.text,
        coworkerId: _selectedCoworkerId!.id,
        clientPhone: _clientPhoneController.text,
        offeringId: _selectedOfferingId!.id,
        dateTime: _selectedDate,
        observations: _observationsController.text,
      );
      await _appointmentController.addAppointment(appointment);
      Navigator.pop(context, true);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  bool get _isServiceSelected => _selectedOfferingId != null;

  bool get _isCoworkerSelected => _selectedCoworkerId != null;

  bool get _isDateSelected => _selectedDate != null;
}
