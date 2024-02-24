import 'package:flutter/material.dart';
import 'package:fullserva/controllers/employee_controller.dart';
import 'package:fullserva/domain/entities/employee.dart';
import 'package:fullserva/domain/entities/service.dart';
import 'package:fullserva/controllers/service_controller.dart';
import 'package:uuid/uuid.dart';

class EmployeeFormView extends StatefulWidget {
  final Employee? model;

  const EmployeeFormView({Key? key, this.model}) : super(key: key);

  @override
  State<EmployeeFormView> createState() => _EmployeeFormViewState();
}

class _EmployeeFormViewState extends State<EmployeeFormView> {
  String uniqueId = const Uuid().v4();
  final _formKey = GlobalKey<FormState>();
  EmployeeController _employeeController = EmployeeController();
  int _selectedServices = 0;
  List<bool> _isRole = [false, false, false];
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  List<String> _servicesId = [];
  int _role = 0;
  List<Service> _availableServices = [];
  ServiceController _serviceController = ServiceController();
  Map<String, bool> _isChecked = {};

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      _nameController.text = widget.model!.name;
      _emailController.text = widget.model!.email;
      _passwordController.text = widget.model!.password;
      _phoneController.text = widget.model!.phone;
      // _servicesIdList = widget.model!.servicesIdList;
    }
    _fetchAvailableServices();
  }

  void _fetchAvailableServices() {
    _serviceController.getService().listen((services) {
      setState(() {
        _availableServices = services;
        _isChecked = Map.fromIterable(services,
            key: (service) => service.id, value: (_) => false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo colaborador"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ToggleButtons(
                children: const [
                  Text("Operacional"),
                  Text("Assistente"),
                  Text("Administração"),
                ],
                isSelected:
                    List.generate(_isRole.length, (index) => index == _role),
                onPressed: (int newIndex) {
                  setState(() {
                    _role = newIndex;
                  });
                  print(_role);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'E-mail de acesso'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha de acesso'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration:
                    const InputDecoration(labelText: 'Telefone do Colaborador'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                hint: Text("Serviços: $_selectedServices"),
                items: _availableServices
                    .map((service) => DropdownMenuItem(
                          value: service.id,
                          child: CheckboxListTile(
                            title: Text(service.name),
                            value: _isChecked[service.id],
                            onChanged: (value) {
                              setState(() {
                                _isChecked[service.id] = value!;
                                if (value!) {
                                  _servicesId.add(service.id);
                                  _selectedServices++;
                                } else {
                                  _servicesId.remove(service.id);
                                  _selectedServices--;
                                }
                              });
                            },
                          ),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Employee employee = Employee(
                      id: uniqueId,
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      phone: _phoneController.text,
                      role: _role,
                      serviceIds: _servicesId,
                    );

                    await _employeeController.addEmployee(employee);
                  }
                },
                child: Text("ADICIONAR"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
