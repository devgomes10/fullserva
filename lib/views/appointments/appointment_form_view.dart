import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/views/components/modals/modal_offerings.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/offering.dart';
import '../components/modals/modal_coworkers.dart';

class AppointmentFormView extends StatefulWidget {
  const AppointmentFormView({Key? key}) : super(key: key);

  @override
  State<AppointmentFormView> createState() => _AppointmentFormViewState();
}

class _AppointmentFormViewState extends State<AppointmentFormView> {
  final AppointmentController _appointmentController = AppointmentController();
  final _formKey = GlobalKey<FormState>();
  final String _uniqueId = const Uuid().v4();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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
                    label:
                        _selectedCoworkerId?.name ?? "Selecione um colaborador",
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
    required onPressed,
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
              child: _selectedDate != null
                  ? Text(
                      "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}")
                  : const Text("Data")),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: ElevatedButton(
            onPressed: _showAvailableTimesModal,
            child: _selectedTime != null
                ? Text(
                    "${_selectedTime!.hour.toString()}:${_selectedTime!.minute.toString()}")
                : const Text("Data"),
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
    if (_selectedOfferingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione um serviço primeiro"),
        ),
      );
    } else {
      final coworker = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => modalCoworkers(
          context: context,
          offeringId: _selectedOfferingId!.id,
        ),
      );
      if (coworker != null) {
        setState(() {
          _selectedCoworkerId = coworker as Coworker;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    if (_selectedCoworkerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione um colaborador primeiro"),
        ),
      );
    } else {
      final selectedDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        selectableDayPredicate: (DateTime date) {
          // checking vacation coworker
          // if (_selectedCoworkerId!.startUnavailable != null &&
          //     _selectedCoworkerId!.endUnavailable != null) {
          //   return !date.isAfter(_selectedCoworkerId!.endUnavailable!) &&
          //       !date.isBefore(_selectedCoworkerId!.startUnavailable!);
          // }
          return true;
        },
      );

      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
        });
      }
    }
  }

  Future<void> _showAvailableTimesModal() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selecione uma data primeiro"),
        ),
      );
    } else {
      List<Appointment> appointments =
          await _getAppointmentsByCoworkerAndDate();

      List<Map<String, TimeOfDay>> busyTimes =
          _calculateBusyTimes(appointments);

      List<TimeOfDay> availableTimes = await _getAvailableTimes(busyTimes);

      _displayAvailableTimesModal(availableTimes);
    }
  }

  Future<List<Appointment>> _getAppointmentsByCoworkerAndDate() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("appointment")
          .where("coworkerId", isEqualTo: _selectedCoworkerId!.id)
          .where(
            "dateTime",
            isEqualTo: Timestamp.fromDate(
              DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
              ),
            ),
          )
          .get();

      List<Appointment> appointments = [];

      for (var doc in querySnapshot.docs) {
        Appointment appointment =
            Appointment.fromMap(doc.data() as Map<String, dynamic>);
        appointments.add(appointment);
      }

      return appointments;
    } catch (error) {
      print("Erro ao buscar os agendamentos: $error");
      rethrow;
    }
  }

  List<Map<String, TimeOfDay>> _calculateBusyTimes(
      List<Appointment> appointments) {
    List<Map<String, TimeOfDay>> busyTimes = [];

    for (var appointment in appointments) {
      // Obtenção do horário inicial do agendamento
      DateTime startDateTime = appointment.dateTime;

      // Obtenção do ID do serviço associado ao agendamento
      String offeringId = appointment.offeringId;

      // Consulta ao Firestore para obter os detalhes do serviço
      FirebaseFirestore.instance
          .collection('offering')
          .doc(offeringId)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          // Extrair a duração do serviço (em minutos) do documento obtido
          int serviceDuration =
              (snapshot.data() as Map<String, dynamic>)['duration'];

          // Cálculo do horário final (horário inicial + duração do serviço)
          DateTime endDateTime =
              startDateTime.add(Duration(minutes: serviceDuration));

          // Criar mapa com os horários ocupados (start e end)
          Map<String, TimeOfDay> busyTime = {
            'start': TimeOfDay.fromDateTime(startDateTime),
            'end': TimeOfDay.fromDateTime(endDateTime),
          };

          // Adicionar o mapa à lista de horários ocupados
          busyTimes.add(busyTime);
        }
      });
    }

    return busyTimes;
  }

  Future<List<TimeOfDay>> _getAvailableTimes(
    List<Map<String, TimeOfDay>> busyTimes,
  ) async {
    bool isTimeAfter(TimeOfDay time1, TimeOfDay time2) {
      return time1.hour > time2.hour ||
          (time1.hour == time2.hour && time1.minute > time2.minute);
    }

    bool isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
      return time1.hour < time2.hour ||
          (time1.hour == time2.hour && time1.minute < time2.minute);
    }

    List<TimeOfDay> availableTimes =
        await _startTimeToEndTimeList(_selectedDate!);

    for (Map<String, TimeOfDay> busyTime in busyTimes) {
      TimeOfDay startTime = busyTime['start']!;
      TimeOfDay endTime = busyTime['end']!;

      availableTimes = availableTimes.where((availableTime) {
        return !isTimeAfter(availableTime, endTime) &&
            !isTimeBefore(availableTime, startTime);
      }).toList();
    }

    // 3. Retornar a lista de horários disponíveis após a filtragem
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
                        setState(() {
                          _selectedTime = availableTimes[index];
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                          "${availableTimes[index].hour}:${availableTimes[index].minute}"),
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

  void _addAppointment() async {
    if (_formKey.currentState!.validate()) {
      Appointment appointment = Appointment(
        id: _uniqueId,
        clientName: _clientNameController.text,
        coworkerId: _selectedCoworkerId!.id,
        clientPhone: _clientPhoneController.text,
        offeringId: _selectedOfferingId!.id,
        dateTime: DateTime(
          _selectedDate!.day,
          _selectedDate!.month,
          _selectedDate!.year,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ),
        observations: _observationsController.text,
      );
      await _appointmentController.addAppointment(appointment);
      Navigator.pop(context, true);
    }
  }
}
