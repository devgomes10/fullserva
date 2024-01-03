import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fullserva/controllers/appointment_controller.dart';
import 'package:fullserva/domain/entities/appointment.dart';
import 'package:uuid/uuid.dart';

class AppointmentFormView extends StatefulWidget {
  @override
  _AppointmentFormViewState createState() => _AppointmentFormViewState();
}

class _AppointmentFormViewState extends State<AppointmentFormView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _serviceController;
  late TextEditingController _dateController;
  late TextEditingController _timeHourController;
  late TextEditingController _timeMinuteController;
  late TextEditingController _clientNameController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _internalObservationsController;
  AppointmentController _controller = AppointmentController();

  @override
  void initState() {
    super.initState();
    _serviceController = TextEditingController();
    _dateController = TextEditingController();
    _timeHourController = TextEditingController();
    _timeMinuteController = TextEditingController();
    _clientNameController = TextEditingController();
    _clientPhoneController = TextEditingController();
    _internalObservationsController = TextEditingController();
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _dateController.dispose();
    _timeHourController.dispose();
    _timeMinuteController.dispose();
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

  Future<void> _selectTimeHour(BuildContext context) async {
    final int picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 200.0,
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              _timeHourController.text = index.toString().padLeft(2, '0');
            },
            children: List.generate(24, (int index) {
              return Center(
                child: Text(index.toString().padLeft(2, '0')),
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> _selectTimeMinute(BuildContext context) async {
    final int picked = await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 200.0,
          child: CupertinoPicker(
            itemExtent: 32.0,
            onSelectedItemChanged: (int index) {
              _timeMinuteController.text = (index * 5).toString().padLeft(2, '0');
            },
            children: List.generate(12, (int index) {
              return Center(
                child: Text((index * 5).toString().padLeft(2, '0')),
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Agendamento"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _clientNameController,
                decoration: InputDecoration(labelText: 'Nome do Cliente'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, digite o nome do cliente';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _clientPhoneController,
                decoration: InputDecoration(labelText: 'Telefone do Cliente'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, digite o telefone do cliente';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serviceController,
                decoration: InputDecoration(labelText: 'Serviço'),
                onTap: () async {
                  // Implemente a lógica para abrir uma caixa de seleção de serviços
                  // e definir o valor escolhido no _serviceController
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, escolha um serviço';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Data'),
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
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTimeHour(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _timeHourController,
                          decoration: InputDecoration(labelText: 'Hora'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, escolha uma hora';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTimeMinute(context),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _timeMinuteController,
                          decoration: InputDecoration(labelText: 'Minutos'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor, escolha os minutos';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _internalObservationsController,
                decoration: InputDecoration(labelText: 'Observações Internas (Opcional)'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Crie uma instância de Appointment com os dados do formulário
                    Appointment appointment = Appointment(
                      id: const Uuid().v4(),
                      clientName: _clientNameController.text,
                      clientPhone: _clientPhoneController.text,
                      serviceId: _serviceController.text,
                      dateTime: DateTime(
                        int.parse(_dateController.text.split('-')[0]),
                        int.parse(_dateController.text.split('-')[1]),
                        int.parse(_dateController.text.split('-')[2]),
                        int.parse(_timeHourController.text),
                        int.parse(_timeMinuteController.text),
                      ),
                      internalObservations: _internalObservationsController.text,
                    );

                    // Chame a função para adicionar o compromisso
                    await _controller.addAppointment(appointment);

                    // Volte para a tela anterior ou faça outra ação desejada
                    Navigator.pop(context, true); // Passa true para indicar que o formulário foi concluído com sucesso
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
