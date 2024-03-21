import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/views/components/modal_bottom.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/service.dart';
import '../../utils/consts/unique_id.dart';

class AppointmentFormView extends StatefulWidget {
  const AppointmentFormView({super.key});

  @override
  _AppointmentFormViewState createState() => _AppointmentFormViewState();
}

class _AppointmentFormViewState extends State<AppointmentFormView> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  final _clientNameController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _employeeEmailController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _internalObservationsController = TextEditingController();
  final AppointmentController _appointmentController = AppointmentController();
  final ServiceController _serviceController = ServiceController();
  late List<Service> _services = [];
  late Service? _selectedService =
      _services.isNotEmpty ? _services.first : null;

  @override
  void initState() {
    super.initState();
    loadServices();
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _employeeEmailController.dispose();
    _clientEmailController.dispose();
    _internalObservationsController.dispose();
    super.dispose();
  }

  Future<void> loadServices() async {
    _serviceController.getService().listen((List<Service> event) {
      setState(() {
        _services = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Novo Agendamento"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _clientNameController,
                    decoration: InputDecoration(
                      labelText: 'Nome do cliente',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do cliente';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _clientEmailController,
                    decoration: InputDecoration(
                      labelText: 'Email do cliente',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o email do cliente';
                      }
                      if (!value.contains('@')) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 26),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: '(##) #####-####',
                      )
                    ],
                    controller: _clientPhoneController,
                    decoration: InputDecoration(
                      labelText: 'Telefone do cliente',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
                  SizedBox(
                    child: DropdownButtonFormField<Service>(
                      hint: const Text("Escolha um serviço"),
                      value: _selectedService,
                      items: _services
                          .map(
                            (service) => DropdownMenuItem<Service>(
                              value: service,
                              child: Text(service.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedService = value!;
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
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context, // Passar o contexto capturado aqui
                        builder: (BuildContext context) => modalBottomSheet(context: context),
                      );
                    },
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "aqui",
                      ),
                    ),
                  ),
                  // escolher o colaborador

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
                  const SizedBox(height: 26),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: _internalObservationsController,
                    decoration: InputDecoration(
                      labelText: 'Observações Internas (Opcional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    maxLength: 100,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Appointment appointment = Appointment(
                          id: uniqueId,
                          clientName: _clientNameController.text,
                          clientEmail: _clientEmailController.text,
                          employeeEmail: _employeeEmailController.text,
                          clientPhone: _clientPhoneController.text,
                          serviceId: _selectedService!.id,
                          dateTime: selectedDate!,
                          internalObservations:
                              _internalObservationsController.text,
                        );
                        await _appointmentController
                            .addAppointment(appointment);
                        Navigator.pop(context, true);
                      }
                    },
                    style: ElevatedButton.styleFrom(),
                    child: const Text('ADICIONAR'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
