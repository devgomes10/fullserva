import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import '../domain/entities/service.dart';

class AppointmentFormView extends StatefulWidget {
  const AppointmentFormView({super.key});

  @override
  _AppointmentFormViewState createState() => _AppointmentFormViewState();
}

class _AppointmentFormViewState extends State<AppointmentFormView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serviceController;
  late TextEditingController _dateController;
  TimeOfDay selectedTime = TimeOfDay.now();
  late TextEditingController _clientNameController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _internalObservationsController;
  final AppointmentController _controller = AppointmentController();
  final ServiceController serviceController = ServiceController();
  late List<Service> services = [];

  @override
  void initState() {
    super.initState();
    _serviceController = TextEditingController();
    _dateController = TextEditingController();
    _clientNameController = TextEditingController();
    _clientPhoneController = TextEditingController();
    _internalObservationsController = TextEditingController();
    _serviceController = TextEditingController();
    loadServices();
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _dateController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _internalObservationsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> loadServices() async {
    serviceController.getService().listen((List<Service> event) {
      setState(() {
        services = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Agendamento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _clientNameController,
                decoration: const InputDecoration(labelText: 'Nome do Cliente'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Digite o nome do cliente';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '(##) #####-####',
                    filter: {"#": RegExp(r'[0-9]')},
                  )
                ],
                controller: _clientPhoneController,
                decoration:
                    const InputDecoration(labelText: 'Telefone do Cliente'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, digite o telefone do cliente';
                  }
                  return null;
                },
              ),
              SizedBox(
                width: 280,
                child: DropdownButtonFormField<Service>(
                  hint: const Text("Escolha um serviço"),
                  icon: const Icon(Icons.build_outlined),
                  value: services.isEmpty ? null : services.first,
                  items: services
                      .map(
                        (service) => DropdownMenuItem<Service>(
                          value: service,
                          child: Text(service.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _serviceController.text = value?.name ?? '';
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Data'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, escolha uma data';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        initialEntryMode: TimePickerEntryMode.dial,
                      );
                      if (timeOfDay != null) {
                        setState(() {
                          selectedTime = timeOfDay;
                        });
                      }
                    },
                    child: const Text("selecione o Horário"),
                  ),
                  Text("${selectedTime.hour} : ${selectedTime.minute}"),
                ],
              ),
              TextFormField(
                controller: _internalObservationsController,
                decoration: const InputDecoration(
                    labelText: 'Observações Internas (Opcional)'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    DateTime dateTime = DateTime(
                      int.parse(_dateController.text.split('-')[0]), // Ano
                      int.parse(_dateController.text.split('-')[1]), // Mês
                      int.parse(_dateController.text.split('-')[2]), // Dia
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    Appointment appointment = Appointment(
                      id: const Uuid().v4(),
                      clientName: _clientNameController.text,
                      clientPhone: _clientPhoneController.text,
                      serviceId: _serviceController.text,
                      dateTime: dateTime,
                      internalObservations:
                          _internalObservationsController.text,
                    );

                    await _controller.addAppointment(appointment);

                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
