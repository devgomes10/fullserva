import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:fullserva/domain/entities/employee.dart';
import 'package:fullserva/views/components/modal_coworkers.dart';
import 'package:fullserva/views/components/modal_offerings.dart';
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
  Service? _offering;
  Employee? _coworker;
  final _internalObservationsController = TextEditingController();
  final AppointmentController _appointmentController = AppointmentController();

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _employeeEmailController.dispose();
    _clientEmailController.dispose();
    _internalObservationsController.dispose();
    super.dispose();
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
                  ElevatedButton(
                    onPressed: () async {
                      final offering = await showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => modalOfferings(
                          context: context,
                        ),
                      );
                      if (offering != null) {
                        setState(() {
                          _offering = offering as Service;
                        });
                      }
                    },
                    child: Text(_offering?.name ?? "Selecione um serviço"),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                  ),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: () async {
                      final coworker = await showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => modalCoworkers(
                          context: context,
                        ),
                      );
                      if (coworker != null) {
                        setState(() {
                          _coworker = coworker as Employee;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 50),
                    ),
                    child: Text(_coworker?.name ?? "Selecione um colaborador"),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text("Data"),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          child: Text("Hora"),
                        ),
                      ),
                    ],
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
                          serviceId: _offering!.id,
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
