import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/utils/formatting/minutes_to_time_of_day.dart';
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
      return;
    }

    try {
      List<Appointment> appointments = await _getAppointmentsByCoworkerAndDate();
      List<Map<String, TimeOfDay>> busyTimes = await _calculateBusyTimes(appointments);

      // if (busyTimes.isEmpty) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text("Não há horários ocupados para esta data"),
      //     ),
      //   );
      //   return;
      // }

      List<TimeOfDay> availableTimes = await _getAvailableTimes(busyTimes);
      _displayAvailableTimesModal(availableTimes);
    } catch (error) {
      print("Erro ao mostrar os horários disponíveis: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao carregar os horários disponíveis"),
        ),
      );
    }
  }


  Future<List<Appointment>> _getAppointmentsByCoworkerAndDate() async {
    try {
      // print(_selectedCoworkerId!.id);
      // print(
      //     "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("appointment")
          .where("coworkerId", isEqualTo: _selectedCoworkerId!.id)
          .where("dateTime",
              isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  0,
                  0,
                  0)))
          .where("dateTime",
              isLessThanOrEqualTo: Timestamp.fromDate(DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  23,
                  59,
                  59)))
          .get();

      // if (querySnapshot.docs.isNotEmpty) {
      //   for (var doc in querySnapshot.docs) {
      //     print("Data e hora: ${doc.exists}");
      //     print("Agendamento ID: ${doc.id}");
      //     print("Nome do cliente: ${doc.data()}");
      //     print("Data e hora: ${doc.get("dateTime")}");
      //   }
      // } else {
      //   print("nenhum resultado do filtro");
      // }

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

      // if (appointments.isNotEmpty) {
      //   for (var appointment in appointments) {
      //     print("Agendamento ID: ${appointment.id}");
      //     print("Nome do cliente: ${appointment.clientName}");
      //     print("Data e hora: ${appointment.dateTime}");
      //   }
      // } else {
      //   print(
      //       "Nenhum agendamento encontrado para o colaborador e data selecionados.");
      // }

      return appointments;
    } catch (error) {
      print("Erro ao buscar os agendamentos: $error");
      rethrow;
    }
  }

  Future<List<Map<String, TimeOfDay>>> _calculateBusyTimes(
      List<Appointment> appointments) async {
    List<Map<String, TimeOfDay>> busyTimes = [];

    try {
      for (var appointment in appointments) {
        // Obtenção do horário inicial do agendamento
        DateTime startDateTime = appointment.dateTime;
        // print("data e hora inicial: $startDateTime");

        // Obtenção do ID do serviço associado ao agendamento
        String offeringId = appointment.offeringId;
        // print("id do serviço: $offeringId");

        // Consulta ao Firestore para obter os detalhes do serviço
        DocumentSnapshot offeringSnapshot = await FirebaseFirestore.instance
            .collection('offering')
            .doc(offeringId)
            .get();
        // print("consulta do serviço: $offeringSnapshot");

        if (offeringSnapshot.exists) {
          // Extrair a duração do serviço (em minutos) do documento obtido
          int serviceDuration = offeringSnapshot['duration'];
          // print("duração do serviço: $serviceDuration");

          // Cálculo do horário final (horário inicial + duração do serviço)
          DateTime endDateTime =
          startDateTime.add(Duration(minutes: serviceDuration));
          // print("data e hora final: $endDateTime");

          // Criar mapa com os horários ocupados (start e end)
          Map<String, TimeOfDay> busyTime = {
            'start': TimeOfDay.fromDateTime(startDateTime),
            'end': TimeOfDay.fromDateTime(endDateTime),
          };
          // print("busyTime: $endDateTime");

          // Adicionar o mapa à lista de horários ocupados
          busyTimes.add(busyTime);
          // print("o retorno busyTimes: $busyTimes");
        }
      }
    } catch (error) {
      print("Erro ao calcular horários ocupados: $error");
      return [];
    }

    // Retornar a lista de horários ocupados calculados
    return busyTimes;
  }

  Future<List<TimeOfDay>> _getAvailableTimes(List<Map<String, TimeOfDay>> busyTimes) async {
    // 1. Obter a lista completa de horários disponíveis para o dia selecionado
    List<TimeOfDay> availableTimes = await _startTimeToEndTimeList(_selectedDate!);

    // 2. Criar uma lista de intervalos ocupados com início e fim
    List<TimeOfDay> busyStartTimes = [];
    List<TimeOfDay> busyEndTimes = [];

    for (var busyTime in busyTimes) {
      busyStartTimes.add(busyTime['start']!);
      busyEndTimes.add(busyTime['end']!);
    }

    // 3. Filtrar os horários disponíveis removendo os intervalos ocupados
    List<TimeOfDay> filteredTimes = [];

    for (var time in availableTimes) {
      bool isAvailable = true;

      // Verificar se o horário atual está dentro de qualquer intervalo ocupado
      for (int i = 0; i < busyStartTimes.length; i++) {
        if (_isTimeInInterval(time, busyStartTimes[i], busyEndTimes[i])) {
          isAvailable = false;
          break;
        }
      }

      // Se o horário estiver disponível, adicionar à lista filtrada
      if (isAvailable) {
        filteredTimes.add(time);
      }
    }

    // 4. Retornar a lista de horários disponíveis após a filtragem
    return filteredTimes;
  }

  bool _isTimeInInterval(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    if (time.hour > start.hour && time.hour < end.hour) {
      return true; // O horário está dentro do intervalo
    } else if (time.hour == start.hour && time.minute >= start.minute) {
      return true; // O horário é igual ou depois do horário de início
    } else if (time.hour == end.hour && time.minute < end.minute) {
      return true; // O horário é igual ou antes do horário de término
    }
    return false; // O horário está fora do intervalo ocupado
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
      bool isWorking = data['working'] ?? false;

      if (isWorking) {
        int startTime = data['startTime'];
        int endTime = data['endTime'];

        TimeOfDay startTimeOfDay = minutesToTimeOfDay(startTime);
        TimeOfDay endTimeOfDay = minutesToTimeOfDay(endTime);

        List<TimeOfDay> timeList = [];
        TimeOfDay currentTime = startTimeOfDay;
        while (currentTime != endTimeOfDay) {
          timeList.add(currentTime);
          int minutes = currentTime.hour * 60 + currentTime.minute + 15;
          currentTime = minutesToTimeOfDay(minutes);
        }
        timeList.add(endTimeOfDay);
        return timeList;
      } else {
        // se for um dia que não trabalha
        return [];
      }
    } else {
      return [];
    }
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

    // if (_selectedTime != null && _selectedDate != null) {
    //   print("data selecionada: $_selectedDate");
    //   print("horário selecionado: $_selectedTime");
    //   print("${DateTime(
    //     _selectedDate!.day,
    //     _selectedDate!.month,
    //     _selectedDate!.year,
    //     _selectedTime!.hour,
    //     _selectedTime!.minute,
    //   )}");
    // } else {
    //   print("a data e o horário são nulos");
    // }
    if (_formKey.currentState!.validate()) {

      if (_selectedTime != null && _selectedDate != null) {
        print("data selecionada: $_selectedDate");
        print("horário selecionado: $_selectedTime");
        print("${DateTime(
          _selectedDate!.day,
          _selectedDate!.month,
          _selectedDate!.year,
          _selectedTime!.hour,
          _selectedTime!.minute,
        )}");
      } else {
        print("a data e o horário são nulos");
      }

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
