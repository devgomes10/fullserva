import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullserva/booking_page/show_phone_appointments.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/data/repositories/appointment_repository.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/entities/coworker.dart';
import 'package:fullserva/utils/formatting/format_time_of_day.dart';
import 'package:fullserva/views/components/modals/modal_offerings.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/offering.dart';
import '../views/components/modals/modal_coworkers.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final AppointmentController _appointmentController = AppointmentController();
  final AppointmentRepository _appointmentRepository = AppointmentRepository();

  final _formKey = GlobalKey<FormState>();
  final String _uniqueId = const Uuid().v4();

  final searchByPhone = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();

  Offering? _selectedOfferingId;
  Coworker? _selectedCoworkerId;

  String? urlPhoto;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showPhoneAppointments(context: context);
                      },
                      child: const Text("Meus agendamentos"),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                (urlPhoto != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(64),
                        child: Image.network(
                          urlPhoto!,
                          height: 128,
                          width: 128,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        child: Icon(Icons.person),
                      ),
                SizedBox(height: 16),
                Text("Nome da empresa"),
                Form(
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
                        label:
                            _selectedOfferingId?.name ?? "Selecione um serviço",
                        onPressed: () => _selectOffering(),
                      ),
                      const SizedBox(height: 26),
                      _buildElevatedButton(
                        label: _selectedCoworkerId?.name ??
                            "Selecione um colaborador",
                        onPressed: () => _selectCoworker(),
                      ),
                      const SizedBox(height: 26),
                      _buildDateAndTimeButtons(),
                      const SizedBox(height: 42),
                      _buildElevatedButton(
                        label: 'ADICIONAR',
                        onPressed: () => _addAppointment(),
                      ),
                    ],
                  ),
                ),
              ],
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
                : const Text("Hora"),
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
        _selectedCoworkerId = null;
        _selectedDate = null;
        _selectedTime = null;
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
          _selectedDate = null;
          _selectedTime = null;
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
          if (_selectedCoworkerId!.startUnavailable != null &&
              _selectedCoworkerId!.endUnavailable != null) {
            // Verifica se a data está dentro do intervalo de indisponibilidade
            if (date.isAfter(_selectedCoworkerId!.startUnavailable!
                    .subtract(const Duration(days: 1))) &&
                date.isBefore(_selectedCoworkerId!.endUnavailable!)) {
              return false; // Dia indisponível
            } else {
              return true; // Dia disponível
            }
          }
          // Se não houver intervalo de indisponibilidade definido, todos os dias são selecionáveis
          return true;
        },
      );

      if (selectedDate != null) {
        setState(() {
          _selectedDate = selectedDate;
          _selectedTime = null;
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
      List<Appointment> appointments =
          await _appointmentRepository.getAppointmentsByCoworkerAndDate(
        _selectedCoworkerId,
        _selectedDate,
      );

      List<Map<String, TimeOfDay>> busyTimes =
          await _appointmentRepository.calculateBusyTimes(
        appointments,
        _selectedOfferingId,
      );

      List<TimeOfDay> availableTimes =
          await _appointmentRepository.getAvailableTimes(
        busyTimes,
        _selectedDate,
        _selectedOfferingId,
      );

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
                      child: Text(formatTimeOfDay(availableTimes[index])),
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
        observations: null,
      );
      await _appointmentController.addAppointment(appointment);
    }
  }
}
