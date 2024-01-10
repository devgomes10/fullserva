import 'package:flutter/material.dart';
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
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  late TextEditingController _clientNameController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _internalObservationsController;
  final AppointmentController _controller = AppointmentController();
  final ServiceController serviceController = ServiceController();
  late List<Service> services = [];
  late Service? selectedService = services.isNotEmpty ? services.first : null;
  @override
  void initState() {
    super.initState();
    _clientNameController = TextEditingController();
    _clientPhoneController = TextEditingController();
    _internalObservationsController = TextEditingController();
    loadServices();
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _internalObservationsController.dispose();
    super.dispose();
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
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
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
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              SizedBox(
                width: 280,
                child: DropdownButtonFormField<Service>(
                  hint: const Text("Escolha um serviço"),
                  icon: const Icon(Icons.build_outlined),
                  value: selectedService,
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
                      selectedService = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Obrigatório';
                    }
                    return null;
                  },
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      const Text("Data"),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? dateTime = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                          );
                          if (dateTime != null) {
                            setState(() {
                              selectedDate = dateTime;
                            });
                          }
                        },
                        child: Text(
                            "${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Hora"),
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
                        child: Text(
                            "${selectedTime.hour} : ${selectedTime.minute}"),
                      ),
                    ],
                  ),
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
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );

                    if (selectedService != null) {
                      Appointment appointment = Appointment(
                        id: const Uuid().v4(),
                        clientName: _clientNameController.text,
                        clientPhone: _clientPhoneController.text,
                        serviceId: selectedService!.id,
                        dateTime: dateTime,
                        internalObservations: _internalObservationsController.text,
                      );

                      await _controller.addAppointment(appointment);

                      Navigator.pop(context, true);
                    } else {
                      // Lógica para lidar com o caso em que selectedService é nulo
                      // Pode ser exibida uma mensagem de erro ou outra ação apropriada
                    }
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
