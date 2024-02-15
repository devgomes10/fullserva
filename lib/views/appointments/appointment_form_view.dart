import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/service.dart';

class AppointmentFormView extends StatefulWidget {
  final Appointment? model;

  const AppointmentFormView({super.key, this.model});

  @override
  _AppointmentFormViewState createState() => _AppointmentFormViewState();
}

class _AppointmentFormViewState extends State<AppointmentFormView> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _internalObservationsController = TextEditingController();
  final AppointmentController _controller = AppointmentController();
  final ServiceController serviceController = ServiceController();
  String uniqueId = const Uuid().v4();
  late List<Service> services = [];
  late Service? selectedService = services.isNotEmpty ? services.first : null;

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      selectedDate = widget.model!.dateTime;
      _clientNameController.text = widget.model!.clientName;
      _clientPhoneController.text = widget.model!.clientPhone;
      _internalObservationsController.text =
          widget.model!.internalObservations!;
      // selectedService = widget.model!.serviceId as Service?;
    }
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
    final appointmentModel = widget.model;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Agendamento"),
        actions: appointmentModel != null ? [
          IconButton(
            onPressed: () async {
              await _controller.removeAppointment(appointmentModel.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ] : null,
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
              ElevatedButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(
                    context,
                    locale: LocaleType.pt,
                    showTitleActions: true,
                    onConfirm: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    onChanged: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    currentTime: DateTime.now(),
                  );
                },
                child: Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} ${selectedDate!.hour}:${selectedDate!.minute}'
                      : 'Selecionar Data e Hora',
                ),
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
                    Appointment appointment = Appointment(
                      id: appointmentModel?.id ?? uniqueId,
                      clientName: _clientNameController.text,
                      clientPhone: _clientPhoneController.text,
                      serviceId: selectedService!.id,
                      dateTime: selectedDate!,
                      internalObservations: _internalObservationsController.text,
                    );

                    if (appointmentModel != null) {
                      await _controller.updateAppointment(appointment);
                    } else {
                      await _controller.addAppointment(appointment);
                    }

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
